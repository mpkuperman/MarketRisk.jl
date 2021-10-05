
struct ParametricExpectedTailLoss{M, S, H, A, D <: Distribution} <: MarketRiskMeasure
    μ::M
    Σ::S
    h::H
    α::A
    dist::D
end

function ExpectedTailLoss(μ, Σ, h, α, distribution)
    return ParametricExpectedTailLoss(μ, Σ, h, α, distribution)
end

function compute(etl::ParametricExpectedTailLoss{M, S, H, A, D}) where {M<:Real, S<:Real, H<:Real, A<:Real, D<:Normal}
    @unpack μ, Σ, h, α, dist = etl

    xα = quantile(dist, α)

    return 1 / α * pdf(dist, xα) * sqrt(h) * Σ - h * μ
end

function compute(etl::ParametricExpectedTailLoss{M, S, H, A, D}) where {M<:Real, S<:Real, H<:Real, A<:Array{Real}, D <: Normal}
    @unpack μ, Σ, h, α, dist = etl

    etl = Float64[]
    for αᵢ in α
        xαᵢ = quantile(dist, αᵢ)
        push!(etl, 1 / αᵢ * pdf(dist, xαᵢ) * sqrt(h) * Σ - h * μ)
    end
   
    return etl
end

function compute(etl::ParametricExpectedTailLoss{M, S, H, A, D}) where {M, S, H, A, D <: TDist}
    @unpack μ, Σ, h, α, dist = etl
    @unpack ν = dist

    xα = quantile(dist, α)

    factor = (ν - 2 + xα ^ 2) * (ν - 1) ^ (-1) * α ^ (-1)

    sqrt(h) * factor * pdf(dist, xα) * Σ - h * μ
end

function compute(etl::ParametricExpectedTailLoss{V, M, H, A, MixtureModel{B, D, Normal, F}}) where {V, M, H, A, B, D, F}
    @unpack μ, Σ, h, α, dist = etl

    function opt_func(x)
        cdf(dist, x) - α
    end
    
    D_opt(f) = x -> ForwardDiff.derivative(f, float(x))
       
    xα = find_zero((opt_func, D_opt(opt_func)), 0.0, Roots.Newton())

    cs = components(dist)
    πs = probs(dist)
    n = length(cs)

    return sum((1 / α) * πs[i] * pdf(dist, xα / cs[i].σ) * cs[i].σ - πs[i] * cs[i].μ for i in 1:n)
end

