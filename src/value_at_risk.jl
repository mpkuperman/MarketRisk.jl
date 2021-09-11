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

# function ValueAtRisk(portfolio, dist)
#     return ParametricValueAtRisk
# end

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

    function opt_func(x)
        cdf(dist, x) - α
    end

    D_opt(f) = x -> ForwardDiff.derivative(f, float(x))

       
    - find_zero((opt_func, D_opt(opt_func)), 0.0, Roots.Newton())
end


function compute(var::ParametricValueAtRisk{V, M, H, A, MixtureModel{B, D, NoncentralT, F}}) where {V, M, H, A, B, D, F}
    @unpack μ, Σ, h, α, dist = var 

    function opt_func(x)
        cdf(dist, x) - α
    end

    D_opt(f) = x -> central_fdm(5, 1)(f, x)

       
    - find_zero((opt_func, D_opt(opt_func)), 0.0, Roots.Newton())
end
