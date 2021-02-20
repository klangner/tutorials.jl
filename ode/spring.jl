### A Pluto.jl notebook ###
# v0.12.18

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

# ╔═╡ c4abb902-59d3-11eb-3c56-d1dedbba2d88
begin
	using Plots
end

# ╔═╡ 17db9974-5901-11eb-1120-7f0439234487
md"
# Simulator for moving mass connected to the spring horizontally
"

# ╔═╡ ab090018-5a44-11eb-0a05-e79aa77a88b5
md"
## Define model
"

# ╔═╡ bcaa1106-5a44-11eb-2e5d-cb69d9dfebb8
function spring_model(m, x₀, k, Δt, time)
	data = zeros(0)	# Output data
	x = x₀ 			# Current position
	a = 0 			# Current acceleration
	v = 0 			# Velocity
	t = 0 			# Current time
	append!(data, x)
	while t < time
		a = -k*x/m
		v = a * Δt + v
		x = v * Δt + x
		append!(data, x)
		t = t + Δt
	end
	data
end

# ╔═╡ d10f886e-5a45-11eb-1d16-4b5d4ca43ecf
md"## Run simulation"

# ╔═╡ ac78f3cc-5901-11eb-2304-53ac0a4edbf7
begin
	mass_slider = @bind mass html"<input type='range' min='0.0' max='100' step='1' value='10'>"
	x_slider = @bind initial_pos html"<input type='range' min='-10.0' max='10.0' step='0.1' value='0.0'>"

	
	md"""**Please set model parameters:**
	
	Mass: $(mass_slider) grams
	
	``x_0``: $x_slider meters
	
	"""
end

# ╔═╡ 317bceae-5903-11eb-29d5-b7ad5a3114f6
md"
  * Mass: $mass
  * Initial position: $initial_pos
"

# ╔═╡ 05f016e8-5906-11eb-0ee0-536e06223af8
begin
	y = spring_model(mass, initial_pos, 1, 1, 100)
	x = 1:length(y)
	plot(x, y)
end

# ╔═╡ Cell order:
# ╟─17db9974-5901-11eb-1120-7f0439234487
# ╠═c4abb902-59d3-11eb-3c56-d1dedbba2d88
# ╟─ab090018-5a44-11eb-0a05-e79aa77a88b5
# ╠═bcaa1106-5a44-11eb-2e5d-cb69d9dfebb8
# ╟─d10f886e-5a45-11eb-1d16-4b5d4ca43ecf
# ╟─ac78f3cc-5901-11eb-2304-53ac0a4edbf7
# ╟─317bceae-5903-11eb-29d5-b7ad5a3114f6
# ╠═05f016e8-5906-11eb-0ee0-536e06223af8
