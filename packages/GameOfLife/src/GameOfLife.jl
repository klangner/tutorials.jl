module GameOfLife

using Random
using Distributions
using Colors

export WorldState, random_state, to_image, next_state, simulate,
    block_pattern, boat_pattern, blinker_pattern_1, blinker_pattern_2

struct WorldState 
    cells :: BitArray
end

function random_state(width::Integer, height::Integer, p::Float64) :: WorldState
    rand(Bernoulli(p), height, width) |> 
        WorldState
end

Base.:(==)(x::WorldState, y::WorldState) = x.cells == y.cells

function to_image(state::WorldState)
	Gray.(.! state.cells)
end

# Still lifes patterns
block_pattern = WorldState([
        0 0 0 0
        0 1 1 0
        0 1 1 0
        0 0 0 0])
boat_pattern = WorldState([
        0 0 0 0 0
        0 1 1 0 0
        0 1 0 1 0
        0 0 1 0 0
        0 0 0 0 0])

# Oscillators
blinker_pattern_1 = WorldState([
        0 0 0 0 0
        0 0 1 0 0
        0 0 1 0 0
        0 0 1 0 0
        0 0 0 0 0])
blinker_pattern_2 = WorldState([
        0 0 0 0 0
        0 0 0 0 0
        0 1 1 1 0
        0 0 0 0 0
        0 0 0 0 0])

function isalive(cells, row, col)
    dims = size(cells)
    if row < 1 || row > dims[1] || col < 1 || col > dims[2]
        false
    else
        cells[row, col]
    end
end

function count_neighbours(cells::BitArray, row, col)
    neighbours = [
        (row-1,col-1), (row-1,col), (row-1,col+1),
        (row,col-1), (row,col+1),	
        (row+1,col-1), (row+1,col), (row+1,col+1)]
    map(x -> isalive(cells, x[1], x[2]), neighbours) |>
        sum
end

function next_state(state::WorldState) :: WorldState
    (rows, cols) = size(state.cells)
    cells = falses(rows, cols)
    for r in 1:rows
        for c in 1:cols
            alives = count_neighbours(state.cells, r, c)
            if isalive(state.cells, r, c) && (alives == 2 || alives == 3)
                cells[r, c] = true
            elseif !isalive(state.cells, r, c) && alives == 3
                cells[r, c] = true
            else
                cells[r, c] = false
            end
        end
    end
    WorldState(cells)
end

function simulate(width, height, steps)
	state = random_state(width, height, 0.5)
	states = Vector{WorldState}()
	push!(states, state)
	
	for t in 1:steps
		state = next_state(state)
		push!(states, state)
	end
	states
end

end 
