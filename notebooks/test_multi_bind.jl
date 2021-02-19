### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ 4d9f28c0-6f82-11eb-1df0-f97522f733b1
begin
	#import Pkg;
	#Pkg.add("PlutoUI")
	#Pkg.add("Random")
	using PlutoUI
	using Random
end

# ╔═╡ 1d4cdc00-706b-11eb-3b0d-f7e15cd4ea6b
md""" 
## Many bind objects in a markdown interpolation: **multiparameter function does not work**
"""

# ╔═╡ 17f84e80-6f83-11eb-0a6c-133363e073d6
md"Choose seed 👉 $(@bind seed Slider(1:1000, default = 1, show_value = true)) for random numbers."

# ╔═╡ dd4da650-6f81-11eb-2565-f5fbd7f13c8c
md"Choose number of 👉 $(@bind row_slider Slider(1:10,default=2, show_value = true)) rows of random matrix."

# ╔═╡ 4bbfe170-6f82-11eb-10eb-89f060f3148f
md"Choose number of 👉 $(@bind columns_slider Slider(1:10,default=1, show_value = true)) columns of random matrix."

# ╔═╡ 1c6417a0-6f84-11eb-3bdd-c1dbff2b5c63
md"""
Choose the multipliaction factor 👉 $(@bind mult_fact Select(["1"=>"One","10"=>"Ten","100"=>"Hundred","1000"=>"Thousand"]))
"""

# ╔═╡ af0fec20-6f82-11eb-385a-0d297bfc5ba4
A = round.(Int,tryparse(Int, mult_fact)*rand(MersenneTwister(seed), row_slider, columns_slider))

# ╔═╡ 3e6b0f20-706a-11eb-2eb6-e5a0b72f57dc
md""" 
## Many bind objects with a **workaround of local variables in different cells** (Using a seed for the random variable)
"""

# ╔═╡ 7b626010-72d4-11eb-1f7f-0d63820d8b02
begin
	local bond_1_1 = @bind seed_2 Slider(1:1000, default = 1, show_value = true)
	md"""Choose seed 👉 $(bond_1_1) for random numbers.
"""
end

# ╔═╡ 9cbb5cd0-72d4-11eb-0e42-e79af8807c2d
begin
local bond_1 = @bind row_slider_2 Slider(1:10,default=2, show_value = true)
	md"""
Choose number of 👉 $(bond_1) rows of random matrix.
	"""
end

# ╔═╡ 934dd280-7069-11eb-29cd-2156919e9c30
begin
local bond_1 = @bind columns_slider_2 Slider(1:10,default=1, show_value = true)
md"""
Choose number of 👉 $(bond_1) columns of random matrix.
"""
end

# ╔═╡ d4c62240-72d4-11eb-0a92-15bd1bcbb249
begin
local bond_1 = @bind mult_fact_2 Select(["1"=>"One","10"=>"Ten","100"=>"Hundred","1000"=>"Thousand"])
md"""
Choose the multipliaction factor 👉 $(bond_1)
"""
end

# ╔═╡ 31eafc60-706a-11eb-0e11-6bac82af32fa
B = round.(Int,tryparse(Int, mult_fact_2)*rand(MersenneTwister(seed_2), row_slider_2, columns_slider_2))

# ╔═╡ 05c8a820-706b-11eb-3329-138b145aa667
md""" 
## **Using rand():** 
"""

# ╔═╡ 595bba00-706a-11eb-2ff7-e36aeec39df7
begin
local bond_1 = @bind row_slider_3 Slider(1:10,default=2, show_value = true)
local bond_2 = @bind columns_slider_3 Slider(1:10,default=1, show_value = true)
local bond_3 = @bind mult_fact_3 Select(["1"=>"One","10"=>"Ten","100"=>"Hundred","1000"=>"Thousand"])
md"""
Choose number of 👉 $(bond_1) rows of random matrix.

Choose number of 👉 $(bond_2) columns of random matrix.

Choose the multipliaction factor 👉 $(bond_3)
"""
end

# ╔═╡ c7a10e30-7069-11eb-1b2d-e5e5f3846ac3
C = round.(Int,tryparse(Int, mult_fact_3)*rand(row_slider_3, columns_slider_3))

# ╔═╡ Cell order:
# ╟─4d9f28c0-6f82-11eb-1df0-f97522f733b1
# ╟─1d4cdc00-706b-11eb-3b0d-f7e15cd4ea6b
# ╟─17f84e80-6f83-11eb-0a6c-133363e073d6
# ╟─dd4da650-6f81-11eb-2565-f5fbd7f13c8c
# ╟─4bbfe170-6f82-11eb-10eb-89f060f3148f
# ╟─1c6417a0-6f84-11eb-3bdd-c1dbff2b5c63
# ╟─af0fec20-6f82-11eb-385a-0d297bfc5ba4
# ╟─3e6b0f20-706a-11eb-2eb6-e5a0b72f57dc
# ╟─7b626010-72d4-11eb-1f7f-0d63820d8b02
# ╟─9cbb5cd0-72d4-11eb-0e42-e79af8807c2d
# ╟─934dd280-7069-11eb-29cd-2156919e9c30
# ╟─d4c62240-72d4-11eb-0a92-15bd1bcbb249
# ╟─31eafc60-706a-11eb-0e11-6bac82af32fa
# ╟─05c8a820-706b-11eb-3329-138b145aa667
# ╟─595bba00-706a-11eb-2ff7-e36aeec39df7
# ╟─c7a10e30-7069-11eb-1b2d-e5e5f3846ac3
