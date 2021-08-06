using MarketRisk
using Distributions
using ForwardDiff

μ = 0.1
Σ = 0.2
ν = 4.13
N = Normal()
T = TDist(ν)
M = MixtureModel(Normal, [(-2.0, 1.2), (0.0, 1.0), (3.0, 2.5)], [0.2, 0.5, 0.3])


normal_var = ValueAtRisk(μ, Σ, N)
student_var = ValueAtRisk(μ, Σ, T) 
mixture_var = ValueAtRisk(μ, Σ, M) 

compute(normal_var, 10, 0.1)
compute(student_var, 10, 0.1)
compute(mixture_var, 10, 0.1)
