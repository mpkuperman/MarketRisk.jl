using MarketRisk
using Distributions

μ = 0.1
Σ = 0.2
ν = 4.13
N = Normal()
T = TDist(ν)

normal_var = ValueAtRisk(μ, Σ, N)
student_var = ValueAtRisk(μ, Σ, T) 

compute(normal_var, 10, 0.1)
compute(student_var, 10, 0.1)
