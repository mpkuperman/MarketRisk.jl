using MarketRisk

μ = 0.0
Σ = 0.3

h = 10 / 250
α = 0.01
αs = [0.01, 0.05, 0.1]

N = Normal()

normal_etl = ExpectedTailLoss(μ, Σ, h, α, N)
normal_etl1 = ExpectedTailLoss(μ, Σ, h, αs, N)

compute(normal_etl)
compute(normal_etl1)
