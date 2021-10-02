using MarketRisk

μ = 0.0
Σ = 0.3

h = 10 / 250
α = 0.01

ν = 5
T = TDist(ν)

t_etl = ValueAtRisk(μ, Σ, h, α, T)

compute(t_etl)
