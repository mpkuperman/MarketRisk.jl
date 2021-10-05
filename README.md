**MarketRisk.jl** is a Julia library wich provides high-performance market risk measures for your portfolio. It currently supports:

-  [Value at Risk (VaR)](https://en.wikipedia.org/wiki/Value_at_risk): Most popular market risk measure which gives maximum possible loss given a confidence level and a time horizon.

- [Expected Tail Loss (ETL or CVaR)](https://en.wikipedia.org/wiki/Expected_shortfall): A more complete risk measure than VaR.


# Examples

```Julia 
using MarketRisk

w = [1.8, 2.2, 3.6, 5.2, 2.0, 7.0]
μ = zeros(6)
Σ = [[0.04, 0.033, 0.0375, 0.0405, 0.006, 0.004] [0.033, 0.0484, 0.04125, 0.04455, 0.0066, 0.0044] [0.0375, 0.04125, 0.0625, 0.050625, 0.0075, 0.005] [0.0405, 0.04455, 0.050625, 0.0729, 0.0081, 0.0054] [0.006, 0.0066, 0.0075, 0.0081, 0.0225, 0.0075] [0.004, 0.0044, 0.005, 0.0054, 0.0075, 0.01]]

h = 10 / 250
α = 0.01

p = Portfolio(w, μ, Σ)

m = mean(p)
s = sqrt(variance(p))
N = Normal()

normal_var = ValueAtRisk(m, s, h, α, N)

compute(normal_var)
```

# Installation

**MarketRisk.jl** can be installed via ```] add MarketRisk```

# Authors

**MarketRisk.jl** is authored by [mpkuperman](https://github.com/mpkuperman)

# License

**MarketRisk.jl** is licensed by GNU General Public License v3.0. For more details please see the [LICENSE](https://github.com/mpkuperman/MarketRisk.jl/blob/main/LICENSE) file.
