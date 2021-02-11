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

# ╔═╡ a38a9620-6bea-11eb-2293-c5469f2d5bdc
begin
	import Pkg; Pkg.add("Plotly")	
	import Pkg; Pkg.add("PyPlot")
	import Pkg; Pkg.add("PlutoUI")
	import Pkg; Pkg.add("DataFrames")
	using PlutoUI
	using Plots
	using LinearAlgebra
	using SparseArrays
	using DataFrames
end

# ╔═╡ 05f72bc0-6c45-11eb-3602-c955811f9acf

md" Choose the **number of data points** Pascal is using in her statistics 👉 $(@bind n_data_points Slider(500:100:2000, default=1000, show_value = true)) "


# ╔═╡ 70049580-6bea-11eb-390b-d3013dd12235
md"Choose **probability** of the **ocean current** to lead to a deviation 👉 $(@bind ocean_current_prob Slider(0:0.05:0.3, show_value = true)) "

# ╔═╡ deb2ef40-6bea-11eb-3a13-c9642d262b93
md"Choose **probability** of the **Pascal fail on keeping the course** 👉 $(@bind pascal_fail_prob Slider(0:0.05:0.3, show_value = true)) "

# ╔═╡ 08bf49de-6bec-11eb-1b80-5f6e74cbb8d0
@bind direction_of_current Select([ "north" => "North ⬆️", "east" => "East ➡️", "south" => "South ⬇️", "west" => "West ⬅️"])

# ╔═╡ 18893b90-6c5c-11eb-051d-95eef7af0f0f


# ╔═╡ 335a84c0-6bf2-11eb-3249-fbfb0210657c
dd = Dict([(1, "north"), (2, "east"), (3, "south"), (4, "west")])

# ╔═╡ 26e7f8d0-6bed-11eb-09d6-a1597aeefc22
direction_of_current == "north"

# ╔═╡ c4582980-6bef-11eb-18e9-0b1732c8d932
direction = rand(1:4, n_data_points)

# ╔═╡ dc84d260-6bef-11eb-1e6c-23d28cf6b1d3
begin
	rr = rand(n_data_points)
	sail_deviation = zeros(1,n_data_points)
	#sail_correct = pascal_fail_prob/2 .< rr .< 1-pascal_fail_prob/2;
	sail_deviation = (-(rr .<= pascal_fail_prob/2)) + (rr.>= 1-pascal_fail_prob/2)
	
end

# ╔═╡ 71561790-6bf1-11eb-1acf-a1a46a8eb3d8
begin 
	ss = rand(n_data_points)
	if direction_of_current == "north"
		left_drift = 2;
		right_drift = 4;
	elseif direction_of_current == "east"
		left_drift = 3 ;
		right_drift = 1;
	elseif direction_of_current == "south"
		left_drift = 4 ;
		right_drift = 2;
	else 
		left_drift = 1;
		right_drift = 3;
	end
	
	added_deviation = (ss .<= ocean_current_prob) .*((-(direction .== left_drift)) + (direction .== right_drift))
	
end

# ╔═╡ 054eba90-6bf4-11eb-2214-ede88296a7b8
deviation = sail_deviation .+ added_deviation

# ╔═╡ 34da1880-6bf5-11eb-3e34-838a118066b4
table = [[sum(deviation[ direction .==i] .<= -1) for i=1:4] [sum(deviation[ direction .==i] .== 0) for i=1:4] [sum(deviation[ direction .==i] .>= 1) for i=1:4]]

# ╔═╡ 9d0230c0-6bf8-11eb-2445-777f55b92f4a
DataFrame([["North: "; "East:  "; "South: "; "West:  "] table], [:direction, :left_dev, :no_dev, :right_dev])

# ╔═╡ d83840b0-6c54-11eb-31d3-4d1d978c4e4a
table

# ╔═╡ 83cb7cd0-6bf6-11eb-2486-3f0ffc2c8416
(table[:,1] .+ table[:,3])./sum(table, dims=2)

# ╔═╡ 9b0e3050-6bf5-11eb-18df-c9ec17fc42be
sum(table,dims=1)

# ╔═╡ Cell order:
# ╟─a38a9620-6bea-11eb-2293-c5469f2d5bdc
# ╟─05f72bc0-6c45-11eb-3602-c955811f9acf
# ╠═70049580-6bea-11eb-390b-d3013dd12235
# ╟─deb2ef40-6bea-11eb-3a13-c9642d262b93
# ╟─08bf49de-6bec-11eb-1b80-5f6e74cbb8d0
# ╟─9d0230c0-6bf8-11eb-2445-777f55b92f4a
# ╠═18893b90-6c5c-11eb-051d-95eef7af0f0f
# ╠═d83840b0-6c54-11eb-31d3-4d1d978c4e4a
# ╠═83cb7cd0-6bf6-11eb-2486-3f0ffc2c8416
# ╟─335a84c0-6bf2-11eb-3249-fbfb0210657c
# ╠═26e7f8d0-6bed-11eb-09d6-a1597aeefc22
# ╠═c4582980-6bef-11eb-18e9-0b1732c8d932
# ╠═dc84d260-6bef-11eb-1e6c-23d28cf6b1d3
# ╠═71561790-6bf1-11eb-1acf-a1a46a8eb3d8
# ╠═054eba90-6bf4-11eb-2214-ede88296a7b8
# ╠═34da1880-6bf5-11eb-3e34-838a118066b4
# ╠═9b0e3050-6bf5-11eb-18df-c9ec17fc42be
