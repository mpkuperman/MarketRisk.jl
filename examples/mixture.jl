using Roots
using GalacticOptim, Optim
using Distributions


def _mixture_normal_var(self, h, alpha):
    args = (h, alpha, self.mixture_w, self.pi_mu, self.pi_sigma, self._dist_function)

    def opt_func(x, t, a, w, m, s, d):
        return sum(w[i] * d[i].cdf(x, t * m[i], np.sqrt(t) * s[i]) for i in range(len(w))) - a

    return - newton(opt_func, x0=0.0, args=args)

M = MixtureModel(Normal, [(0.0, 1.0), (0.0, 1.0), (0.0, 1.0)], [0.2, 0.5, 0.3])
using Parameters

using GalacticOptim, Optim

rosenbrock(x, p) =  (p[1] - x[1]) ^ 2

x0 = zeros(1)
p  = [1.0]

f = OptimizationFunction(rosenbrock, GalacticOptim.AutoForwardDiff())
prob = OptimizationProblem(f, x0, p)

sol = solve(prob, Newton())


