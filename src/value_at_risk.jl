struct ParametricValueAtRisk{V, M, H, A, D<:Distribution} <: MarketRiskMeasure
    μ::V
    Σ::M
    h::H
    α::A
    dist::D
end

function ValueAtRisk(μ, Σ, h, α, dist)
    return ParametricValueAtRisk(μ, Σ, h, α, dist)
end

function compute(var::ParametricValueAtRisk{V, M, H, A, D}) where {V, M, H, A, D<:Normal}
    @unpack μ, Σ, h, α, dist = var 

    @. sqrt(h) * quantile(dist, 1 - α) * Σ - h * μ
end

function compute(var::ParametricValueAtRisk{V, M, H, A, D}) where {V, M, H, A, D<:TDist}
    @unpack μ, Σ, h, α, dist = var 
    @unpack ν = dist

    @. sqrt((ν - 2) / ν) * sqrt(h) * quantile(dist, 1 - α) * Σ - h * μ
end

function compute(var::ParametricValueAtRisk{V, M, H, A, MixtureModel{B, D, Normal, F}}) where {V, M, H, A, B, D, F}
    @unpack μ, Σ, h, α, dist = var 

    D_opt(f) = x -> ForwardDiff.derivative(f, float(x))
      
    @. - find_zero((x -> cdf(dist, x) - α, D_opt(x -> opt_func(x, α))), 0.0, Roots.Newton())
end
