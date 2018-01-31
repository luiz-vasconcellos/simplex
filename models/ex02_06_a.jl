using JuMP, Clp

model = Model(solver = ClpSolver())

# Variables
noSources, noPlants, noMarkets = 2, 2, 3
costSourcePlant    = [1 1.5; 2 1.5]
costPlantMarket    = [4 2 1; 3 4 2]
sourceAvailability = [10, 15]
marketDemand       = [8, 14, 3]

@variable(model, x[1:noSources, 1:noPlants] >= 0)
@variable(model, y[1:noPlants, 1:noMarkets] >= 0)

# Objective
@objective(model, :Min, sum{ (costSourcePlant .* x)[i,j], i=1:noSources,j=1:noPlants} +
                        sum{ (costPlantMarket .* y)[i,j], i=1:noPlants,j=1:noMarkets})

# Constraints
for i=1:noSources # Sum of resources leaving each source
    @constraint(model, sum{x[i,j], j=1:noPlants} == sourceAvailability[i] )
end
for i=1:noPlants # Plants deliver only what they receive from source
    @constraint(model, sum{x[j, i], j=1:noSources} - sum{y[i,j], j=1:noMarkets} == 0)
end
for j=1:noMarkets # Sum of resources delivered to market
    @constraint(model, sum{y[i,j], i=1:noPlants} == marketDemand[j] )
end

status = solve(model)
println("Minimum cost for transport: ", getobjectivevalue(model))
println("Source to Plant routes: ", getvalue(x))
println("Plant to market routes: ", getvalue(y))