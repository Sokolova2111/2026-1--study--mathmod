# ## Модель гармонических колебаний
#
# Вариант 35
#
# Задание 1:
# Построить фазовый портрет гармонического осциллятора и решение уравнения
# гармонического осциллятора
#
# Уравнение:
#
# x'' + 7.4*x = 0


using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab04/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# Параметры 
w2 = 7.4

# Начальные условия 
x0 = 0.0 # начальное смещение
v0 = 1.4 # начальная скорость
u0 = [x0, v0] # вектор начальных условий
tspan = (0.0, 33.0) # временной интервал

# Функция для решения ОДУ
function var35_1!(du, u, p, t)
	w2 = p[1]
	x, v = u
	du[1] = v
	du[2] = -w2*x
end

prob4 = ODEProblem(var35_1!, u0, tspan, [w2])
sol4 = solve(prob4, Tsit5(), saveat=0.05)

# Извлекаем решение
t4 = sol4.t
x4 = [u[1] for u in sol4.u]
v4 = [u[2] for u in sol4.u]

# График x(t)
p4 =plot(t4, x4, title = "Гармонический осциллятор без затухания и\nбез действия внешней силы", xlabel = "Время t", ylabel = "Смещение x", legend=false)

# Фазовый портрет
p4_phase =plot(x4, v4, title = "Фазовый портрет", xlabel = "x", ylabel = "v (скорость)", legend=false)

# Общий график
final_plot = plot(p4, p4_phase , layout=(1, 2), size=(1500, 600))
savefig(final_plot, plotsdir("var35_1.png"))
println("Графики сохранены в папку plots")
