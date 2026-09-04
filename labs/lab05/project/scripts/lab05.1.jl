# ## Модель хищник-жертва
#
# Инициализация проекта

using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab05/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# ## Параметры модели

a= 0.2 # коэффициент естественной смертности хищников
b= 0.5 # коэффициент естественного прироста жертв
c= 0.05 # коэффициент увеличения числа хищников
d= 0.02 # коэффициент смертности жертв 

# ## Начальные условия

x0 =5 # полпуляция хищников
y0 = 10 # полпуляция жертв
u0 = [x0, y0] # вектор начальных условий
tspan = (0.0, 400.0) # временной интервал

# ## Функция
#
#a, d - коэффициенты смертности
#
# b, c - коэффициенты прироста популяции

function lv!(du, u, p, t)
	x, y = u
	du[1] = -a*x + b*x*y  # хищники
	du[2] = c*y - d*x*y   # жертвы
end

# ## Решение
prob = ODEProblem(lv!, u0, tspan)
sol = solve(prob, Tsit5(), saveat=0.05)

# ##Стационарное состояние
#
# dx/dt = 0 => -a*x + b*x*y = 0 => x*(-a + b*y) = 0
#
# dy/dt = 0 => c*y - d*x*y = 0 => y*(c - d*x) = 0
#
# Нетривиальное решение: x* = c/d, y* = a/b
x_st = c / d
y_st = a / b

println("Стационарное состояние системы:")
println("x* (хищники) = $x_st")
println("y* (жертвы)  = $y_st")

# ## Визуализация
p1 = plot(sol,
	title = " Динамика популяции",
	xlabel = "Время t",
	ylabel = "Численность",
	label = ["Хищники (x)" "Жертвы (y)"],
	lw =1.5)
p2 = plot(sol, idxs=(2, 1),
	title = " Фазовый портет",
	xlabel = "Численность жертв",
	ylabel = "Численность хищников",
	lw =1.5)
scatter!([y_st], [x_st], color=:red, label="Стац. состояние A($(round(y_st, digits=2)), $(round(x_st, digits=2)))")
final_plot = plot(p1, p2 , layout=(1, 2), size=(1500, 700))
display(final_plot)

#Сохранение
savefig(final_plot, plotsdir("lv_1.png"))
println("График сохранен в папку plots")
