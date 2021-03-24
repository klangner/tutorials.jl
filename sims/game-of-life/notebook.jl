### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ daf9d31a-7508-11eb-0c8f-b1cff413c8b9
begin
	include("engine.jl")
	include("ui.jl")
	
	using Random: bitrand
end

# ╔═╡ b6555494-7508-11eb-2938-1d69951ca651
md"# Game of life simulation sandbox" 

# ╔═╡ 397c8234-7509-11eb-222e-2ffbcc8c036c
state = empty_state(20, 40)

# ╔═╡ b87bd4e4-750a-11eb-3780-d5eb07661b27
bitrand(Bool, [10, 5])

# ╔═╡ 46beabf2-7509-11eb-330c-e3353a9fabfb
display_state(state)

# ╔═╡ Cell order:
# ╟─b6555494-7508-11eb-2938-1d69951ca651
# ╠═daf9d31a-7508-11eb-0c8f-b1cff413c8b9
# ╠═397c8234-7509-11eb-222e-2ffbcc8c036c
# ╠═b87bd4e4-750a-11eb-3780-d5eb07661b27
# ╠═46beabf2-7509-11eb-330c-e3353a9fabfb
