using MarketRisk

μ = 0.0
Σ = 0.3 ^ 2

ν = 4.13

h = 10 / 250
α = 0.01

N = Normal()
T = TDist(ν)

normal_etl = ExpectedTailLoss(μ, Σ, N)
t_etl = ExpectedTailLoss(μ, Σ, T)

compute(normal_etl, h, α)
compute(t_etl, h, α)
