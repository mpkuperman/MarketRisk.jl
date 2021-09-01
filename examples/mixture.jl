using Roots
using Distributions
using ForwardDiff

# def _mixture_normal_var(self, h, alpha):
#     args = (h, alpha, self.mixture_w, self.pi_mu, self.pi_sigma, self._dist_function)

#     def opt_func(x, t, a, w, m, s, d):
#         return sum(w[i] * d[i].cdf(x, t * m[i], np.sqrt(t) * s[i]) for i in range(len(w))) - a

#     return - newton(opt_func, x0=0.0, args=args)

ω = [0.3622, 1 - 0.3622]
μ = [- 0.0358, 0.0928]
Σ = [0.2635, 0.0548]

m = h -> MixtureModel(Normal, [(h * μ[i], sqrt(h) * Σ[i]) for i in 1:2], ω)

x0 = 0.0
h = 10 / 250

D(f) = x -> ForwardDiff.derivative(f, float(x))

opt(x, h, α) = cdf(m(h), x) - α
VaR = Float64[]
αs = [0.001, 0.01, 0.05, 0.1]
for α in αs
    push!(VaR, find_zero((x -> opt(x, h, α), D(x -> opt(x, h, α))), x0, Roots.Newton()))
end
VaR