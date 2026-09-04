# ## Модель конкуренции двух фирм

# Инициализация проекта
using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab08/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# ## Параметры модели
p_cr = 35 # критическая стоимость продукта
tau1 = 8        # длительность производственного цикла фирмы 1 
p1 = 12         # себестоимость продукта у фирмы 1
tau2 = 14       # длительность производственного цикла фирмы 2 
p2 = 10         # себестоимость продукта у фирмы 2 
N = 15          # число потребителей 
q = 1.2         # максимальная потребность одного человека

# Начальные значения оборотных средств 
M0_1 = 3.0
M0_2 = 1.5
u0 = [M0_1, M0_2]

# Временной интервал
tspan = (0.0, 30.0)

# ## Расчёт коэффициентов
a1 = p_cr / (tau1^2 * p1^2 * N * q)
a2 = p_cr / (tau2^2 * p2^2 * N * q)
b = p_cr / (tau1^2 * tau2^2 * p1^2 * p2^2 * N * q)
c1 = (p_cr - p1) / (tau1 * p1)
c2 = (p_cr - p2) / (tau2 * p2)

# ## Случай 1: Только рыночная конкуренция
function case1!(du, u, p, t)
    M1, M2 = u
    du[1] = M1 - (a1/c1)*M1^2 - (b/c1)*M1*M2
    du[2] = (c2/c1)*M2 - (a2/c1)*M2^2 - (b/c1)*M1*M2
end

# ## Случай 2: С социально-психологическими факторами
function case2!(du, u, p, t)
    M1, M2 = u
    du[1] = M1 - (b/c1 + 0.0015)*M1*M2 - (a1/c1)*M1^2
    du[2] = (c2/c1)*M2 - (b/c1)*M1*M2 - (a2/c1)*M2^2
end

# ## Решение
prob1 = ODEProblem(case1!, u0, tspan)
sol1 = solve(prob1, Tsit5(), saveat=0.05)

prob2 = ODEProblem(case2!, u0, tspan)
sol2 = solve(prob2, Tsit5(), saveat=0.05)

# ## Визуализация
p1 = plot(sol1.t, sol1[1,:], label="Фирма 1", lw=2, color=:blue)
plot!(p1, sol1.t, sol1[2,:], label="Фирма 2", lw=2, color=:green)
title!(p1, "Случай 1: Рыночная конкуренция")
xlabel!(p1, "Безразмерное время")
ylabel!(p1, "Оборотные средства M (млн. ед.)")

p2 = plot(sol2.t, sol2[1,:], label="Фирма 1", lw=2, color=:blue)
plot!(p2, sol2.t, sol2[2,:], label="Фирма 2", lw=2, color=:green)
title!(p2, "Случай 2: С соц.-псих. факторами")
xlabel!(p2, "Безразмерное время")
ylabel!(p2, "Оборотные средства M")

final_plot = plot(p1, p2, layout=(1,2), size=(1000, 450))
display(final_plot)
savefig(final_plot, plotsdir("competition_model.png"))

# ## Стационарные состояния для случая 1
M1_star_1 = c1 / a1 # только фирма 1
M2_star_2 = c2 / a2 # только фирма 2

denom = a1*a2 - b^2
M1_star_3 = (c1*a2 - c2*b) / denom   # обе фирмы
M2_star_3 = (c2*a1 - c1*b) / denom

println("\nСтационарные состояния (случай 1):")
println("Только фирма 1: M1 = $(round(M1_star_1, digits=2)), M2 = 0")
println("Только фирма 2: M1 = 0, M2 = $(round(M2_star_2, digits=2))")
println("Обе фирмы: M1 = $(round(M1_star_3, digits=2)), M2 = $(round(M2_star_3, digits=2))")