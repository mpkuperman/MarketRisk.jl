using MarketRisk

μ = 0.0462
Σ = sqrt(0.1757 ^ 2)

h = 1 / 250
αs = [0.1, 0.01, 0.001]

ν = 4.14

N = Normal()
T = TDist(ν)

normal_var = ValueAtRisk(μ, Σ, h, αs, N)
student_var = ValueAtRisk(μ, Σ, h, αs, T)

compute(normal_var)
compute(student_var)


