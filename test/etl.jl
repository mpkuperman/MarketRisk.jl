using MarketRisk 
using Test

# Test normal ETL
μ_n = 0.0
Σ_n = 0.3

h_n = 10 / 250
α_n = 0.01

etl_n = normal_etl(μ_n, Σ_n, h_n, α_n)

@test etl_n ≈ 0.1599129

# Test t-Student ETL
μ_t = 0.0
Σ_t = 0.3

h_t = 10 / 250
α_t = 0.01

etl_t = normal_etl(μ_t, Σ_t, h_t, α_t)

@test etl_t ≈ 0.1599129

