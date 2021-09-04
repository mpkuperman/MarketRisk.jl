
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