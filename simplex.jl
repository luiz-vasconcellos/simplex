# TODO: search the minimum positive pivot on setPivotIndex
# TODO: transpose the tableau and work with columns

function simplex(c, A, b)
    tableau = convert(Array{Float64}, initialTableau(c, A, b))

    while canImprove(tableau[1,:])
        pivotIndex = setPivotIndex(tableau)
        pivotAround(tableau, pivotIndex)
    end
    
    tableau
end

function initialTableau(c, A, b)
    X = [-c; A]
    X = [X b']
end

function canImprove(firstRow)
    # Has at least one negative element
    findfirst(x -> x < 0, firstRow) != 0
end

function setPivotIndex(tableau)
    # Pick first negative element and pick the least coeficient
    pivotCol = findfirst(x -> x < 0, tableau[1,:])
    quocients = tableau[2:end,end] ./ tableau[2:end, pivotCol]
    
    # Have to account for first line
    pivotLine = indmin(quocients) + 1
    (pivotLine, pivotCol)
end

function pivotAround(tableau, pivotIndex)
    # 'Normalizing the pivot line'
    tableau[pivotIndex[1],:] /= tableau[pivotIndex[1], pivotIndex[2]]

    # Continue with the Gauss-Jordan method for other lines
    for i=1:size(tableau, 1)
        if i != pivotIndex[1]
            tableau[i,:] -= tableau[i,pivotIndex[2]] * tableau[pivotIndex[1], :]
        end
    end
end

c = [3 2 0 0]
A = [1 2 1 0; 1 -1 0 1]
b = [0 4 1]

# c = [1 1 0 0]
# A = [2 1 1 0; 1 2 0 1]
# b = [0 4 3]

simplex(c, A, b)