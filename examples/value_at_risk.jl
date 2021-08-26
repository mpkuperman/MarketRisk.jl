using MarketRisk

μ = 0.0462 * 1 / 250
Σ = sqrt(0.1757 ^ 2 * 1 / 250)
ν = 4.14

N = Normal()
T = TDist(ν)

normal_var = ValueAtRisk(μ, Σ, N)
student_var = ValueAtRisk(μ, Σ, T) 

h = 1.
αs = [0.1, 0.01, 0.001]

nvars = Float64[]
svars = Float64[]

for α in αs
    push!(nvars, compute(normal_var, h, α))
    push!(svars, compute(student_var, h, α))
end


nvars
svars