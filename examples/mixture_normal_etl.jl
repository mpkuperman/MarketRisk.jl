using MarketRisk

w = np.array([0.2, 0.8])
mean = np.array([0.0, 0.0])
sigma = np.array([0.6 ** 2, 0.15 ** 2])
p = Portfolio(w, mean, sigma)
etl = ExpectedTailLoss(p.mu, p.variance, "MixtureNormal", mixture_weights=np.array([0.5, 0.5]))

h = 10 / 250
alpha = 0.01
print(etl.compute(h, alpha))
