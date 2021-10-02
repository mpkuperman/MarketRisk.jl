using MarketRisk

μ = 0.0
Σ = 0.3

h = 10 / 250
α = 0.01

N = Normal()

normal_etl = ExpectedTailLoss(μ, Σ, h, α, N)

compute(normal_etl)