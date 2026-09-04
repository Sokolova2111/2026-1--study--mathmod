using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab02/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
using JLD2

script_name = "zadacha_o_pogone01"
mkpath(plotsdir(script_name))
mkpath(datadir(script_name))

k = 18.0
n = 4.9
fi = 3*pi/4

println("=== Вариант 35 ===")
println("k = $k км, n = $n, fi = $(round(fi*180/pi, digits=1))°")

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

r_meet1 = sol1(fi)
r_meet2 = sol2(fi)

println("\nТочки пересечения с траекторией лодки:")
println("Случай 1: r1 = $(round(r_meet1, digits=4)) км")
println("Случай 2: r2 = $(round(r_meet2, digits=4)) км")

theta_boat = [fi, fi]
r_boat = [0, 25]

p1 = plot(sol1.t, sol1.u, proj=:polar, lims=(0, 22),
          title="Случай 1: катер между полюсом и лодкой",
          label="Катер", lw=2, color=:blue)
plot!(p1, theta_boat, r_boat, label="Лодка", linestyle=:dash, color=:red, lw=2)

p2 = plot(sol2.t, sol2.u, proj=:polar, lims=(0, 22),
          title="Случай 2: полюс между катером и лодкой",
          label="Катер", lw=2, color=:green)
plot!(p2, theta_boat, r_boat, label="Лодка", linestyle=:dash, color=:red, lw=2)

final_plot = plot(p1, p2, layout=(1, 2), size=(1200, 550))

savefig(final_plot, plotsdir(script_name, "trajectories_var35.png"))

println("\nГрафики сохранены в папку plots/")

@save datadir(script_name, "results.jld2") sol1 sol2 r_meet1 r_meet2
