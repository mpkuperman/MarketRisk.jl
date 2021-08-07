module MarketRisk

using Distributions
using GalacticOptim
using Parameters
using Roots

include("value_at_risk.jl")
include("expected_tail_loss.jl")

export Normal, TDist, ValueAtRisk, ExpectedTailLoss, MixtureModel, compute

end
