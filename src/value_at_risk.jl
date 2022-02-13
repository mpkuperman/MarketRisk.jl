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

    opt(x, α) = cdf(dist, x) - α
    D_opt(f) = x -> ForwardDiff.derivative(f, float(x))
      
    - find_zero((x -> opt(x, α), D_opt(x -> opt(x, α))), 0.0, Roots.Newton())[1]
end

function compute(var::ParametricValueAtRisk{V, M, H, A, MixtureModel{B, D, Normal, F}}) where {V, M, H, A<:Vector{<:Real}, B, D, F}
    @unpack μ, Σ, h, α, dist = var 

    opt(x, α) = cdf(dist, x) - α
    D_opt(f) = x -> ForwardDiff.derivative(f, float(x))
    
    v = zeros(eltype(α), length(α))
    for i in 1:length(α)  
        v[i] = - find_zero((x -> opt(x, α[i]), D_opt(x -> opt(x, α[i]))), 0.0, Roots.Newton())[1]
    end
    v
end