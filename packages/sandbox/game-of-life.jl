### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ daf9d31a-7508-11eb-0c8f-b1cff413c8b9
begin
	using GameOfLife
	using PlutoUI
	using Plots
end

# ╔═╡ b6555494-7508-11eb-2938-1d69951ca651
md"# Game of life simulation
Try to build simulation from the groud up.
So first build some base components and then use them to build simulation
" 

# ╔═╡ d7a6aec2-8db5-11eb-16c6-858a44c0707b
md"
## Sample game state
"

# ╔═╡ b87bd4e4-750a-11eb-3780-d5eb07661b27
begin
	state = random_state(100, 100, 0.5)
	to_image(state)
end

# ╔═╡ 22b273e6-8e41-11eb-3c85-9bb97d634a68
md"## Run Simulator"

# ╔═╡ eb5aa660-8e41-11eb-3d33-c70e8cc79a54
states = simulate(100, 100, 100);

# ╔═╡ 83fff0c0-8e4d-11eb-1b14-87475beea6b8
begin
	frames = map( s -> Gray.(.! s.cells), states)

	anim = @animate for i = 1:length(frames)
		plot(frames[i], title = "Frame $(i)")
	end

	gif(anim, "gol-states.gif", fps = 30)
end

# ╔═╡ ea99554a-8e79-11eb-3ac0-29ebaf59e4de
md"## Show specific state"

# ╔═╡ 06438f86-8e7a-11eb-11c0-af946355f80f
@bind step Slider(1:length(states), show_value=true)

# ╔═╡ 28bab7a4-8e7a-11eb-0872-4bd56ae5ec7d
to_image(states[step])

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
# ╠═b87bd4e4-750a-11eb-3780-d5eb07661b27
# ╟─22b273e6-8e41-11eb-3c85-9bb97d634a68
# ╠═eb5aa660-8e41-11eb-3d33-c70e8cc79a54
# ╠═83fff0c0-8e4d-11eb-1b14-87475beea6b8
# ╟─ea99554a-8e79-11eb-3ac0-29ebaf59e4de
# ╠═06438f86-8e7a-11eb-11c0-af946355f80f
# ╠═28bab7a4-8e7a-11eb-0872-4bd56ae5ec7d
# ╟─2ed1a244-8e66-11eb-1016-db25966e439b
# ╠═5232530a-8e66-11eb-3398-99f77508748b
