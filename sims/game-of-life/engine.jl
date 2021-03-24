# # Game of life simulation engine
#
# Simulation is build as an engine which runs and returns traces, Traces can be used to replay simulation or do analysis.
#
# It means that the simulation engine is not responsible for displaying the state nor doing any online analysis.


struct WorldState
	data::BitArray
end

struct World
	width::Integer
	height::Integer
	state::WorldState
end

function empty_state(width::Integer, height::Integer)
	WorldState(falses(height, width))
end

function random_state(width::Integer, height::Integer, seed, prob::Float) :: WorldState
	WorldState(falses(height, width))
end

