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

# ╔═╡ 8d4298e0-6c44-11eb-3406-31a39340d1aa
begin
	import Pkg; Pkg.add("Plotly")	
	Pkg.add("PyPlot")
	Pkg.add("PlutoUI")
	Pkg.add("SpecialFunctions")
	Pkg.add("StatsBase")
	Pkg.add("Plots")
	Pkg.add("LinearAlgebra")
	Pkg.add("SparseArrays")
	using PlutoUI
	using Plots
	using LinearAlgebra
	using SparseArrays
	using SpecialFunctions
	using StatsBase
end

# ╔═╡ 9637fe40-6c44-11eb-1df3-eb0b0d36db34
md"""

# **The golden Nautilus wheel** - _Distributions and the law of large numbers_

**Captain Bayes and Captain Venn** are investigating the **golden Nautilus wheel** and are wondering how one can make predictions about the minimum free days ratio.

A **rough rule of thumb** says that for most distributions the standard deviation can be used as a measure of how much probability mass is **spread around the mean value**, namely that within the following intervals one can find:

$P(X ∈ [μ - σ, μ + σ])  ≈ 67\%,$ 
$P(X ∈ [μ - 2σ, μ + 2σ]) ≈ 95\%,$
$P(X ∈ [μ - 3σ, μ + 3σ]) ≈ 99\%.$

In the following diagram you see the **probability distribution of wages** for the the four tasks of the golden Nautilus wheel, You can **change the wages** Captain Venn pays for each task





"""


# ╔═╡ 9de6ada0-6c56-11eb-1055-1b29b78e6112
md"""
**Use the slider to change the number of measurements sample size $n$ Captain Venn performs and watch the histogram**
"""

# ╔═╡ 8b8cd540-6d86-11eb-339e-7b8a2df774f9
md"Choose the **number of measurements / the sample size $n$** 👉 $(@bind n_sample_size Slider(100:100:10000, default=1000, show_value = true)) "

# ╔═╡ 84bfd150-6d8a-11eb-011e-052c39c8db9c
x_rand_var = [1, 3, 4, 6]

# ╔═╡ b7a7b220-6c56-11eb-1e6c-6f7595f02439
md"""
In order to see the variation of the sample we **repeat the measurements with fixed sample size** ($n$) $N$ times. This way we can **sample the distribution of the sample mean value** (which is a random variable in contrast to the real sample mean). Use the slider to change the number of repeated measurements $N$ of samples of size $n$**

You can change between the **distributions of wages and free days**.
"""

# ╔═╡ 835da8c0-6c57-11eb-0a71-e776862dbfce
md"""
Example of some other distributions: **Poisson distriubtion**
"""

# ╔═╡ 1b51ce3e-6c58-11eb-2539-a34e0576c612
@bind lambda Slider(0.1:0.1:19, default=1, show_value = true)

# ╔═╡ 0e35a290-6c58-11eb-2004-0b4b90f9754e
k =0:0.1:20

# ╔═╡ 14661b90-6c58-11eb-28bd-4399c5896666
poisson = lambda.^k./gamma.(k.+1).*exp(-lambda)

# ╔═╡ b016de70-6c59-11eb-2ae2-b9ee6e5f2abd
begin	
	plot(
    k, poisson,
    line = (0.0 , 2.0 , :bar),
    normalize = false,
	bar_width = 0.13,
    marker = (6, 0.5, :none),
    markerstrokewidth = 5.,
    color = [:steelblue],
    fill = 0.9,
    orientation = :v,
    title = "The Poisson distribution with lambda: "*string(lambda),
	ylabel = "probability mass function",
	xlabel = "Points",
	label = :none,
	ylim =[0,1],)
	
	plot!(
    k, poisson,
    line = ( 1, 0., :path),
    normalize = false,
    marker = (3, 0.5, :o),
    markerstrokewidth = 3.,
    color = [:steelblue],
    fill = 0.,
    orientation = :v,
    title = "The Poisson distribution with lambda: "*string(lambda),
	ylabel = "probability mass function",
	xlabel = "k - number of events",
	label = :none,
	ylim =[0,1],
)

end


# ╔═╡ 06a6c020-6c5a-11eb-3516-e5d4f4740be9
sum(poisson)

# ╔═╡ 3d66c0a0-6c5b-11eb-0fd0-0bd81c9672c9
begin
	@userplot CirclePlot
@recipe function f(cp::CirclePlot)
    x, y, i = cp.args
    n = length(x)
    inds = circshift(1:n, 1 - i)
    linewidth --> range(0, 10, length = n)
    seriesalpha --> range(0, 1, length = n)
    aspect_ratio --> 1
    label --> false
    x[inds], y[inds]
end

n = 150
t = range(0, 2π, length = n)
x = sin.(t)
y = cos.(t)

anim = @animate for i ∈ 1:n
    circleplot(x, y, i)
end
gif(anim, "anim_fps15.gif", fps = 15)
end

# ╔═╡ 48f7c480-6d84-11eb-1f24-e16d7f649c9c
phi = (1+sqrt(5))/2

# ╔═╡ 534e1970-6d84-11eb-3f16-bb6aaa46db6f
prob = phi.^(0:3)./sum(phi.^(0:3))

# ╔═╡ 1df828e0-6d86-11eb-0d3c-2398e6700066
sample = 5 .- sum(rand(1,n_sample_size) .<= cumsum(prob), dims=1)

# ╔═╡ cfdaa470-6d86-11eb-03a6-ef281daeebb2
sample_count = [count(==(i), sample) for i = 1:4]

# ╔═╡ 5e0bfb10-6d8a-11eb-06ef-9335eb90064c
begin	
	plot(x_rand_var, sample_count,
    line = (0.0 , 2.0 , :bar),
    normalize = false,
	bar_width = 0.04,
    marker = (6, 0.5, :none),
    markerstrokewidth = 5.,
    color = [:steelblue],
    fill = 0.9,
    orientation = :v,
    title = "The Poisson distribution with lambda: ",
	ylabel = "probability mass function",
	xlabel = "Points",
	label = :none,
	ylim =[0,n_sample_size/2])
	
	plot!(
    x_rand_var, sample_count,
    line = ( 1, 0., :path),
    normalize = false,
    marker = (5, 1.0, :o),
    markerstrokewidth = 3.,
    color = [:steelblue],
    fill = 0.,
    orientation = :v,
    title = "The Poisson distribution with lambda: "*string(lambda),
	ylabel = "probability mass function",
	xlabel = "k - number of events",
	label = :none,
	ylim =[0,n_sample_size/2])
end

# ╔═╡ Cell order:
# ╠═8d4298e0-6c44-11eb-3406-31a39340d1aa
# ╟─9637fe40-6c44-11eb-1df3-eb0b0d36db34
# ╟─9de6ada0-6c56-11eb-1055-1b29b78e6112
# ╟─8b8cd540-6d86-11eb-339e-7b8a2df774f9
# ╠═84bfd150-6d8a-11eb-011e-052c39c8db9c
# ╟─5e0bfb10-6d8a-11eb-06ef-9335eb90064c
# ╟─b7a7b220-6c56-11eb-1e6c-6f7595f02439
# ╟─835da8c0-6c57-11eb-0a71-e776862dbfce
# ╟─1b51ce3e-6c58-11eb-2539-a34e0576c612
# ╟─b016de70-6c59-11eb-2ae2-b9ee6e5f2abd
# ╠═0e35a290-6c58-11eb-2004-0b4b90f9754e
# ╠═14661b90-6c58-11eb-28bd-4399c5896666
# ╠═06a6c020-6c5a-11eb-3516-e5d4f4740be9
# ╠═3d66c0a0-6c5b-11eb-0fd0-0bd81c9672c9
# ╠═48f7c480-6d84-11eb-1f24-e16d7f649c9c
# ╠═534e1970-6d84-11eb-3f16-bb6aaa46db6f
# ╠═1df828e0-6d86-11eb-0d3c-2398e6700066
# ╠═cfdaa470-6d86-11eb-03a6-ef281daeebb2
