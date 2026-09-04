using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab06/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

N = 12300 # общая численность популяции

I0_a = 140 # число заболевших в начальный момент
R0_a = 54 # здоровые с иммунитетом в начальный момент
S0_a = N -I0_a - R0_a
u0_a = [S0_a, I0_a, R0_a]
I_star_a = 200

I0_b = 140
R0_b = 54
S0_b = N -I0_b - R0_b
u0_b = [S0_b, I0_b, R0_b]
I_star_b = 120

alpha = 0.01 # коэффициент заболеваемости
beta =0.02 # коэффициент выздоровления
tspan = (0.0, 200.0)

function SIR_case1!(du, u, p, t)
	S, I, R = u
	du[1] = 0
	du[2] = -beta*I
	du[3] = beta*I
end

function SIR_case2!(du, u, p, t)
	S, I, R = u
	du[1] = -alpha*S
	du[2] = alpha*S - beta*I
	du[3] = beta*I
end

prob_a = ODEProblem(SIR_case1!, u0_a, tspan)
sol_a = solve(prob_a, Tsit5(), saveat=0.05)
prob_b = ODEProblem(SIR_case2!, u0_b, tspan)
sol_b = solve(prob_b, Tsit5(), saveat=0.05)

p1 = plot(sol_a,
	title = "Случай 1: I0<=I*",
	xlabel = "Время t",
	ylabel = "Численность",
	label = ["S(t)" "I(t)" "R(t)"],
	lw =2,
	legend=:right)
p2 = plot(sol_b,
	title = "Случай 2: I0>I*",
	xlabel = "Время t",
	ylabel = "Численность",
	label = ["S(t)" "I(t)" "R(t)"],
	lw =2,
	legend=:right)
final_plot = plot(p1, p2 , layout=(1, 2), size=(1600, 800))
display(final_plot)

savefig(final_plot, plotsdir("SIR_var35.png"))
println("График сохранен в папку plots")
