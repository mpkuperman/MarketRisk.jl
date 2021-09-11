using MarketRisk
using Distributions

w = [0.75, 0.25]
μ = [0.0, -0.1]
Σ = [0.2, 0.4]

h = 1 / 250
αs = [0.001, 0.01, 0.05, 0.1]
νs = [10, 5]

mt = MixtureModel(NoncentralT[NoncentralT(νs[i], h * μ[i]) for i in 1:2], w)
mixture_var = ValueAtRisk(μ, Σ, h, αs[1], mt)

compute(mixture_var)

