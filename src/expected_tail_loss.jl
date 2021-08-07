
struct ParametricExpectedTailLoss{M, S, D <: Distribution} <: MarketRiskMeasure
    μ::M
    Σ::S
    dist::D
end

function ExpectedTailLoss(μ, Σ, distribution)
    return ParametricExpectedTailLoss(μ, Σ, distribution)
end

function ExpectedTailLoss(portfolio, distribution)
    @unpack μ, Σ = portfolio
    
    return ParametricExpectedTailLoss(μ, Σ, distribution)
end


function compute(etl::ParametricExpectedTailLoss{M, S, D}, h, α) where {M, S, D<:Normal}
    @unpack μ, Σ, dist = etl

    xα = quantile(dist, α)

    return 1 / α * pdf(dist, xα) * sqrt(h) * Σ - h * μ
end

function compute(etl::ParametricExpectedTailLoss{M, S, D}, h, α) where {M, S, D<:TDist}
    @unpack μ, Σ, dist = etl
    @unpack ν = dist

    xα = quantile(dist, α)

    factor = (ν - 2 + xα ^ 2) * (ν - 1) ^ (-1) * α ^ (-1)

    return sqrt(h) * factor * pdf(dist, xα) * Σ - h * μ
end