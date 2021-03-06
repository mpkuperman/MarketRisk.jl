using MarketRisk

μ = 0.0
Σ = 0.3

ν = 4.13

h = 10 / 250
α = 0.01
αs = [0.01, 0.05, 0.1]

T = TDist(ν)

t_etl = ExpectedTailLoss(μ, Σ, h, α, T)
t_etl1 = ExpectedTailLoss(μ, Σ, h, αs, T)

compute(t_etl)
compute(t_etl1)

νs = [5, 10, 15, 20, 25, 10000]
etls = Float64[]

for ν in νs
    td = TDist(ν)
    te = ExpectedTailLoss(μ, Σ, h, α, td)
    push!(etls, compute(te))
end

etls