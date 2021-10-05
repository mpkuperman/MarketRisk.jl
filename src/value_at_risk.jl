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

function compute(var::ParametricValueAtRisk{V, M, H, A, D}) where {V, M, H<:Real, A<:Real, D<:Normal}
    @unpack μ, Σ, h, α, dist = var 

    return sqrt(h) * quantile(dist, 1 - α) * Σ - h * μ
end

function compute(var::ParametricValueAtRisk{V, M, H, A, D}) where {V, M, H<:Real, A<:Array{Real}, D<:Normal}
    @unpack μ, Σ, h, α, dist = var 
    
    var = Float64[]

    for αᵢ in α
        push!(var, sqrt(h) * quantile(dist, 1 - αᵢ) * Σ - h * μ)
    end

    return var
end

function compute(var::ParametricValueAtRisk{V, M, H, A, D}) where {V, M, H, A, D<:TDist}
    @unpack μ, Σ, h, α, dist = var 
    @unpack ν = dist

    return sqrt((ν - 2) / ν) * sqrt(h) * quantile(dist, 1 - α) * Σ - h * μ
end

function compute(var::ParametricValueAtRisk{V, M, H, A, D}) where {V, M, H<:Real, A<:Array{Real}, D<:TDist}
    @unpack μ, Σ, h, α, dist = var 
    @unpack ν = dist

    var = Float64[]

    for αᵢ in α
        push!(var, sqrt((ν - 2) / ν) * sqrt(h) * quantile(dist, 1 - αᵢ) * Σ - h * μ)
    end

    return var 
end

function compute(var::ParametricValueAtRisk{V, M, H, A, MixtureModel{B, D, Normal, F}}) where {V, M, H, A, B, D, F}
    @unpack μ, Σ, h, α, dist = var 

    function opt_func(x, α)
        cdf(dist, x) - α
    end

    D_opt(f) = x -> ForwardDiff.derivative(f, float(x))
      
    return - find_zero((x -> opt_func(x, α), D_opt(x -> opt_func(x, α))), 0.0, Roots.Newton())
end

function compute(var::ParametricValueAtRisk{V, M, H, A, MixtureModel{B, D, Normal, F}}) where {V, M, H, A<:Array{Float64}, B, D, F}
    @unpack μ, Σ, h, α, dist = var 

    function opt_func(x, α)
        cdf(dist, x) - α
    end

    D_opt(f) = x -> ForwardDiff.derivative(f, float(x))

    var = Float64[]

    for αᵢ in α
        push!(var, - find_zero((x -> opt_func(x, αᵢ), D_opt(x -> opt_func(x, αᵢ))), 0.0, Roots.Newton()))
    end
       
    return var
end

