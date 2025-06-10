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

# ╔═╡ 1dfd0480-6b0d-11eb-1f62-dbdc1a677571
begin
	using Pkg
	Pkg.activate(joinpath(DEPOT_PATH[1], "environments/v1.11"))
	using PlutoUI
	using Plots
	using LinearAlgebra
	using SparseArrays
	md""" 
	# Packages
	
	All needed Packages available :) """

end

# ╔═╡ e6375832-6b29-11eb-38b2-7582cac61e64
md"""

# **The strange dice** - _The central limit theorem_

**Bernoulli and Laplace** invented this interesting dice game with colored faces (red for odd numbers and green for even numbers of pips).
The side facing the gambler works as a bonus / malus factor. 

In the case of a green side facing the gambler, the points get doubled, in case of a red face the points get subtracted by minus 1.

At the trinautic tournament the whole crew is rolling the strange dice and the points are summed up.

Look at the distribution below that shows the probabilities for the different number of points.

**Use the slider to add crew members to play and look how the average distribution of points (total points divided by the number of gamblers) changes**



"""



# ╔═╡ 0ac7795a-56f8-40b4-b84e-1aa046ee4a7f
html"""<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/8H2p2ocNo4o?start=31" width=600 height=375  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>"""

# ╔═╡ 86b1d820-6b2b-11eb-19cf-6390ab5fccc8
HTML("<div><br></div>")

# ╔═╡ 9f155e80-6be6-11eb-22c1-1b4f6e30ec72
md"Choose number of 👉 $(@bind iterations Slider(1:60, show_value = true)) crew members that roll the strange dice."

# ╔═╡ 4e6cbd70-55fe-43fc-94b4-4ab8541d4f75
html"""<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/em5B4lnc_fo?start=104" width=600 height=375  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>"""

# ╔═╡ 4976c4b5-3f45-458d-83b8-3721abff5331
md"""
# About the creators

This notebook was created by **[Gerhard Dorn](https://github.com/dorn-gerhard)** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes22&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ 7ecb15e0-6b26-11eb-1d2b-37dd4e07ef05
HTML("<div><br><br><br><br><br><br><br><br><br><br><br><br><br></div>")

# ╔═╡ 185ef260-6b0b-11eb-1fd8-b5c70ec616d7
p = [1/6 1/6 1/6 1/6 1/6 1/6]

# ╔═╡ 943dea30-6b0b-11eb-19f0-75227e40a492
A = [ 3/4 1/4; 1/2 1/2; 3/4 1/4; 1/4 3/4; 1/2 1/2; 1/4 3/4]

# ╔═╡ 036a9bb0-6b0c-11eb-0ece-d54174c4d7a0
probability_table = A.*p'

# ╔═╡ 3eb465e0-6b14-11eb-19a4-df75db84f12d
sum(probability_table)

# ╔═╡ 427d9fb0-6b10-11eb-043c-653dbc050130
begin
	B = zeros(13,2)
	B[(1:6)',2] = probability_table[:,2]
	B[:,1] = (0:12)'
	index = collect(1:6)*2
	B[index.+1,2] = B[index.+1,2] + probability_table[:,1]
end

# ╔═╡ 29969590-6b12-11eb-11d7-9d831132fe4f
begin
	plot(
    B[:,1], B[:,2],
    line = (1.0, 0.0, :bar),
    normalize = false,
    bins = 10,
	bar_width = 0.1,
    marker = (6, 0.5, :x),
    markerstrokewidth = 5.,
    color = :steelblue,
    fill = 0.9,
    orientation = :v,
    title = "The strange dice distribution",
	ylabel = "probability mass function",
	xlabel = "Points",
	label = :none,
)
plot!( B[:,1], B[:,2],
    line = (1.0, 0, :path),
    normalize = false,
    bins = 10,
	bar_width = 0.2,
    marker = (4, 0.5, :o),
    markerstrokewidth = 5.,
    color = :steelblue,
    fill = 0.9,
    orientation = :v,
    title = "The strange dice distribution",
	ylabel = "probability mass function",
	xlabel = "Points",
	label = :none,
)
end

# ╔═╡ 6df0d2c0-6b10-11eb-04d1-1b71b887b8bb
B,sum(B[:,2])

# ╔═╡ 462e27c0-6b14-11eb-2b2f-3bd578fb8712
dice_mean = sum(B[:,2].*B[:,1])

# ╔═╡ 691d5aa0-6b71-11eb-2f53-db4a2217c8e0
dice_std = sqrt(sum(B[:,2].* (B[:,1].-dice_mean).^2))

# ╔═╡ 18e26640-6be7-11eb-20b0-5542c5620d8d
iter = iterations-1

# ╔═╡ 7dbbfe90-6b20-11eb-39c8-c99fd55ccf05
sparse_vector = repeat(B[:,2]',iter*12+1)

# ╔═╡ 80f0ce50-6b21-11eb-2b31-6982188b8a41
sparse_vector[:,1]

# ╔═╡ e107cae0-6b1d-11eb-3ff5-b7861639d659
P = Array(spdiagm(0 => sparse_vector[:,1], 1 => sparse_vector[:,2], 2 => sparse_vector[:,3], 3 => sparse_vector[:,4], 4 => sparse_vector[:,5], 5 => sparse_vector[:,6], 6 => sparse_vector[:,7], 7 => sparse_vector[:,8], 8 => sparse_vector[:,9], 9 => sparse_vector[:,10], 10=> sparse_vector[:,11], 11 => sparse_vector[:,12], 12 => sparse_vector[:,13]))

# ╔═╡ 58fe1a00-6b22-11eb-207c-095c2b30a0e6
pp = append!(B[:,2], zeros((iter)*12))	

# ╔═╡ b3279d30-6b22-11eb-0658-dbe663f09558
p_final = Array(pp'*P^(iter))

# ╔═╡ 6f072a20-6b23-11eb-0add-8b62821b708a
r = Array(LinRange(0,12,(iter-1)*12+13*2-1))

# ╔═╡ b7a9ad70-6b23-11eb-295b-4324ef257047
begin
	
	plot(
    [B[:,1], r, [dice_mean, dice_mean]], [B[:,2]./0.9,p_final[1,:]./((r[2]-r[1])*0.9), [0,1]],
    line = ([1 0.3 1], [0 0.0 3], [:bar :bar :line]),
	linestyle = [:auto :auto :dash],
    normalize = true,
    marker = (6, 0.8, [:none :none]),
    markerstrokewidth = 5.,
    color = [:steelblue :orangered :black],
    fill = [1. 1.],
	bar_width = [1*0.9 (r[2]-r[1])*0.9],
    orientation = :v,
    title = "Average distribution of \nstrange dice with "*string(iter+1)*" gamblers",
	ylabel = "probability / width of bar",
	xlabel = "Points",
	usetex = true,
	label = [:none :none "Mean"],
	ylim = [0,1],
)
	
	if iter > 0
	plot!([dice_mean - dice_std/sqrt(iter), dice_mean + dice_std/sqrt(iter), 3, dice_mean+dice_std/sqrt(iter), dice_mean-dice_std/sqrt(iter)], 0.08*[1, 1,NaN, 1, 1]/sqrt(((r[2]-r[1]))),
		line = (2., 2., :path),
		color = :green,
		arrow = true,
		label = "Std/sqrt(" * string(iter+1) *")",
		)
	end
	plot!([dice_mean - dice_std, dice_mean + dice_std, 3, dice_mean+dice_std, dice_mean-dice_std], 0.5.*[1, 1,NaN, 1, 1],
		line = (2., 2., :path),
		color = :magenta,
		arrow = true,
		label = "Std",
		)
end

# ╔═╡ 89f8f100-6b24-11eb-3292-c15016c60a5b
p_final[1,:]

# ╔═╡ cec01d8e-6be2-11eb-1465-ad0f3ffcc2f5
function pretty(M::Matrix{T} where T<:String)
	max_length = maximum(length.(M))
	dv="<div style='display:flex;flex-direction:row'>"
	HTML(dv*join([join("<div style='width:40px; text-align:center'>".*M[i,:].*"</div>", " ") for i in 1:size(M,1)]
			, "</div>$dv")*"</div>")
end

# ╔═╡ e7e029f0-6b9c-11eb-179d-1d2fca9eb8af
[string.(rand("🧔👩👨👧🧑", 1, iterations));string.(rand("🎲", 1, iterations))] |> pretty

# ╔═╡ 814e74fe-7774-47f4-99ff-6460fb266129
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
# ╟─e6375832-6b29-11eb-38b2-7582cac61e64
# ╟─0ac7795a-56f8-40b4-b84e-1aa046ee4a7f
# ╟─86b1d820-6b2b-11eb-19cf-6390ab5fccc8
# ╟─29969590-6b12-11eb-11d7-9d831132fe4f
# ╟─e7e029f0-6b9c-11eb-179d-1d2fca9eb8af
# ╟─9f155e80-6be6-11eb-22c1-1b4f6e30ec72
# ╟─b7a9ad70-6b23-11eb-295b-4324ef257047
# ╟─4e6cbd70-55fe-43fc-94b4-4ab8541d4f75
# ╟─4976c4b5-3f45-458d-83b8-3721abff5331
# ╠═1dfd0480-6b0d-11eb-1f62-dbdc1a677571
# ╟─7ecb15e0-6b26-11eb-1d2b-37dd4e07ef05
# ╟─185ef260-6b0b-11eb-1fd8-b5c70ec616d7
# ╟─943dea30-6b0b-11eb-19f0-75227e40a492
# ╟─036a9bb0-6b0c-11eb-0ece-d54174c4d7a0
# ╟─3eb465e0-6b14-11eb-19a4-df75db84f12d
# ╟─427d9fb0-6b10-11eb-043c-653dbc050130
# ╟─6df0d2c0-6b10-11eb-04d1-1b71b887b8bb
# ╟─691d5aa0-6b71-11eb-2f53-db4a2217c8e0
# ╟─462e27c0-6b14-11eb-2b2f-3bd578fb8712
# ╟─18e26640-6be7-11eb-20b0-5542c5620d8d
# ╟─7dbbfe90-6b20-11eb-39c8-c99fd55ccf05
# ╟─80f0ce50-6b21-11eb-2b31-6982188b8a41
# ╟─e107cae0-6b1d-11eb-3ff5-b7861639d659
# ╟─58fe1a00-6b22-11eb-207c-095c2b30a0e6
# ╠═b3279d30-6b22-11eb-0658-dbe663f09558
# ╠═6f072a20-6b23-11eb-0add-8b62821b708a
# ╠═89f8f100-6b24-11eb-3292-c15016c60a5b
# ╟─cec01d8e-6be2-11eb-1465-ad0f3ffcc2f5
# ╟─814e74fe-7774-47f4-99ff-6460fb266129
