using MarketRisk

ω = [0.75, 0.25]
μ = [0.0, -0.1]
Σ = [0.2, 0.4]
α = 0.001
αs = [0.001, 0.01, 0.1]
h = 10 / 250

m = MixtureModel(Normal, [(h * μ[i], sqrt(h) * Σ[i]) for i in 1:2], ω)

mixture_var = ValueAtRisk(μ, Σ, h, α, m)
mixture_var1 = ValueAtRisk(μ, Σ, h, αs, m)

compute(mixture_var)
compute(mixture_var1)
