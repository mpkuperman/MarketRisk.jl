using MarketRisk

ω = [0.75, 0.25]
μ = [0.0, -0.1]
Σ = [0.2, 0.4]
αs = 0.001
h = 10 / 250
nus = [10., 5.]

m = MixtureModel(Normal, [(h * μ[i], sqrt(h) * Σ[i]) for i in 1:2], ω)

mixture_var = ValueAtRisk(μ, Σ, h, αs, m)
compute(mixture_var)

