struct ParametricValueAtRisk{V, M, D}
    μ::V
    Σ::M
    dist::D
end
    

function ValueAtRisk(μ, Σ, dist)
    return ParametricValueAtRisk(μ, Σ, dist)
end


function ValueAtRisk(portfolio, dist)
    return ParametricValueAtRisk
end

function compute(var::MarketRisk.ParametricValueAtRisk{V, M, Normal}, h, alpha) where {V, M}
    @unpack μ, Σ, dist = var 

    sqrt(h) * quantile(dist, 1 - alpha) * Σ - h * μ
end

function compute(var::ParametricValueAtRisk{V, M, TDist}, h, alpha) where {V, M}
    @unpack μ, Σ, dist = var 

    sqrt((nu - 2) / nu) * sqrt(h) * quantile(dist, 1 - alpha) * Σ - h * μ
end

# function compute(var, h, alpha)
#     args = (h, alpha, self.mixture_w, self.pi_mu, self.pi_sigma, self._dist_function)

#     function opt_func(x, t, a, w, m, s, d)
#         return sum(w[i] * d[i].cdf(x, t * m[i], np.sqrt(t) * s[i]) for i in range(len(w))) - a
#     end

#     return - newton(opt_func, x0=0.0, args=args)
# end

# function compute(h, alpha, nu)
#     args = (h, alpha, self.mixture_w, self.pi_mu, self.pi_sigma, self._dist_function, nu)

#     function opt_func(x, t, a, w, m, s, d, df)
#         return sum(w[i] * d[i].cdf(x, df[i], t * m[i], np.sqrt(t) * s[i]) for i in range(len(w))) - a
#     end

#     return - newton(opt_func, x0=0.0, args=args)
# end
