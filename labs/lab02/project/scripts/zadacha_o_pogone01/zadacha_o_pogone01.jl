using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab02/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt = :png)

n = 3.0       # скорость катера больше скорости лодки в n раз (задаём самостоятельно)
k = 12.0      # начальное расстояние между катером и лодкой (задаём самостоятельно)

fi1 = pi/3    # 60°
fi2 = 3*pi/4  # 135°

r0_1 = k / (n + 1)  # Случай 1: катер между полюсом и лодкой
r0_2 = k / (n - 1)  # Случай 2: полюс между катером и лодкой

function trajectory(r, p, theta)
    return r / sqrt(n^2 - 1)
end

prob1 = ODEProblem(trajectory, r0_1, (0.0, 2*pi))
sol1 = solve(prob1, Tsit5(), saveat=0.01)

prob2 = ODEProblem(trajectory, r0_2, (-pi, pi))
sol2 = solve(prob2, Tsit5(), saveat=0.01)

r_meet1 = sol1(fi1)
r_meet2 = sol2(fi2)

p1 = plot(sol1.t, sol1.u, proj=:polar, lims=(0, 25),
          title="Случай 1: катер между полюсом и лодкой",
          label="Катер", lw=2, color=:blue)
plot!(p1, [fi1, fi1], [0, 25], label="Лодка", linestyle=:dash, color=:red, lw=2)
scatter!(p1, [fi1], [r_meet1], label="Точка пересечения", color=:black, marker=:circle)

p2 = plot(sol2.t, sol2.u, proj=:polar, lims=(0, 25),
          title="Случай 2: полюс между катером и лодкой",
          label="Катер", lw=2, color=:green)
plot!(p2, [fi2, fi2], [0, 25], label="Лодка", linestyle=:dash, color=:red, lw=2)
scatter!(p2, [fi2], [r_meet2], label="Точка пересечения", color=:black, marker=:circle)

final_plot = plot(p1, p2, layout=(1, 2), size=(1200, 550))
display(final_plot)
savefig(final_plot, plotsdir("trajectories.png"))

println("\n=== Результаты ===")
println("Дифференциальное уравнение: dr/dtheta = r / sqrt(n^2 - 1)")
println("n = $n, k = $k")
println("Точка пересечения (случай 1): r = $(round(r_meet1, digits=3)), theta = $(round(fi1*180/pi, digits=1))°")
println("Точка пересечения (случай 2): r = $(round(r_meet2, digits=3)), theta = $(round(fi2*180/pi, digits=1))°")
