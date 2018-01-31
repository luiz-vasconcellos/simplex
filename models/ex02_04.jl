using JuMP
using Clp

m = Model(solver = ClpSolver())

# Variables
c = [30 20 40 25 10]
@variable(m, x[1,1:5] >= 0)

# Objective
@objective(m, :Max, sum{c[i] * x[1,i], i=1:5})

# Constraints
@constraint(m, 2x[1,1] +  x[1,2] + 3x[1,3] + 3x[1,4] + x[1,5] <=  700)
@constraint(m, 3x[1,1] + 2x[1,2] + 2x[1,3] +  x[1,4] + x[1,5] <= 1000)

status = solve(m)
println("Objective value: ", getobjectivevalue(m))
println(getvalue(x))