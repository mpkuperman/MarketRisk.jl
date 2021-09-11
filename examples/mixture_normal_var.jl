using MarketRisk

ω = [0.3622, 1 - 0.3622]
μ = [- 0.0358, 0.0928]
Σ = [0.2635, 0.0548]
h = 10 / 250
αs = [0.001, 0.01, 0.05, 0.1]

m = MixtureModel(Normal, [(h * μ[i], sqrt(h) * Σ[i]) for i in 1:2], ω)

mixture_var = ValueAtRisk(μ, Σ, h, αs[1], m)
compute(mixture_var)

