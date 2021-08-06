module MarketRisk

using Distributions
using GalacticOptim
using Parameters
using Roots

include("value_at_risk.jl")

export ValueAtRisk, compute

end # module
