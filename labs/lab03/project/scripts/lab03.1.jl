# ## Модель боевых действий
# Рассмотри три случая ведения боевых действий:
# 1. Боевые действия между регулярными войсками
# 2. Боевые действия с участием регулярных войск и партизанских отрядов
# 3. Боевые действия между партизанскими отрядами 
using Pkg
Pkg.activate("C:/Users/Александра/work/study/2026-1/2026-1==study--mathmod/2026-1--study--mathmod/labs/lab03/project")
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
default(fmt =:png)

# ## Начальные условия
# Произвольно выбранные коэффициенты
a, b, c, h = 0.4, 0.7, 0.8, 0.5
# Численность армий 
x0, y0 = 2000, 6000
# Вектор начальных условий
v0 = [x0, y0]
# Временной отрезок
tspan = (0.0, 1.0)

# Функции подкрепления
P(t) = cos(t) + 1
Q(t) = sin(t) + 1

# ## Модели
# Модель 1: регулярные vs регулярные
function model1!( du, u, p, t)
	x, y = u
	du[1] = -a*x - b*y + P(t) # изменение численности первой армии
	du[2] = -c*x - h*y + Q(t) # изменение численности второй армии
end
# Модель 2: регулярные + партизаны
function model2!( du, u, p, t)
	x, y = u
	du[1] = -a*x - b*y + P(t) # изменение численности первой армии
	du[2] = -c*x*y - h*y + Q(t) # изменение численности второй армии
end
# Модель 3: партизаны vs партизаны
function model3!( du, u, p, t)
	x, y = u
	du[1] = -a*x - b*x*y + P(t) # изменение численности первой армии
	du[2] = -c*x*y - h*y + Q(t) # изменение численности второй армии
end

# ## Решение
prob1 = ODEProblem(model1!, v0, tspan)
prob2 = ODEProblem(model2!, v0, tspan)
prob3 = ODEProblem(model3!, v0, tspan)

sol1 = solve(prob1, Tsit5(), saveat=0.01)
sol2 = solve(prob2, Tsit5(), saveat=0.01)
sol3 = solve(prob3, Tsit5(), saveat=0.01)

# ## Определение победителя
winner(sol) = sol[1,end] <= 0 && sol[2,end] > 0 ? "Y" :
	sol[2,end] <= 0 && sol[1,end] > 0 ? "X" : "не определен победитель"

w1 = winner(sol1)
w2 = winner(sol2)
w3 = winner(sol3)

println("Определение победителя")
println("\nМодель 1(регулярные vs регулярные): $w1")
println("Модель 2(регулярные + партизаны): $w2")
println("Модель 3(партизаны vs партизаны): $w3")

# ## Условия победы
println("\nОпределение условий, при котором та или другая сторона выигрывают бой (для каждого случая)")
# Модель 1
cond1_X = c*x0^2
cond1_Y = b*y0^2

println("\nМодель 1: регулярные vs регулярные")
println("Условия победы X: c*x0^2 > b*y0^2")
if cond1_X > cond1_Y
	println("Итог: при прочих равных, армия X имеет преимущество")
elseif cond1_Y > cond1_X
	println("Итог: при прочих равных, армия Y имеет преимущество")
else
	println("Итог: ничья")
end

# Модель 2
cond2_X = b/2*x0^2
cond2_Y = c*y0

println("\nМодель 2: регулярные + партизаны")
println("Условия победы X: b/2*x0^2 > c*y0")
if cond2_X > cond2_Y
	println("Итог: регулярная армия X имеет преимущество")
elseif cond2_Y > cond2_X
	println("Итог: партизаны армии Y имеют преимущество")
else
	println("Итог: ничья")
end

# Модель 3
cond3_X = (b/2)*x0^2
cond3_Y = (c/2)*y0^2

println("\nМодель 3: партизаны vs партизаны")
println("Условие победы X: (b/2)*X0^2 > (c/2)*Y0^2")
if cond3_X > cond3_Y
    println("Итог: партизаны X имеют преимущество")
elseif cond3_X < cond3_Y
    println("Итог: партизаны Y имеют преимущество")
else
    println("Итог: ничья")
end

# ## Визуализация 
# Модель 1
p1 = plot(sol1, label=["X(t)" "Y(t)"],
	title = "Модель 1: регулярные vs регулярные\nПобедитель: $w1",
	xlabel="Время", ylabel="Численность армии", lw=2)
# Модель 2
p2 = plot(sol2, label=["X(t)" "Y(t)"],
	title = "Модель 2: регулярные + партизаны\nПобедитель: $w2",
	xlabel="Время", ylabel="Численность армии", lw=2)
#Модель 3
p3 = plot(sol3, label=["X(t)" "Y(t)"],
	title = "Модель 3: партизаны vs партизаны\nПобедитель: $w3",
	xlabel="Время", ylabel="Численность армии", lw=2)
# Общий график
final_plot = plot(p1, p2, p3, layout=(1, 3), size=(1500, 600))

# Сохранение
savefig(final_plot, plotsdir("common_models.png"))
