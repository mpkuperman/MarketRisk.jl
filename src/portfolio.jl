struct Portfolio{W, M, S}
    w::W
    μ::M
    Σ::S
end

function Portfolio(w::W, μ::M, Σ::S) where {W, M, S}
    return Portfolio{W, M, S}(w, μ, Σ)    
end

function Portfolio(w::Array{Float64}, tickers::Array{String}, period::Tuple)
    return Portfolio{W, M, S}(w, μ, Σ)
end

function mean(portfolio::Portfolio)
    @unpack w, μ, Σ = portfolio

    return dot(w, μ)
end 

function variance(portfolio::Portfolio)
    @unpack w, μ, Σ = portfolio

    return dot(w' * Σ, w)
end