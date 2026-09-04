# ## Модель гармонических колебаний

# Задание 2:
# Записать уравнение свободных колебаний гармонического осциллятора с
# затуханием, построить его решение. Построить фазовый портрет гармонических
# колебаний с затуханием.
# Уравнение:
#
# x'' + 2*g*x' + w^2*x = f(t), где w - частота, g - затухание
#
# Уравнение гармонического осциллятора с затуханием:
#
# x'' + 2*g*x' + w^2* x = 0
#
# Система уравнений первого порядка:
#
# x' = v
#
# v' = -w^2*x -2*g*v

using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab04/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# Параметры 
w = 1.5
g = 0.2

# Начальные условия 
x0 = 1.0 # начальное смещение
v0 = 0.0 # начальная скорость
u0 = [x0, v0] # вектор начальных условий
tspan = (0.0, 40.0) # временной интервал

println("\nУравнение гармонического осциллятора с затуханием:")
println("\nx'' + 2*g*x' + w^2* x = 0")
println("\nСистема уравнений первого порядка:")
println("\nx' = v")
println("\nv' = -w^2*x -2*g*v")

# Функция для решения ОДУ
function osc_s_zatyhaniem!(du, u, p, t)
	w, g = p
	x, v = u
	du[1] = v
	du[2] = -w^2*x -2*g*v
end

prob2 = ODEProblem(osc_s_zatyhaniem!, u0, tspan, [w, g])
sol2 = solve(prob2, Tsit5(), saveat=0.05)

# Извлекаем решение
t2 = sol2.t
x2 = [u[1] for u in sol2.u]
v2 = [u[2] for u in sol2.u]

# График x(t)
p2 =plot(t2, x2, title = "Гармонический осциллятор с затуханием", xlabel = "Время t", ylabel = "Смещение x", legend=false)

# Фазовый портрет
p2_phase =plot(x2, v2, title = "Фазовый портрет (с затуханием)", xlabel = "x", ylabel = "v (скорость)", legend=false)

# Общий график
final_plot = plot(p2, p2_phase , layout=(1, 2), size=(1500, 600))
savefig(final_plot, plotsdir("osc_s_zatyhaniem.png"))
println("Графики сохранены в папку plots")
