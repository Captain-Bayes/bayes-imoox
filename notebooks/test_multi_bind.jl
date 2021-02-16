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
## **Sliders in different cells - multiparameter function does not work**: caching works 
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
## **Using a seed for the random variable:** 
"""

# ╔═╡ 934dd280-7069-11eb-29cd-2156919e9c30
md"""Choose seed 👉 $(@bind seed_2 Slider(1:1000, default = 1, show_value = true)) for random numbers.

Choose number of 👉 $(@bind row_slider_2 Slider(1:10,default=2, show_value = true)) rows of random matrix.

Choose number of 👉 $(@bind columns_slider_2 Slider(1:10,default=1, show_value = true)) columns of random matrix.

Choose the multipliaction factor 👉 $(@bind mult_fact_2 Select(["1"=>"One","10"=>"Ten","100"=>"Hundred","1000"=>"Thousand"]))
"""

# ╔═╡ 31eafc60-706a-11eb-0e11-6bac82af32fa
B = round.(Int,tryparse(Int, mult_fact_2)*rand(MersenneTwister(seed_2), row_slider_2, columns_slider_2))

# ╔═╡ 05c8a820-706b-11eb-3329-138b145aa667
md""" 
## **Using rand():** 
"""

# ╔═╡ 595bba00-706a-11eb-2ff7-e36aeec39df7
md"""
Choose number of 👉 $(@bind row_slider_3 Slider(1:10,default=2, show_value = true)) rows of random matrix.

Choose number of 👉 $(@bind columns_slider_3 Slider(1:10,default=1, show_value = true)) columns of random matrix.

Choose the multipliaction factor 👉 $(@bind mult_fact_3 Select(["1"=>"One","10"=>"Ten","100"=>"Hundred","1000"=>"Thousand"]))
"""

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
# ╟─934dd280-7069-11eb-29cd-2156919e9c30
# ╟─31eafc60-706a-11eb-0e11-6bac82af32fa
# ╟─05c8a820-706b-11eb-3329-138b145aa667
# ╟─595bba00-706a-11eb-2ff7-e36aeec39df7
# ╟─c7a10e30-7069-11eb-1b2d-e5e5f3846ac3
