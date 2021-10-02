using MarketRisk

ω = [0.5, 0.5]
μ = [0., 0.]
Σ = [0.018, 0.072]

α = 0.01
h = 10 / 250

m = MixtureModel(Normal, [(h * μ[i], sqrt(h) * sqrt(Σ[i])) for i in 1:2], ω)

mixture_etl = ExpectedTailLoss(μ, Σ, h, α, m)
compute(mixture_etl)

