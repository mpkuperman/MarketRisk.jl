
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

# function ExpectedTailLoss(portfolio, distribution)
#     @unpack μ, Σ = portfolio
    
#     return ParametricExpectedTailLoss(μ, Σ, distribution)
# end


function compute(etl::ParametricExpectedTailLoss{M, S, H, A, D}) where {M, S, H, A, D <: Normal}
    @unpack μ, Σ, h, α, dist = etl

    xα = quantile(dist, α)

    @. 1 / α * pdf(dist, xα) * sqrt(h) * Σ - h * μ
end

function compute(etl::ParametricExpectedTailLoss{M, S, H, A, D}) where {M, S, H, A, D <: TDist}
    @unpack μ, Σ, h, α, dist = etl
    @unpack ν = dist

    xα = quantile(dist, α)

    factor = (ν - 2 + xα ^ 2) * (ν - 1) ^ (-1) * α ^ (-1)

    @. sqrt(h) * factor * pdf(dist, xα) * Σ - h * μ
end

function compute(etl::ParametricExpectedTailLoss{V, M, H, A, MixtureModel{B, D, Normal, F}}) where {V, M, H, A, B, D, F}
    @unpack μ, Σ, h, α, dist = etl
    @unpack ν = dist

    function opt_func(x)
        cdf(dist, x) - α
    end
    
    D_opt(f) = x -> ForwardDiff.derivative(f, float(x))
       
    xα = find_zero((opt_func, D_opt(opt_func)), 0.0, Roots.Newton())

    cs = components(dist)
    πs = probs(dist)
    n = length(cs)

    (1 / α) * sum(πs[i] * (pdf(xα / (sqrt(h) * cs[i].σ)) * (sqrt(h) * cs[i].σ) - h * cs[i].μ[i]) for i in 1:n)
end

