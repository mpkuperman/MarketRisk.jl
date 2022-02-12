using MarketRisk

μ = 0.0
Σ = 0.3

h = 10 / 250
α = 0.01
αs = [0.01, 0.05, 0.1]

ν = 5
T = TDist(ν)

t_etl = ValueAtRisk(μ, Σ, h, α, T)
t_etl1 = ValueAtRisk(μ, Σ, h, αs, T)

compute(t_etl)
compute(t_etl1)
