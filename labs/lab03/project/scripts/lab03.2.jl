# ## Модель боевых действий
# Вариант 35

# Рассмотрим 2 случая ведения боевых действий:
# 1. Боевые действия между регулярными войсками
# 2. Боевые действия с участием регулярных войск и партизанских отрядов
 
using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab03/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# ## Начальные условия
x0, y0 = 31050, 20002
v0 = [x0, y0]
tspan = (0.0, 1.0)

# Модель 1: регулярные vs регулярные
a1, b1, c1, h1 = 0.25, 0.74, 0.64, 0.55
P(t) = sin(t+5)
Q(t) = cos(t+6)

function model1!( du, u, p, t)
	x, y = u
	du[1] = -a1*x - b1*y + P(t) # изменение численности первой армии
	du[2] = -c1*x - h1*y + Q(t) # изменение численности второй армии 
end

# Модель 2: регулярные vs партизаны
a2, b2, c2, h2 = 0.32, 0.89, 0.51, 0.62
P2(t) = 2*sin(10t)
Q2(t) = 2*cos(10t)

function model2!(du, u, p, t)
    x, y = u
    du[1] = -a2*x - b2*y + P2(t)
    du[2] = -c2*x*y - h2*y + Q2(t)
end

# ## Решение
prob1 = ODEProblem(model1!, v0, tspan)
prob2 = ODEProblem(model2!, v0, tspan)

sol1 = solve(prob1, Tsit5(), saveat=0.01)
sol2 = solve(prob2, Tsit5(), saveat=0.01)

# ## Визуализация
# Модель 1
p1 = plot(sol1, label=["Армия X" "Армия Y"],
	title = "Модель 1: регулярные vs регулярные",
	xlabel="Время", ylabel="Численность армии", lw=2)
# Модель 2
p2 = plot(sol2, label=["Армия X" "Армия Y"],
	title = "Модель 2: регулярные + партизаны",
	xlabel="Время", ylabel="Численность армии", lw=2)

# Общий график
final_plot = plot(p1, p2, layout=(1, 2), size=(1500, 600))

# Сохранение
savefig(final_plot, plotsdir("variant_35.png"))



