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

# ╔═╡ 1dfd0480-6b0d-11eb-1f62-dbdc1a677571
begin
	import Pkg; Pkg.add("Plotly")	
	import Pkg; Pkg.add("PyPlot")
	import Pkg; Pkg.add("PlutoUI")
	using PlutoUI
	using Plots
	using LinearAlgebra
	using SparseArrays
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



# ╔═╡ 86b1d820-6b2b-11eb-19cf-6390ab5fccc8
HTML("<div><br></div>")

# ╔═╡ 9f155e80-6be6-11eb-22c1-1b4f6e30ec72
md"Choose number of 👉 $(@bind iterations Slider(1:40, show_value = true)) crew members that roll the strange dice."

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
plot(
    B[:,1], B[:,2],
    line = (1.0, 2, :bar),
    normalize = false,
    bins = 10,
    marker = (6, 0.5, :x),
    markerstrokewidth = 5.,
    color = [:steelblue],
    fill = 0.9,
    orientation = :v,
    title = "The strange dice distribution",
	ylabel = "probability",
	xlabel = "Points",
	label = :none,
)

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
    title = string("Average distribution of \nstrange dice with ", string(iter+1), " gamblers"),
	ylabel = "probability / width of bar",
	xlabel = "Points",
	label = [:none :none "Mean"],
	ylim = [0,1],
)
	plot!([dice_mean - dice_std, dice_mean + dice_std, 3, dice_mean+dice_std, dice_mean-dice_std], 0.5.*[1, 1,NaN, 1, 1],
		line = (2., 2., :path),
		color = :magenta,
		arrow = true,
		label = "Std",
		)
	plot!([dice_mean - dice_std/sqrt(iter), dice_mean + dice_std/sqrt(iter), 3, dice_mean+dice_std/sqrt(iter), dice_mean-dice_std/sqrt(iter)], 0.08*[1, 1,NaN, 1, 1]/sqrt(((r[2]-r[1]))),
		line = (2., 2., :path),
		color = :green,
		arrow = true,
		label = string("Std/sqrt(",string(iter+1), ")"),
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

# ╔═╡ Cell order:
# ╟─1dfd0480-6b0d-11eb-1f62-dbdc1a677571
# ╟─e6375832-6b29-11eb-38b2-7582cac61e64
# ╟─86b1d820-6b2b-11eb-19cf-6390ab5fccc8
# ╟─29969590-6b12-11eb-11d7-9d831132fe4f
# ╟─e7e029f0-6b9c-11eb-179d-1d2fca9eb8af
# ╟─9f155e80-6be6-11eb-22c1-1b4f6e30ec72
# ╟─b7a9ad70-6b23-11eb-295b-4324ef257047
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
# ╟─b3279d30-6b22-11eb-0658-dbe663f09558
# ╟─6f072a20-6b23-11eb-0add-8b62821b708a
# ╟─89f8f100-6b24-11eb-3292-c15016c60a5b
# ╟─cec01d8e-6be2-11eb-1465-ad0f3ffcc2f5
