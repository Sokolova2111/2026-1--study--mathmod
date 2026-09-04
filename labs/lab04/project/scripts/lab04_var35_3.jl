# ## Модель гармонических колебаний
#
# Вариант 35
#
# Задание 3:
# Построить фазовый портрет гармонического осциллятора с затуханием и под действием внешней силы 
# и решение уравнения гармонического осциллятора
#
# Уравнение:
#
# x'' + 3*x'+ 3.3*x = 0.2*sin(3.5*t)

using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab04/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# Параметры 
w2 = 3.3
g = 3
F0 = 0.2 # амплитуда внешней силы
W = 3.5 # частота внещней силы

# Начальные условия 
x0 = 0.0 # начальное смещение
v0 = 1.4 # начальная скорость
u0 = [x0, v0] # вектор начальных условий
tspan = (0.0, 33.0) # временной интервал

println("\nУравнение вынужденных колебаний:")
println("\nx'' + 3*x'+ 3.3*x = 0.2*sin(3.5*t)")

# Функция для решения ОДУ
function var35_3!(du, u, p, t)
	w, g, F0, W = p
	x, v = u
	force = F0*sin(W*t)
	du[1] = v
	du[2] = -w2*x -g*v + force
end

prob6 = ODEProblem(var35_3!, u0, tspan, [w2, g, F0, W])
sol6 = solve(prob6, Tsit5(), saveat=0.05)

# Извлекаем решение
t6 = sol6.t
x6 = [u[1] for u in sol6.u]
v6 = [u[2] for u in sol6.u]

# График x(t)
p6 =plot(t6, x6, title = "Гармонический осциллятор с затуханием и\nпод действием внешней силы", xlabel = "Время t", ylabel = "Смещение x", legend=false)

# Фазовый портрет
p6_phase =plot(x6, v6, title = "Фазовый портрет", xlabel = "x", ylabel = "v (скорость)", legend=false)

# Общий график
final_plot = plot(p6, p6_phase , layout=(1, 2), size=(1500, 700))
# Сохранение
savefig(final_plot, plotsdir("var35_3.png"))
println("Графики сохранены в папку plots")
