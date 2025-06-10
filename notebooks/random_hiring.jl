### A Pluto.jl notebook ###
# v0.20.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ ac65c4de-58f3-11eb-00c2-f9f83a4c01a2
begin
	using Pkg
	Pkg.activate(joinpath(DEPOT_PATH[1], "environments/v1.11"))
	using PlutoUI
	using Plots
	using LinearAlgebra
	using SparseArrays
	using DataFrames
	md""" 
	#### Packages
	
	All needed Packages available :) """
end

# ╔═╡ 5580aee0-6165-11eb-2967-ff278167c8d5
md"""
#### Random hiring
Captain Bayes: **To become a member of my crew please show how well you can produce random numbers. Proof your randomness!**

👉 Enter **200 digits** ´0-9´ in the textbox below!

"""
#$$G(x,y)=\frac{1}{2\pi \sigma^2}e^{\frac{-(x^2+y^2)}{2\sigma^2}}$$

# ╔═╡ 8fc47750-7ce3-11eb-1ef1-8103d38306b0
α = 4

# ╔═╡ be49b1d0-58f3-11eb-1770-23439de5d5b9
begin
	if 1 == 1
		md"""
		The result is
		"""
	end		
	@bind random_string TextField((40, 5); default="")
		
end

# ╔═╡ d0d472e0-7cde-11eb-34ea-7f3673d72de1
md""" Show histogram $(@bind check CheckBox())
"""

# ╔═╡ 57cfdfc0-6149-11eb-19bd-5f941bb1d8a5
@bind test Slider(0:10)

# ╔═╡ 2e10cb10-61a6-11eb-2f51-6b30066a00e6
HTML("<div><br><br><br></div>")

# ╔═╡ 4a826c10-6163-11eb-0077-fb171c3a7379
begin
	function arra(inp)
	try 
			if length(inp) == 0
				[]
			else
				parse.(Int,split(inp, "")) 
			end
	catch 
		0
	end
	end
end

# ╔═╡ 6650f3d2-6163-11eb-27e8-d7db2c942e54
arr = arra(random_string)

# ╔═╡ da8c8170-7cdd-11eb-0956-65a64d071dea
begin
	if check
histogram(arr, nbins=-0.5:9.5)
	end
end

# ╔═╡ a671e190-7a22-11eb-1f52-8de01eaa3eb8
if length(arr) > 0
	frequencies = [sum(arr .== i) for i in 0:9]
else
	frequencies = []
end

# ╔═╡ 3ca5e080-7a23-11eb-2385-b7708076f9c9
begin
# chi squared test
	N = length(arr)
	if (N > 0)
		chi_squared = sum((frequencies .- N*0.1).^2/(N*0.1))
	end	
	

end

# ╔═╡ 0e6160d0-7a2a-11eb-28c0-d97253f4fc90
# g test
if N > 0
	G = 1/2 * sum( frequencies .* log.(frequencies./(N*0.1)))
end

# ╔═╡ 697e0370-58f5-11eb-3da4-510b6c3d0118
length(arr) + test

# ╔═╡ dba94ef0-58f5-11eb-1857-cf90de0c4e14
prob = rand()

# ╔═╡ d37c5710-6163-11eb-36c6-dde1fbcc2099

if arr == 0
	
	md"""
!!! danger "Wrong characters!"
    **Please enter digits**: 0, 1, 2, 3, 4, 5, 6, 7 ,8 ,9
	"""

	else
		if isempty(arr)
	Markdown.MD(Markdown.Admonition("warning", "Hiring task!", [md"Please enter 200 digits below in the textbox."]))
elseif length(arr) == 200
	#!!! correct "Completed!" 
		
	#Captain Bayes asserts your random series stems from a good flat random generator with a probability of **$(prob)** %
	Markdown.MD(Markdown.Admonition("correct", "Completed!", [md"Captain Bayes asserts your random series stems from a good flat random generator with a probability of **$(prob)** %"]))
else
		Markdown.MD(Markdown.Admonition("warning", "Hiring task!", [md"Please enter $(200-length(arr)) digits below in the textbox."]))
end
	
end

# ╔═╡ 202d9b78-801d-48fe-b0d2-d75bc642e540
md"""
# About the creators

This notebook was created by **[Gerhard Dorn](https://github.com/dorn-gerhard)** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes22&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ 0c43ddb0-ae45-4773-bf34-3596aa2c1d46
begin
	
	# how to extract data from the non so csv csv file
	#=
	file_source = readdlm("data_marine_litter.csv", '\\')
		litter_count = []
		litter_mass = []
		for i in 3:986
			append!(litter_count, parse(Float64, reverse(split(file_source[i], ","))[8]))
		append!(litter_mass, parse(Float64, reverse(split(file_source[i], ","))[7]))
			end
		#a1 = convert(Array{Float64,1}, marine_numbers)
	
	writedlm("litter_beach.txt", [["count" "mass"]; [litter_count litter_mass]], "," )
	
	=#
end

# ╔═╡ Cell order:
# ╟─ac65c4de-58f3-11eb-00c2-f9f83a4c01a2
# ╟─5580aee0-6165-11eb-2967-ff278167c8d5
# ╟─d37c5710-6163-11eb-36c6-dde1fbcc2099
# ╠═8fc47750-7ce3-11eb-1ef1-8103d38306b0
# ╟─be49b1d0-58f3-11eb-1770-23439de5d5b9
# ╟─d0d472e0-7cde-11eb-34ea-7f3673d72de1
# ╟─da8c8170-7cdd-11eb-0956-65a64d071dea
# ╟─57cfdfc0-6149-11eb-19bd-5f941bb1d8a5
# ╠═2e10cb10-61a6-11eb-2f51-6b30066a00e6
# ╠═a671e190-7a22-11eb-1f52-8de01eaa3eb8
# ╠═3ca5e080-7a23-11eb-2385-b7708076f9c9
# ╠═0e6160d0-7a2a-11eb-28c0-d97253f4fc90
# ╠═4a826c10-6163-11eb-0077-fb171c3a7379
# ╠═6650f3d2-6163-11eb-27e8-d7db2c942e54
# ╟─697e0370-58f5-11eb-3da4-510b6c3d0118
# ╠═dba94ef0-58f5-11eb-1857-cf90de0c4e14
# ╟─202d9b78-801d-48fe-b0d2-d75bc642e540
# ╟─0c43ddb0-ae45-4773-bf34-3596aa2c1d46
