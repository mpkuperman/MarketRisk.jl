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

function compute(var::ParametricValueAtRisk{V, M, D}, h, alpha) where {V, M, D<:Normal}
    @unpack μ, Σ, dist = var 

    sqrt(h) * quantile(dist, 1 - alpha) * Σ - h * μ
end

function compute(var::ParametricValueAtRisk{V, M, D}, h, alpha) where {V, M, D<:TDist}
    @unpack μ, Σ, dist = var 
    @unpack ν = dist

    sqrt((ν - 2) / ν) * sqrt(h) * quantile(dist, 1 - alpha) * Σ - h * μ
end


# function compute(var::ParametricValueAtRisk{V, M, D}, h, alpha) where {V, M, D<:MixtureModel}
#     @unpack μ, Σ, dist = var 

#     args = (h, alpha, dist)

#     function opt_func(x, a)
#         return cdf(dist, x) - a
#     end
       
#     return - find_zero(opt_func, 0.0, Roots.Newton(), p=args)
# end

# function compute(h, alpha, nu)
#     args = (h, alpha, self.mixture_w, self.pi_mu, self.pi_sigma, self._dist_function, nu)

#     function opt_func(x, t, a, w, m, s, d, df)
#         return sum(w[i] * d[i].cdf(x, df[i], t * m[i], np.sqrt(t) * s[i]) for i in range(len(w))) - a
#     end

#     return - newton(opt_func, x0=0.0, args=args)
# end
