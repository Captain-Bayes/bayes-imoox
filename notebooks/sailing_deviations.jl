### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ a38a9620-6bea-11eb-2293-c5469f2d5bdc
begin
	#try
		using PlutoUI
		using Plots
		using LinearAlgebra
		using SparseArrays
		using DataFrames
		using Random
		md""" 
		#### Packages
		
		All needed Packages available :) """
	#=
	catch
		using Pkg;
		Pkg.activate(mktempdir())
		Pkg.add("PlutoUI")
		Pkg.add("Plots")
		Pkg.add("Random")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		#Pkg.add("DataFrames")
		
		using PlutoUI
		using Plots
		using LinearAlgebra
		using SparseArrays
		using DataFrames
		using Random
		md""" 
		#### Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	=#
end

# ╔═╡ 5f9b8270-79c4-11eb-0780-03bde90c8d2b
md"""
# Sailing deviations ⛵️

## Explanation:

- We consider the motion of the ship in discrete time steps

- Initially you fix some parameters:

   1) direction of the random ocean current (N,E,S,W)  [fixed thoughout the sailing trip]

   2) probability $P_{oc}$ that the ocean current is present in one time step

   3) probability $P_{Pascal}$ that Pascal makes an error in one time step


- at each time step the following **random variables** are defined:

   	a) $X$ for the **sailing directions** (*North*, *East*, *South* and *West*). We use the assignment (1,2,3,4)

    b) $Y$ for the **sailing deviations** , with the following assignments:

   * *port deviation* $\,\,\rightarrow -1$, 

   * *no deviation*   $\,\,\,\,\rightarrow 0$,

   * *starboard deviation* $\rightarrow +1$
    
   the probability for one of the two deviations is $P_{Pascal}/2$, for no deviation it is $1-P_{Pascal}$

  c) with probability $P_{oc}$ the occean current leads to a sailing deviation $\pm 1$ if the ocean current acts perpendicular to the actual sailing direction. The sign is chose according to the direction where the ocean current comes from.



 



"""

# ╔═╡ 7dafedbe-7aa3-11eb-2054-79fd4db63d4b
md"""
## Experimental setup
"""

# ╔═╡ c1d63b90-86b4-11eb-209d-8985ce0e2f82
md" Choose a random **seed** 👉 $(@bind seed Slider(1:1:200, default=1, show_value = true)) "


# ╔═╡ 05f72bc0-6c45-11eb-3602-c955811f9acf

md" Choose the **number of data points** Pascal is using in her statistics 👉 $(@bind n_data_points Slider(500:100:2000, default=1000, show_value = true)) "


# ╔═╡ 70049580-6bea-11eb-390b-d3013dd12235
md"Choose **probability** of the **ocean current** to lead to a deviation 👉 $(@bind ocean_current_prob Slider(0:0.05:0.3, default = 0.15, show_value = true)) "

# ╔═╡ deb2ef40-6bea-11eb-3a13-c9642d262b93
md"Choose **probability** of **Pascal to fail on keeping the course** 👉 $(@bind pascal_fail_prob Slider(0:0.05:0.3, default = 0.1, show_value = true)) "

# ╔═╡ 08bf49de-6bec-11eb-1b80-5f6e74cbb8d0
md"""
Choose **direction of ocean current** $(@bind direction_of_current Select([ "north" => "North ⬆️", "east" => "East ➡️", "south" => "South ⬇️", "west" => "West ⬅️"]))
"""

# ╔═╡ 6345d02e-7a69-11eb-0e07-a519c0d7b2d0
md"""
#### frequencies of pairs of random sailing direction and random sailing deviations 
"""

# ╔═╡ 0a2a4d9c-7a89-11eb-23ce-dfd7d38b0ab8
md"""
## Various computational steps
"""

# ╔═╡ da7a4c84-7a77-11eb-3e98-ff115e06df23

begin 
function myDataFrame(table_in)
		if typeof(table_in[1]) == Int64
			table = table_in
		else
			table = round.(table_in,digits=3)
		end
Markdown.parse("""
| direction    |  deviation starboard    | no deviation  |deviation port|
| :------------|:-------------| :-----| :--|
| North:      | $(table[1,1]) |  $(table[1,2])  | $(table[1,3]) |
| East:      | $(table[2,1])      |   $(table[2,2]) | $(table[2,3]) |
| South: | $(table[3,1])      |   $(table[3,2]) | $(table[3,3]) |
| West: | $(table[4,1])      |    $(table[4,2]) | $(table[4,3]) |
""")
		
end
	md"#### function defintion"
end

# ╔═╡ 0a0abad2-86b5-11eb-1d3f-4d7e79c32419
begin
	rng = MersenneTwister(seed); 
	direction = rand(rng, 1:4, n_data_points)  
	rr = rand(rng,n_data_points)
	ss = rand(rng,n_data_points)
	md"#### Random number generator, determine random sailing directions and deviations"
end

# ╔═╡ c4582980-6bef-11eb-18e9-0b1732c8d932
begin
	md"#### determine random sailing directions"
end

# ╔═╡ dc84d260-6bef-11eb-1e6c-23d28cf6b1d3
begin
	sail_deviation = zeros(1,n_data_points)
	sail_deviation = (-(rr .<= pascal_fail_prob/2)) + (rr.>= 1-pascal_fail_prob/2)
	# r<= p/2   => -1
	# r>= 1-p/2 => +1
	# p/2 <= r <= 1-p/2   => 0
	md"#### determine deviations due to Pascal's random errors"
end

# ╔═╡ 71561790-6bf1-11eb-1acf-a1a46a8eb3d8
begin 
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
	# with prob. ocean_current_prob a random deviation +/- 1 is created
	# the sign depends on the direction of the current selected once and for all 
	md"#### determine deviation due to random ocean currents"
end

# ╔═╡ 054eba90-6bf4-11eb-2214-ede88296a7b8
begin
	deviation = sail_deviation .+ added_deviation
	md"#### compute total deviation"
end

# ╔═╡ 4249bb68-7a66-11eb-1b12-e31916ad1504
begin
	table = [[sum(deviation[ direction .==i] .<= -1) for i=1:4] [sum(deviation[ 	direction .==i] .== 0) for i=1:4] [sum(deviation[ direction .==i] .>= 1) for i=1:4]]
	# Example from the episode:
	#table = [17 255 11; 62 178 10; 11 219 12; 11 169 45]
	md"#### compute joint frequencies for random sailing direction and sailing deviations"
end

# ╔═╡ 2a1a57c0-7ab9-11eb-0e60-115736d61684
begin
#df = DataFrame([["North: "; "East:  "; "South: "; "West:"] table], [:direction, :deviation_starboard, :no_deviation, :deviation_port])
df = DataFrame("Direction" => ["North: "; "East:  "; "South: "; "West:"], "Deviation starboard" => table[:,1], "no deviation" => table[:,2], "deviation port" => table[:,3])

myDataFrame(table)
#$(df)
end

# ╔═╡ f6ed4510-79d2-11eb-16b9-87007281ed31
begin
	
#df = DataFrame([["North: "; "East:  "; "South: "; "West:"] table], [:direction, :deviation_starboard, :no_deviation, :deviation_port])
df2 = DataFrame("Direction" => ["North: "; "East:  "; "South: "; "West:"], "Deviation starboard" => table[:,1]./n_data_points, "no deviation" => table[:,2]./n_data_points, "deviation port" => table[:,3]./n_data_points)
	
md"""
#### estimated joint probabilities for random sailing direction and random sailing deviations
	
$(df2)
"""
end

# ╔═╡ 628591be-79be-11eb-278e-954c42f8a638
begin
	joint_prob = table./n_data_points
	#marginal probabilities
	marg_prob_dir = sum(joint_prob, dims=2)
	marg_prob_dev = sum(joint_prob, dims=1)
	#random variables
	X_dir = [0,pi/2,pi,3*pi/2] #[1,2,3,4]#
	X_dev = [-1,0,1]
	#mean values
	Av_dir = sum(X_dir.*marg_prob_dir)
	Av_dev = sum(X_dev.*marg_prob_dev')    # wvl:  transpose  
	#grid with local deviations (X-<X>)
	dir = (X_dir.-Av_dir).* ones(3)' 
	dev = ones(4) .* (X_dev .- Av_dev)'
	#mean value of weighted product of local deviations: P(X,Y) * (X-<X>) * (Y-<Y>)
	covariance = n_data_points/(n_data_points-1)*[ sum(dir.*dir.*joint_prob) sum(dir.*dev.*joint_prob); sum(dir.*dev.*joint_prob) sum(dev.*dev.*joint_prob)]
	cov12 =round(covariance[1,2],digits=4)
	md"#### compute covariance" 
end

# ╔═╡ b859d540-7cd7-11eb-29b5-95d538b7dc0a

md"""

#### Estimated covariance between sailing direction and sailing deviation $C(\textrm{dir},\textrm{dev}) \approx$ **$(cov12)**
"""

# ╔═╡ 1ae179d4-7a6a-11eb-317b-09994dba67d1

md"""

#### Estimated covariance between sailing direction and sailing deviation $C(\textrm{dir},\textrm{dev}) \approx$ **$(cov12)**

---

## Explanation:
Given the table above we want to investigate whether this data set allows to make statements about dependent variables.


$\textrm{CoV}(X,Y) = \sum_{ij} P(X_i,Y_j) \cdot (X_i - \langle X \rangle) \cdot (Y_j - \langle Y \rangle)$ 

with $\langle X \rangle $ resp. $\langle Y \rangle$ the mean value of the marginal probability distribution $P(X)$ resp. $P(Y)$.

Since the intrinsic probabilites and intrinsic marginal mean values are not given, we use the sample mean values and relative frequencies to estimate them.

In order to estimate the covariance of sailing deviations and sailing directions by  using Pascal's recorded sample we proceed in the following way:

- Use the relative frequencies $\boldsymbol{N}(X_i, Y_j)/N$ to estimate the probabilities $P(X_i,Y_j)$ in the table 
- Use this estimated joint probability distribution to calculate the covariance using the formula above.
- Since the used marginal mean values are sample mean values $\overline{\boldsymbol{X}}$ and $\overline{\boldsymbol{Y}}$ obtained from the same sample set we get a bias. To correct for this bias we have to multiply by $\frac{N}{N-1}$.

$\textrm{CoV}(X, Y) \approx \frac{N}{N-1}\sum_{ij} \frac{\boldsymbol{N}_{ij}}{N} \cdot (X_i -  \overline{\boldsymbol{X}}) \cdot (Y_j - \overline{\boldsymbol{Y}} ))$ 



"""

# ╔═╡ Cell order:
# ╟─5f9b8270-79c4-11eb-0780-03bde90c8d2b
# ╟─7dafedbe-7aa3-11eb-2054-79fd4db63d4b
# ╟─c1d63b90-86b4-11eb-209d-8985ce0e2f82
# ╟─05f72bc0-6c45-11eb-3602-c955811f9acf
# ╟─70049580-6bea-11eb-390b-d3013dd12235
# ╟─deb2ef40-6bea-11eb-3a13-c9642d262b93
# ╟─08bf49de-6bec-11eb-1b80-5f6e74cbb8d0
# ╟─6345d02e-7a69-11eb-0e07-a519c0d7b2d0
# ╟─2a1a57c0-7ab9-11eb-0e60-115736d61684
# ╟─b859d540-7cd7-11eb-29b5-95d538b7dc0a
# ╟─f6ed4510-79d2-11eb-16b9-87007281ed31
# ╟─1ae179d4-7a6a-11eb-317b-09994dba67d1
# ╟─0a2a4d9c-7a89-11eb-23ce-dfd7d38b0ab8
# ╠═a38a9620-6bea-11eb-2293-c5469f2d5bdc
# ╟─da7a4c84-7a77-11eb-3e98-ff115e06df23
# ╟─0a0abad2-86b5-11eb-1d3f-4d7e79c32419
# ╟─c4582980-6bef-11eb-18e9-0b1732c8d932
# ╟─dc84d260-6bef-11eb-1e6c-23d28cf6b1d3
# ╟─71561790-6bf1-11eb-1acf-a1a46a8eb3d8
# ╟─054eba90-6bf4-11eb-2214-ede88296a7b8
# ╟─4249bb68-7a66-11eb-1b12-e31916ad1504
# ╟─628591be-79be-11eb-278e-954c42f8a638
