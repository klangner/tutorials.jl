### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ daf9d31a-7508-11eb-0c8f-b1cff413c8b9
begin
	using Random
	using Distributions
	using Colors
	using PlutoUI
	using Plots
	# using ImageView
end

# ╔═╡ b6555494-7508-11eb-2938-1d69951ca651
md"# Game of life simulation
Try to build simulation from the groud up.
So first build some base components and then use them to build simulation
" 

# ╔═╡ d7a6aec2-8db5-11eb-16c6-858a44c0707b
md"
## Define game state
Add functions for state initialization
"

# ╔═╡ 397c8234-7509-11eb-222e-2ffbcc8c036c
begin
	struct WorldState 
		cells :: BitArray
	end
	
	function random_state(width::Integer, height::Integer, p::Float64) :: WorldState
		rand(Bernoulli(p), height, width) |> 
			WorldState
	end
	
	Base.:(==)(x::WorldState, y::WorldState) = x.cells == y.cells
end

# ╔═╡ b87bd4e4-750a-11eb-3780-d5eb07661b27
state = random_state(100, 100, 0.5)

# ╔═╡ 05bc6610-8db6-11eb-010e-adce97814836
md"
## Visualize state
"

# ╔═╡ 46beabf2-7509-11eb-330c-e3353a9fabfb
function show_state(state::WorldState)
	Gray.(.! state.cells)
end

# ╔═╡ 851c67ba-8db7-11eb-3902-6beb268a4dd6
show_state(state)

# ╔═╡ 6662be38-8e33-11eb-06b2-dd49cf282ce5
md"## Some interesting patterns"

# ╔═╡ 85d36720-8e33-11eb-270b-09cf746a1bb9
md"### Still lifes"

# ╔═╡ 9df3f5f6-8e33-11eb-340d-33400b6a224e
begin
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
end

# ╔═╡ ebce7198-8e33-11eb-3c5f-e125ba63240a
show_state(boat_pattern)

# ╔═╡ 0328603c-8e35-11eb-285a-b72328ebb6f8
md"### Oscillators"

# ╔═╡ 173508b4-8e35-11eb-0020-a1a88612c3be
begin
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
end

# ╔═╡ 245cf8e8-8e31-11eb-36e0-5dbd921752b6
md"## Change state

The rules:

 * Any live cell with two or three live neighbours survives.
 * Any dead cell with three live neighbours becomes a live cell.
 * All other live cells die in the next generation. Similarly, all other dead cells stay dead.
"

# ╔═╡ 7f223b76-8e31-11eb-113e-8dbc1b3a7533
begin
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
	
	@assert count_neighbours(block_pattern.cells, 1, 1) == 1
	@assert count_neighbours(block_pattern.cells, 2, 2) == 3
end

# ╔═╡ 21ab577e-8e32-11eb-03d1-3f010924ed86
md"### Add some tests"

# ╔═╡ 2c8afbc2-8e32-11eb-3083-25f445897f88
begin
	@assert next_state(block_pattern) == block_pattern
	@assert next_state(blinker_pattern_1) == blinker_pattern_2
	@assert next_state(blinker_pattern_2) == blinker_pattern_1
	
	md"Tests passed"
end

# ╔═╡ dbc34054-8e3c-11eb-00cc-718e726a4c63
show_state(state |> next_state |> next_state |> next_state |> next_state)

# ╔═╡ 22b273e6-8e41-11eb-3c85-9bb97d634a68
md"## Simulator"

# ╔═╡ 2e203272-8e41-11eb-39c4-5b682e121486
function simulate(width, height, steps)
	state = random_state(100, 100, 0.5)
	states = Vector{WorldState}()
	push!(states, state)
	
	for t in 1:steps
		state = next_state(state)
		push!(states, state)
	end
	states
end

# ╔═╡ eb5aa660-8e41-11eb-3d33-c70e8cc79a54
states = simulate(100, 100, 1000);

# ╔═╡ 83fff0c0-8e4d-11eb-1b14-87475beea6b8
begin
	frames = map( s -> Gray.(.! s.cells), states)

	anim = @animate for i = 1:length(frames)
		plot(frames[i], title = "Frame $(i)")
	end

	gif(anim, "frames_anim_fps30.gif", fps = 30)
end

# ╔═╡ 2ed1a244-8e66-11eb-1016-db25966e439b
md"## Analize simulation results

Let check how many alive cells ar at each time step
"

# ╔═╡ 5232530a-8e66-11eb-3398-99f77508748b
begin
	M = 10 		# Number of simulation runs
	N = 1000 	# Simulation steps
	xs = Vector{Vector{Int64}}()
	for m ∈ 1:M
		states = simulate(100, 100, N)
		x = map(s -> sum(s.cells), states)
		push!(xs, x)
	end
	plot(xs)
end

# ╔═╡ Cell order:
# ╟─b6555494-7508-11eb-2938-1d69951ca651
# ╠═daf9d31a-7508-11eb-0c8f-b1cff413c8b9
# ╟─d7a6aec2-8db5-11eb-16c6-858a44c0707b
# ╠═397c8234-7509-11eb-222e-2ffbcc8c036c
# ╠═b87bd4e4-750a-11eb-3780-d5eb07661b27
# ╟─05bc6610-8db6-11eb-010e-adce97814836
# ╠═46beabf2-7509-11eb-330c-e3353a9fabfb
# ╠═851c67ba-8db7-11eb-3902-6beb268a4dd6
# ╟─6662be38-8e33-11eb-06b2-dd49cf282ce5
# ╟─85d36720-8e33-11eb-270b-09cf746a1bb9
# ╠═9df3f5f6-8e33-11eb-340d-33400b6a224e
# ╠═ebce7198-8e33-11eb-3c5f-e125ba63240a
# ╟─0328603c-8e35-11eb-285a-b72328ebb6f8
# ╠═173508b4-8e35-11eb-0020-a1a88612c3be
# ╟─245cf8e8-8e31-11eb-36e0-5dbd921752b6
# ╠═7f223b76-8e31-11eb-113e-8dbc1b3a7533
# ╟─21ab577e-8e32-11eb-03d1-3f010924ed86
# ╠═2c8afbc2-8e32-11eb-3083-25f445897f88
# ╠═dbc34054-8e3c-11eb-00cc-718e726a4c63
# ╟─22b273e6-8e41-11eb-3c85-9bb97d634a68
# ╠═2e203272-8e41-11eb-39c4-5b682e121486
# ╠═eb5aa660-8e41-11eb-3d33-c70e8cc79a54
# ╠═83fff0c0-8e4d-11eb-1b14-87475beea6b8
# ╟─2ed1a244-8e66-11eb-1016-db25966e439b
# ╠═5232530a-8e66-11eb-3398-99f77508748b
