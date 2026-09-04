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
tau1 = 18        # длительность производственного цикла фирмы 1 
p1 = 7.7         # себестоимость продукта у фирмы 1
tau2 = 13       # длительность производственного цикла фирмы 2 
p2 = 8.3         # себестоимость продукта у фирмы 2 
N = 30          # число потребителей 
q = 1         # максимальная потребность одного человека

# Начальные значения оборотных средств 
M0_1 = 5.4
M0_2 = 4.1
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
    du[1] = M1 - (b/c1)*M1*M2 - (a1/c1)*M1^2
    du[2] = (c2/c1)*M2 - (b/c1 + 0.00053)*M1*M2 - (a2/c1)*M2^2
end

# ## Решение
prob1 = ODEProblem(case1!, u0, tspan)
sol1 = solve(prob1, Tsit5(), saveat=0.05)

prob2 = ODEProblem(case2!, u0, tspan)
sol2 = solve(prob2, Tsit5(), saveat=0.05)

# ## Визуализация
p3 = plot(sol1.t, sol1[1,:], label="Фирма 1", lw=2, color=:blue)
plot!(p3, sol1.t, sol1[2,:], label="Фирма 2", lw=2, color=:green)
title!(p3, "Случай 1: Рыночная конкуренция")
xlabel!(p3, "Безразмерное время")
ylabel!(p3, "Оборотные средства M (млн. ед.)")

p4 = plot(sol2.t, sol2[1,:], label="Фирма 1", lw=2, color=:blue)
plot!(p4, sol2.t, sol2[2,:], label="Фирма 2", lw=2, color=:green)
title!(p4, "Случай 2: С соц.-псих. факторами")
xlabel!(p4, "Безразмерное время")
ylabel!(p4, "Оборотные средства M")

final_plot_2 = plot(p3, p4, layout=(1,2), size=(1000, 450))

savefig(final_plot_2, plotsdir("competition_model_var35.png"))
