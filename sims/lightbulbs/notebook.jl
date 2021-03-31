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

# ╔═╡ babc029c-8ef5-11eb-034a-256d516b3349
begin
	using Distributions
	using Colors
	using Plots
	using PlutoUI
end

# ╔═╡ 6517fae4-8ef5-11eb-3bfe-99851312c94b
md"# Simulate lighbulbs failure
"

# ╔═╡ 8bb44f9a-8ef5-11eb-3db0-2753662d6183
md"## Discrete time

We use one day as a time step. Each day the probability of light failure is `p`.
"

# ╔═╡ 13da6576-8ef6-11eb-2903-d7af313bd1f0
begin
	struct LightState
		lights::Array{Int64}
	end

	function init_lights(rows, cols)
		zeros(rows, cols) |> LightState
	end
end

# ╔═╡ 6d606dca-8ef6-11eb-288d-2f799ff64c07
md"### Visualize state"

# ╔═╡ 76feb8b4-8ef6-11eb-2c8f-8de15f827d97
function show_state(state::LightState)
	map(s -> if (s == 0) colorant"green" else colorant"red" end, state.lights)
end

# ╔═╡ 996efb88-8ef7-11eb-015c-d9b8d15b15a5
md"## Simulation step
Each light can fail at each time step with the probability of `p`
"

# ╔═╡ b6faf396-8ef7-11eb-1446-bbe2063779fc
function step!(state, t, p)
	(rows, cols) = size(state.lights)
	for r ∈ 1:rows
		for c ∈ 1:cols
			if state.lights[r, c] == 0 && rand() < p
				state.lights[r, c] = t
			end
		end
	end
end

# ╔═╡ 1f8d4fd8-8ef8-11eb-0466-5bbb1e42b08e
md"### Let's test it"

# ╔═╡ 9fec5810-8ef8-11eb-1d6a-f3a8d66588a4
md"### Simulate"

# ╔═╡ aa175436-8ef8-11eb-396e-d70e42000d62
function simulation(rows, cols, p, nsteps)
	state = init_lights(rows, cols)
	for n ∈ 1:nsteps
		step!(state, n, p)
	end
	state
end

# ╔═╡ e08692fa-8ef8-11eb-0862-8504f999c351
begin
	nsteps = 50
	state_100 = simulation(100, 100, 0.2, nsteps)
end;

# ╔═╡ 05aaa736-8ef9-11eb-32de-49966b34dd16
md"### Visualize state at th given time"

# ╔═╡ 14e8124e-8ef9-11eb-23a4-ad914e2c7b8c
function show_state(state, t)
	map(s -> if (s == 0 || s > t) colorant"green" else colorant"red" end, state.lights)
end

# ╔═╡ 096e1622-8ef7-11eb-0ec8-d3ef91080858
show_state(init_lights(10, 10))

# ╔═╡ 1d4ae9da-8ef8-11eb-18c4-91ad0b2cba34
begin
	state = init_lights(10, 10)
	step!(state, 1, 0.1)
	show_state(state)
end

# ╔═╡ 53bb69b0-8ef9-11eb-28b0-e709a0d80769
@bind step_time Slider(0:nsteps, show_value=true)

# ╔═╡ 9e0176e2-8ef9-11eb-2859-a78bca09f4c6
show_state(state_100, step_time)

# ╔═╡ eed95f88-8ef9-11eb-1398-7bc61b397371
md"### Number of live lights at each time"

# ╔═╡ 0acc2650-8efa-11eb-0609-1fcd1970def0
begin
	function to_series(state, length)
		xs = []
		for n ∈ 1:length
			v = sum(filter(s -> s > n, state.lights))
			push!(xs, v)
		end
		xs
	end
		
	xs = to_series(state_100, nsteps)
	plot(xs)
end

# ╔═╡ 453ee552-8eff-11eb-2b19-21ec6650dd93
md"## Continuos time"

# ╔═╡ Cell order:
# ╟─6517fae4-8ef5-11eb-3bfe-99851312c94b
# ╠═babc029c-8ef5-11eb-034a-256d516b3349
# ╟─8bb44f9a-8ef5-11eb-3db0-2753662d6183
# ╠═13da6576-8ef6-11eb-2903-d7af313bd1f0
# ╟─6d606dca-8ef6-11eb-288d-2f799ff64c07
# ╠═76feb8b4-8ef6-11eb-2c8f-8de15f827d97
# ╠═096e1622-8ef7-11eb-0ec8-d3ef91080858
# ╟─996efb88-8ef7-11eb-015c-d9b8d15b15a5
# ╠═b6faf396-8ef7-11eb-1446-bbe2063779fc
# ╟─1f8d4fd8-8ef8-11eb-0466-5bbb1e42b08e
# ╠═1d4ae9da-8ef8-11eb-18c4-91ad0b2cba34
# ╟─9fec5810-8ef8-11eb-1d6a-f3a8d66588a4
# ╠═aa175436-8ef8-11eb-396e-d70e42000d62
# ╠═e08692fa-8ef8-11eb-0862-8504f999c351
# ╟─05aaa736-8ef9-11eb-32de-49966b34dd16
# ╠═14e8124e-8ef9-11eb-23a4-ad914e2c7b8c
# ╠═53bb69b0-8ef9-11eb-28b0-e709a0d80769
# ╠═9e0176e2-8ef9-11eb-2859-a78bca09f4c6
# ╟─eed95f88-8ef9-11eb-1398-7bc61b397371
# ╠═0acc2650-8efa-11eb-0609-1fcd1970def0
# ╠═453ee552-8eff-11eb-2b19-21ec6650dd93
