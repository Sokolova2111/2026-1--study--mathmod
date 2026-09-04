# ## Задача на эффективность рекламы
#
# Инициализация проекта
using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab07/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# ## Параметры модели
N = 800 # общее число потенциальных клиентов
N0 = 10 # число клиентов, знающих о салоне в момент открытия
u0 =[N0] # вектор начальных условий
tspan = (0.0, 30.0) # временной интервал

# ## Коэффициенты рекламной кампании
#
# alpha1 - интенсивность платной рекламы
#
# alpha2 - интенсивность "сарафанного радио"

# Случай 1: alpha1 > alpha2 (активная платная реклама, сарафанное радио слабое)
alpha1_high = 0.08
alpha2_low = 0.001
# Случай 2: alpha1 < alpha2 (платная реклама слабая, но клиенты активно делятся)
alpha1_low = 0.002
alpha2_high = 0.06

# ## Функции для различных сценариев
#
# Уравнение модели: dn/dt = (α1(t) + α2(t)*n) * (N - n)
#
# Случай 1: alpha1>alpha2 (постоянные коэффициенты)
function reklama_case1!(du, u, p, t)
	n = u[1]
	du[1] = (alpha1_high + alpha2_low*n)*(N - n)
end
# Случай 2: alpha1<alpha2 (постоянные коэффициенты)
function reklama_case2!(du, u, p, t)
	n = u[1]
	du[1] = (alpha1_low + alpha2_high*n)*(N - n)
end
# Сценарий 3: только платная реклама (alpha2=0) - модель Мальтуса
function reklama_only_paid!(du, u, p, t)
	n = u[1]
	du[1] = alpha1_high*(N - n)
end
# Сценарий 4: только сарафанное радио (alpha1=0) - логистическая кривая
function reklama_only_word!(du, u, p, t)
	n = u[1]
	du[1] = alpha2_high*n*(N - n)
end

# ## Решение 
prob1 = ODEProblem(reklama_case1!, u0, tspan)
sol1 = solve(prob1, Tsit5(), saveat=0.05)
prob2 = ODEProblem(reklama_case2!, u0, tspan)
sol2 = solve(prob2, Tsit5(), saveat=0.05)
prob3 = ODEProblem(reklama_only_paid!, u0, tspan)
sol3 = solve(prob3, Tsit5(), saveat=0.05)
prob4 = ODEProblem(reklama_only_word!, u0, tspan)
sol4 = solve(prob4, Tsit5(), saveat=0.05)

# ## Визуализация
# График распространение рекламы
p1 = plot(
	sol1.t, sol1[1,:],
	title = "Распространение рекламы о салоне красоты",
	xlabel = "Время t",
	ylabel = "Число клиентов, знающих о салоне n(t)",
	label = "Распространение рекламы",
	lw =2,
	color=:blue)
hline!([N], label="N = $N (потенциальные клиенты)", color=:green, linestyle=:dot, lw=1.5)
# График сравнения
p2 = plot(
	sol1.t, sol1[1,:],
	title = "Сравнение эффективности рекламной кампании",
	xlabel = "Время t",
	ylabel = "Число клиентов n(t)",
	label = "alpha1>alpha2",
	lw = 2,
	color=:blue)
plot!(p2,
	sol2.t, sol2[1,:],
	label = "alpha1<alpha2",
	lw = 2,
	color=:red,
	linestyle=:dash)
hline!([N], label="N = $N (потенциальные клиенты)", color=:green, linestyle=:dot, lw=1.5)

# Точка максимального роста

derivative = (alpha1_high .+ alpha2_low .* sol1[1,:]) .* (N .- sol1[1,:])
max_idx = argmax(derivative)
max_time = sol1.t[max_idx]
max_value = sol1[1,max_idx]
p3 = plot(
	sol1.t, derivative,
	title = "Максимальный рост рекламной кампании",
	xlabel = "Время t",
	ylabel = "dn/dt",
	label = "Скорость изменения dn/dt",
	lw = 2,
	color=:purple)
scatter!(
    p3,
    [max_time], [derivative[max_idx]],
    label="Макс. рост: t = $(round(max_time, digits=2)) дн., n = $(round(max_value, digits=0))",
    color=:red,
    markersize=8
)

# График только платной рекламы + только сарафанное радио

p4 = plot(
	sol3.t, sol3[1,:],
	title = "Платная реклама vs сарафанное радио",
	xlabel = "Время t",
	ylabel = "Число клиентов n(t)",
	label = "Только платная реклама",
	lw = 2,
	color=:orange)
plot!(p4,
	sol4.t, sol4[1,:],
	label = "Только сарафанное радио",
	lw = 2,
	color=:magenta,
	linestyle=:dash)
hline!([N], label="N = $N (потенциальные клиенты)", color=:green, linestyle=:dot, lw=1.5)
 
# Финальный график
final_plot = plot(
	p1, p2, p3, p4,
	layout=(2, 2), 
	size=(1200, 900))
display(final_plot)

# Сохранение
savefig(final_plot, plotsdir("reklama_model.png"))

println("График сохранен в папку plots")
println("\n=== Результаты ===")
println("Время максимального роста: t = $(round(max_time, digits=2)) дней")
println("Число клиентов в момент макс. роста: n = $(round(max_value, digits=0))")