using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab02/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
using JLD2

k = 18.0
n = 4.9

fi1 = pi/4
fi2 = 2*pi/3

println("=== Вариант 35 ===")
println("k = $k км, n = $n")
println("fi1 = $(round(fi1*180/pi, digits=1))°")
println("fi2 = $(round(fi2*180/pi, digits=1))°")

r0_1 = k / (n + 1)

r0_2 = k / (n - 1)

println("\nНачальные условия:")
println("Случай 1: r0_1 = k/(n+1) = $k/$(n+1) = $(round(r0_1, digits=4)) км")
println("Случай 2: r0_2 = k/(n-1) = $k/$(n-1) = $(round(r0_2, digits=4)) км")

function f(r, p, theta)
    return r / sqrt(n^2 - 1)
end

tspan1 = (0.0, 2*pi)
prob1 = ODEProblem(f, r0_1, tspan1)
sol1 = solve(prob1, Tsit5(), saveat=0.01)

tspan2 = (-pi, pi)
prob2 = ODEProblem(f, r0_2, tspan2)
sol2 = solve(prob2, Tsit5(), saveat=0.01)

r_meet1 = sol1(fi1)
r_meet2 = sol2(fi2)

println("\nТочки пересечения с траекторией лодки:")
println("Случай 1: r1 = $(round(r_meet1, digits=4)) км, fi1 = $(round(fi1*180/pi, digits=1))°")
println("Случай 2: r2 = $(round(r_meet2, digits=4)) км, fi2 = $(round(fi2*180/pi, digits=1))°")

theta_boat1 = [fi1, fi1]
r_boat1 = [0, 25]

theta_boat2 = [fi2, fi2]
r_boat2 = [0, 25]

p1 = plot(sol1.t, sol1.u, proj=:polar, lims=(0, 22),
          title="Случай 1: катер между полюсом и лодкой\n(угол лодки = $(round(fi1*180/pi, digits=1))°)",
          label="Катер", lw=2, color=:blue)
plot!(p1, theta_boat1, r_boat1, label="Лодка", linestyle=:dash, color=:red, lw=2)
scatter!(p1, [fi1], [r_meet1], label = "Точка пересечения", color=:black, marker=:circle)

p2 = plot(sol2.t, sol2.u, proj=:polar, lims=(0, 22),
          title="Случай 2: полюс между катером и лодкой\n(угол лодки = $(round(fi2*180/pi, digits=1))°)",
          label="Катер", lw=2, color=:green)
plot!(p2, theta_boat2, r_boat2, label="Лодка", linestyle=:dash, color=:red, lw=2)
scatter!(p2, [fi2], [r_meet2], label = "Точка пересечения", color=:black, marker=:circle)

final_plot = plot(p1, p2, layout=(1, 2), size=(1200, 550))

savefig(final_plot, plotsdir("trajectories_var35.png"))
println("\nГрафики сохранены в папку plots/")

@save datadir("results2.jld2") sol1 sol2 r_meet1 r_meet2
