### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 33a65d80-1b5e-11eb-2b74-019ea59af82f
begin
	using MLDatasets
	using Flux
	using Flux: Data.DataLoader
	using Flux: onehotbatch, onecold, crossentropy
	using Flux: @epochs
end

# ╔═╡ 0050e600-1b5e-11eb-2a8d-0530ed653b30
md""" 
# Flux with MNIST dataset
"""

# ╔═╡ 93999f78-1b92-11eb-36ea-855e3c5eb0f8
md"## Implementation"

# ╔═╡ 5e2285ec-1b5f-11eb-35ac-a7b68c20d22d
md"## Let's load dataset"

# ╔═╡ 685ae860-1b5f-11eb-034c-77dd624e7c6b
begin
	x_train, y_train = MNIST.traindata()
	x_test, y_test = MNIST.testdata()
	# Convert (28, 28, 60_000) shape into (28, 28, 1, 60_000)
	# This will add dimension for the channel
	x_train = Flux.unsqueeze(x_train, 3)
	x_test = Flux.unsqueeze(x_test, 3)
	# The output will be 1-hot encoded
	y_train = onehotbatch(y_train, 0:9)
	y_test = onehotbatch(y_test, 0:9)
	# Create full dataset
	train_data = DataLoader(x_train, y_train, batchsize=128)
end;

# ╔═╡ 881f839a-1b5f-11eb-2d0e-f9164f59b246
typeof(y_train)

# ╔═╡ b016da60-1b5f-11eb-1ea4-91a57abae1d3
md"Sample images"

# ╔═╡ Cell order:
# ╟─0050e600-1b5e-11eb-2a8d-0530ed653b30
# ╟─93999f78-1b92-11eb-36ea-855e3c5eb0f8
# ╠═33a65d80-1b5e-11eb-2b74-019ea59af82f
# ╟─5e2285ec-1b5f-11eb-35ac-a7b68c20d22d
# ╠═685ae860-1b5f-11eb-034c-77dd624e7c6b
# ╠═881f839a-1b5f-11eb-2d0e-f9164f59b246
# ╟─b016da60-1b5f-11eb-1ea4-91a57abae1d3
