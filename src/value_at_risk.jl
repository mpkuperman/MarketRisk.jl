struct ParametricValueAtRisk
    μ
    Σ
    dist
end


function ValueAtRisk(μ, Σ, dist)
    return ParametricValueAtRisk
end

function ValueAtRisk(portfolio, dist)
    return ParametricValueAtRisk
end

function compute(var::ParametricValueAtRisk{M, S, D}, h, alpha) where {M, D, D<:NormalDistribution}
    @unpack μ, Σ, dist = var 

    sqrt(h) * ppf(dist, 1 - alpha) * Σ - h * μ
end

function compute(var::ParametricValueAtRisk{M, S, D}, h, alpha, nu) where {M, D, D<:TStudentDistribution}
    @unpack μ, Σ, dist = var 

    sqrt((nu - 2) / nu) * sqrt(h) * ppf(dist, 1 - alpha, nu) * Σ - h * μ
end

function compute(var, h, alpha)
    args = (h, alpha, self.mixture_w, self.pi_mu, self.pi_sigma, self._dist_function)

    def opt_func(x, t, a, w, m, s, d):
        return sum(w[i] * d[i].cdf(x, t * m[i], np.sqrt(t) * s[i]) for i in range(len(w))) - a

    return - newton(opt_func, x0=0.0, args=args)
end

function compute(self, h, alpha, nu)
    args = (h, alpha, self.mixture_w, self.pi_mu, self.pi_sigma, self._dist_function, nu)

    def opt_func(x, t, a, w, m, s, d, df):
        return sum(w[i] * d[i].cdf(x, df[i], t * m[i], np.sqrt(t) * s[i]) for i in range(len(w))) - a

    return - newton(opt_func, x0=0.0, args=args)
end
