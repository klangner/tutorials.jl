### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 21549834-5a4e-11eb-008e-95fd40774ff0
begin
	using Luxor
	using WGLMakie
	WGLMakie.activate!()
	AbstractPlotting.inline!(true)
end

# ╔═╡ e1b5e61a-5a4d-11eb-0b0c-1955ae5103c9
md"
# Game of life implementation"

# ╔═╡ abde58f6-5a52-11eb-39e0-1d09d9e59acc
begin
	points = [Point2f0(cos(t), sin(t)) for t in LinRange(0, 2pi, 20)]
	colors = 1:20
	figure, axis, scatterobject = scatter(points, color = colors, markersize = 15)
	figure
end

# ╔═╡ 8f2b52d0-5a99-11eb-1864-2fca36841e9a
@svg begin
    text("Hello world")
    circle(Point(0, 0), 200, :stroke)
end

# ╔═╡ Cell order:
# ╟─e1b5e61a-5a4d-11eb-0b0c-1955ae5103c9
# ╠═21549834-5a4e-11eb-008e-95fd40774ff0
# ╠═abde58f6-5a52-11eb-39e0-1d09d9e59acc
# ╠═8f2b52d0-5a99-11eb-1864-2fca36841e9a
