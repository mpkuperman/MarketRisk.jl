
function cdf(d::UnivariateMixture, x::Real)
    p = probs(d)
    r = sum(pi * cdf(component(d, i), x) for (i, pi) in enumerate(p) if !iszero(pi))
    return r
end

