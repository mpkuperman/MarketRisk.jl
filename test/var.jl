using MarketRisk
using Test

# Test normal VaR
w_n = [1.8, 2.2, 3.6, 5.2, 2.0, 7.0]
μ_n = zeros(6)
Σ_n = [[0.04, 0.033, 0.0375, 0.0405, 0.006, 0.004] [0.033, 0.0484, 0.04125, 0.04455, 0.0066, 0.0044] [0.0375, 0.04125, 0.0625, 0.050625, 0.0075, 0.005] [0.0405, 0.04455, 0.050625, 0.0729, 0.0081, 0.0054] [0.006, 0.0066, 0.0075, 0.0081, 0.0225, 0.0075] [0.004, 0.0044, 0.005, 0.0054, 0.0075, 0.01]]

h_n = 10 / 250
α_n = 0.01

p_n = Portfolio(w_n, μ_n, Σ_n)

m_n = mean(p_n)
s_n = sqrt(variance(p_n))
N_n = Normal()

var_n = ValueAtRisk(m_n, s_n, h_n, α_n, N_n)

@test compute(var_n) ≈ 1.4908892538487946

# Test t-Student VaR
μ_t = 0.0
Σ_t = 0.3

h_t = 10 / 250
α_t = 0.01

ν_t = 5
T_t = TDist(ν_t)

var_t = ValueAtRisk(μ_t, Σ_t, h_t, α_t, T_t)

@test compute(var_t) ≈ 0.15638781416305675 


# Test mixture normal VaR
ω_nm = [0.75, 0.25]
μ_nm = [0.0, -0.1]
Σ_nm = [0.2, 0.4]
α_nm = 0.001
h_nm = 10 / 250

m_nm = MixtureModel(Normal, [(h_nm * μ_nm[i], sqrt(h_nm) * Σ_nm[i]) for i in 1:2], ω_nm)

var_nm = ValueAtRisk(μ_nm, Σ_nm, h_nm, α_nm, m_nm)

@test compute(var_nm) ≈ 0.21616624418759633

