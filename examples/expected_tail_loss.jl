using MarketRisk

μ = 0.0
Σ = 0.3

ν = 4.13

h = 10 / 250
α = 0.01

N = Normal()
T = TDist(ν)

normal_etl = ExpectedTailLoss(μ, Σ, h, α, N)
t_etl = ExpectedTailLoss(μ, Σ, h, α, T)

compute(normal_etl)
compute(t_etl)

νs = [5, 10, 15, 20, 25, 10000]
etls = Float64[]

for ν in νs
    td = TDist(ν)
    te = ExpectedTailLoss(μ, Σ, h, α, td)
    push!(etls, compute(te))
end

etls