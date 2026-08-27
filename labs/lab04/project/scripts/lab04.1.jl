# ## Модель гармонических колебаний

# Задание 1:
# Построить решение уравнения гармонического осциллятора без затухания
#
# Уравнение:
#
# x'' + 2*g* x' + w^2* x = f(t), где w - частота, g - затухание
#
# Уравнение гармонического осциллятора без затухания
#
# x'' + w^2* x = 0
#
# Система уравнений первого порядка:
#
# x' = v
#
# v' = -w^2*x

using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab04/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# Параметры 
w = 1.5

# Начальные условия 
x0 = 1.0 # начальное смещение
v0 = 0.0 # начальная скорость
u0 = [x0, v0] # вектор начальных условий
tspan = (0.0, 40.0) # временной интервал

# Функция для решения ОДУ
function osc_bez_zatyhania!(du, u, p, t)
	w = p[1]
	x, v = u
	du[1] = v
	du[2] = -w^2*x
end

prob1 = ODEProblem(osc_bez_zatyhania!, u0, tspan, [w])
sol1 = solve(prob1, Tsit5(), saveat=0.05)

# Извлекаем решение
t1 = sol1.t
x1 = [u[1] for u in sol1.u]
v1 = [u[2] for u in sol1.u]

# График x(t)
p1 =plot(t1, x1, title = "Гармонический осциллятор без затухания", xlabel = "Время t", ylabel = "Смещение x", legend=false)
display(p1)
savefig(p1, plotsdir("graph_bez_zatyhania.png"))
println("График сохранен в папку plots")
