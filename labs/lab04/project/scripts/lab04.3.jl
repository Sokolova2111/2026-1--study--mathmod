# ## Модель гармонических колебаний

# Задание 3:
# Записать уравнение колебаний гармонического осциллятора, если на систему
# действует внешняя сила, построить его решение. Построить фазовый портрет
# колебаний с действием внешней силы.
# Уравнение вынужденных колебаний:
#
# x'' + 2*g*x' + w^2*x = f(t), где w - частота, g - затухание
#
# Если f(t)=F0*sin(W*t), то
#
# Уравнение принимает следующий вид:
#
# x'' + 2*g*x' + w^2*x = F0*sin(W*t)
#
# Система уравнений первого порядка:
#
# x' = v
#
# v' = -w^2*x -2*g*v + F0*sin(W*t)

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
F0 = 1.0 # амплитуда внешней силы
W = 1.2 # частота внещней силы

# Начальные условия 
x0 = 1.0 # начальное смещение
v0 = 0.0 # начальная скорость
u0 = [x0, v0] # вектор начальных условий
tspan = (0.0, 40.0) # временной интервал

println("\nУравнение вынужденных колебаний:")
println("\nx'' + 2*g*x' + w^2* x = F0*sin(W*t)")
println("\nСистема уравнений первого порядка:")
println("\nx' = v")
println("\nv' = -w^2*x -2*g*v + F0*sin(W*t)")

# Функция для решения ОДУ
function osc_s_vneshnei_siloy!(du, u, p, t)
	w, g, F0, W = p
	x, v = u
	force = F0*sin(W*t)
	du[1] = v
	du[2] = -w^2*x -2*g*v + force
end

prob3 = ODEProblem(osc_s_vneshnei_siloy!, u0, tspan, [w, g, F0, W])
sol3 = solve(prob3, Tsit5(), saveat=0.05)

# Извлекаем решение
t3 = sol3.t
x3 = [u[1] for u in sol3.u]
v3 = [u[2] for u in sol3.u]

# График x(t)
p3 =plot(t3, x3, title = "Вынужденные колебания", xlabel = "Время t", ylabel = "Смещение x", legend=false)

# Фазовый портрет
p3_phase =plot(x3, v3, title = "Фазовый портрет (с внешней силой)", xlabel = "x", ylabel = "v (скорость)", legend=false)

# Общий график
final_plot = plot(p3, p3_phase , layout=(1, 2), size=(1500, 600))
savefig(final_plot, plotsdir("osc_s_vneshnei_siloy.png"))
println("Графики сохранены в папку plots")
