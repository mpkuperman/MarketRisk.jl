using MarketRisk 
using Test

# Test normal ETL
μ_en = 0.0
Σ_en = 0.3

h_en = 10 / 250
α_en = 0.01

N_en = Normal()

etl_en = ExpectedTailLoss(μ_en, Σ_en, h_en, α_en, N_en)

@test compute(etl_en) ≈ 0.15991285322074647

# Test t-Student ETL
μ_et = 0.0
Σ_et = 0.3

ν_et = 5

h_et = 10 / 250
α_et = 0.01

T_et = TDist(ν_et)

etl_et = ExpectedTailLoss(μ_et, Σ_et, h_et, α_et, T_et)

@test compute(etl_et) ≈ 0.23441282083322523
