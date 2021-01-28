### A Pluto.jl notebook ###
# v0.12.19

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

# ╔═╡ ac65c4de-58f3-11eb-00c2-f9f83a4c01a2
using PlutoUI

# ╔═╡ e9a39080-58f3-11eb-0820-e9193f46ea26
md"Captain Bayes: Please enter a sequence of 200 random numbers 0-9 in that textbox to become a member of my crew. Proof yourself!"

# ╔═╡ be49b1d0-58f3-11eb-1770-23439de5d5b9
@bind random_string TextField((40, 5); default = "0")

# ╔═╡ e76f7270-58f3-11eb-37b2-fd410fcf6082
arr = parse.(Int,split(random_string, ""))

# ╔═╡ df0e72f0-58f5-11eb-0e71-f7978d71a236
md"TODOs: Catch error of non entering a digit!"

# ╔═╡ 697e0370-58f5-11eb-3da4-510b6c3d0118
size(arr)

# ╔═╡ ecc1d590-58f5-11eb-1583-7d6ca45be736
md"Write code to evaluate randomness of input"

# ╔═╡ dba94ef0-58f5-11eb-1857-cf90de0c4e14
rand()

# ╔═╡ Cell order:
# ╟─ac65c4de-58f3-11eb-00c2-f9f83a4c01a2
# ╟─e9a39080-58f3-11eb-0820-e9193f46ea26
# ╠═be49b1d0-58f3-11eb-1770-23439de5d5b9
# ╠═e76f7270-58f3-11eb-37b2-fd410fcf6082
# ╠═df0e72f0-58f5-11eb-0e71-f7978d71a236
# ╠═697e0370-58f5-11eb-3da4-510b6c3d0118
# ╠═ecc1d590-58f5-11eb-1583-7d6ca45be736
# ╠═dba94ef0-58f5-11eb-1857-cf90de0c4e14
