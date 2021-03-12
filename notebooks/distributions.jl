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

# ╔═╡ 73555af0-8353-11eb-215d-d3578a6f1e2e
begin
	try
		using PlutoUI
		using Plots
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
		#using StatsBase
		#using Random
		md""" 
		# Packages
		
		All needed Packages available :) """
	catch
		using Pkg;
		Pkg.activate(mktempdir())
		Pkg.add("PlutoUI")
		Pkg.add("Plots")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		using PlutoUI
		using Plots
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
		#using StatsBase
		#using Random
		md""" 
		# Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
end

# ╔═╡ d141cf00-8352-11eb-2e51-f115e26e1570
md"""
# Distributions
Here you can explore some of the most famous discrete probability distributions
"""

# ╔═╡ e6d68ef0-8352-11eb-1999-0384c7ff8526
md"""
## Poisson distribution

The Poisson distribution is given by

$P(K|\lambda) = \frac{\lambda^K}{K!} \textrm{e}^{-\lambda}$

with $K$ the number of observed counts per interval given that $\lambda$ discribes the fixed average of counts per interval.
"""


# ╔═╡ 6196a940-8353-11eb-1a09-29cb2338d697
md"""
Vary the parameter of $\lambda$: $(@bind lambda Slider(0:1:18, default=1, show_value = true))
"""

# ╔═╡ a88ae050-8353-11eb-3eee-b7ee9b717fdb
begin	
	
	k =0:1:17
	poisson = lambda.^k./gamma.(k.+1).*exp(-lambda)
	
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
	xlabel = "K - number of counting events",
	label = :none,
	ylim =[0,1],
)
	t = 0:0.1:17
	poisson2 = lambda.^t./gamma.(t.+1).*exp(-lambda)
	plot!(t, poisson2, line=(0.1, 1.0, :line), linestyle=:dash, color = :red, label=:none)

end

# ╔═╡ Cell order:
# ╟─73555af0-8353-11eb-215d-d3578a6f1e2e
# ╟─d141cf00-8352-11eb-2e51-f115e26e1570
# ╟─e6d68ef0-8352-11eb-1999-0384c7ff8526
# ╟─6196a940-8353-11eb-1a09-29cb2338d697
# ╟─a88ae050-8353-11eb-3eee-b7ee9b717fdb
