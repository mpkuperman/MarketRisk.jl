module MarketRisk

using LinearAlgebra
using Distributions
using ForwardDiff
using Parameters
using Roots

abstract type MarketRiskMeasure end

include("portfolio.jl")
include("value_at_risk.jl")
include("expected_tail_loss.jl")

export Normal, TDist, MixtureModel

export Portfolio, mean, variance
export ValueAtRisk, ExpectedTailLoss, compute

end
