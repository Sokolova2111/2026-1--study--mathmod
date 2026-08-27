using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab04/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

w2 = 0.1
g = 10.1

x0 = 0.0 # начальное смещение
v0 = 1.4 # начальная скорость
u0 = [x0, v0] # вектор начальных условий
tspan = (0.0, 33.0) # временной интервал

println("\nУравнение гармонического осциллятора с затуханием:")
println("\nx'' +10.1*x'+ 0.1*x = 0")

function var35_2!(du, u, p, t)
	w2, g = p
	x, v = u
	du[1] = v
	du[2] = -w2*x -g*v
end

prob5 = ODEProblem(var35_2!, u0, tspan, [w2, g])
sol5 = solve(prob5, Tsit5(), saveat=0.05)

t5 = sol5.t
x5 = [u[1] for u in sol5.u]
v5 = [u[2] for u in sol5.u]

p5 =plot(t5, x5, title = "Гармонический осциллятор с затуханием и\nбез действия внешней силы", xlabel = "Время t", ylabel = "Смещение x", legend=false)

p5_phase =plot(x5, v5, title = "Фазовый портрет", xlabel = "x", ylabel = "v (скорость)", legend=false)

final_plot = plot(p5, p5_phase , layout=(1, 2), size=(1500, 700))

savefig(final_plot, plotsdir("var35_2.png"))
println("Графики сохранены в папку plots")
