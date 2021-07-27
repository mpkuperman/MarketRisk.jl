using MarketRisk
using GalacticOptim
using Distributions

h = 10
α = 0.1
w = [0.5, 0.5]
μ = [0.2, 0.2]
σ = [0.2, 0.2]

N = MixtureModel(Normal, [(μ[i], σ[i]) for i in 1:length(μ)], w)


p = (h, α, w, μ, σ, N)

function f(x, p)
    @unpack h, α, w, μ, σ, N = p

    cdf(N, x)

    sum(w[i] * cdf(d[i], x, t * m[i], np.sqrt(t) * s[i]) for i in 1:len(w)) - a
end

- newton(opt_func, x0=0.0, args=args)

OptimizationProblem(f, )