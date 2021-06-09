### A Pluto.jl notebook ###
# v0.14.7

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
	try
		using PlutoUI
		using Plots
		using LinearAlgebra
		using SparseArrays
		using SpecialFunctions
		using StatsBase

		using Random
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
		Pkg.add("StatsBase")
		using PlutoUI
		using Plots
		using LinearAlgebra
		using SparseArrays
		using SpecialFunctions
		using StatsBase

		using Random
		md""" 
		# Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	# TODO: add a GIF of the golden Nautilus wheel spinning and maybe a link to the derivation of the proabilities and to the video
end

# ╔═╡ 9637fe40-6c44-11eb-1df3-eb0b0d36db34
md"""

# **The golden Nautilus wheel** - _Distributions and the law of large numbers_

As you can watch in video below 👇, Captain Venn wants to find out the chances for the four tasks of the day. Help him with doing the experiments, press **_START_** and count the results in the **histogram** below. The red bullets 📍 indicate the intrinsic probabilities times the number of experiments $P_i \cdot \mathcal{N}$.



"""

# ╔═╡ f3f80e2e-51d2-4fce-b7df-b2cdd3a0cad5
html"""<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/3-xG3sRCTtY" width=600 height=375  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>"""

# ╔═╡ e03eeec0-8299-11eb-119b-5dfd576a2811
md"""
Choose the **random seed** $\,\,$ 👉 $(@bind seed Slider(1:100, default=1, show_value = true)) 
"""

# ╔═╡ 8d180f60-829e-11eb-36a3-6fb2eab9c846
md"""
Start the **measurements** (don't forget to stop the clock at some point!):  $(@bind n_sample_size Clock(0.2,true,false)) 
"""

#md"""
#Change the number of measurements 👉 $\mathcal{N} =$ $(@bind n_sample_size #Scrubbable(1:1:200, default=10))  (*drag the red number with the mouse* 🖱)
#"""

# ╔═╡ 32d0d060-82b1-11eb-37a0-4bcd4881e6e1
md"""
##### Wages 
Captain Venn trusts you a lot, you can even **change the wages** Captain Venn pays for the four tasks (just drag the numbers with the mouse).

_sailing_ ⛵ $(@bind sailing Scrubbable(6)) pennies, 

_fishing_ 🐬$(@bind fishing Scrubbable(4)) pennies, 

_shrubbing the deck_ 🧹 $(@bind shrubbing Scrubbable(3)) pennies, 

_free day_ 🏝️ $(@bind free_day Scrubbable(1)) penny.
"""

# ╔═╡ b7a7b220-6c56-11eb-1e6c-6f7595f02439
md"""
In order to see the variation of the sample mean we **repeat the measurements with fixed sample size** ($\mathcal{N}$) $n$ times. This way we can **sample the distribution of the sample mean value** (which is a random variable in contrast to the intrinsic mean $\langle X \rangle$ = 0.1056. Use the slider to change the number of repeated measurements $N$ of samples of size $n$.

"""

# ╔═╡ 8b8cd540-6d86-11eb-339e-7b8a2df774f9
md"""
Choose the **number of repetitions** 👉 n =   $(@bind rep Scrubbable(100:100:2000)) of sampling samples with **sample size**
👉 N = $(@bind n_sam_size Scrubbable(500:1000:12000))
"""

# ╔═╡ b1515d9a-8039-4410-bbd2-54890804fda8
md"""
Learn more about the law of large numbers and how to evaluate the standard error in the lesson below 👇 or in the [`IMOOX course`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes&lang=en) equipped with many quizzes."""

# ╔═╡ 936054d5-2863-4f69-9a12-c865d6dd37b0
html"""<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/zcqUKJ6GGHo" width=600 height=375  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>"""

# ╔═╡ 3cc85769-13d1-44d9-acd8-20353c848829
md"""
## About the creators

This notebook was created by **Gerhard Dorn** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ a2541e60-8356-11eb-1b16-6fb19948ed1c
md"""
# Some code below
In order to have a look at the code download the notebook or load it on binder (takes 6-10 minutes)

To do so, **press the binder button** in the right top corner ↗
"""

# ╔═╡ 48f7c480-6d84-11eb-1f24-e16d7f649c9c
begin
	phi = (1+sqrt(5))/2 #golden ratio
	prob = phi.^(0:3)./sum(phi.^(0:3)) # intrinsic probabilities of the four sectors
	prob_string = [string(round(prob[i]*100, digits=1)) * "%, " for i in 1:4]
md"""
##### Calculating the intrinsic probabilities of the golden Nautilus wheel
	
 $P$ :   [$(prob_string[:]) ]

	"""
end


# ╔═╡ 70209d20-8350-11eb-2da3-9f99a25eb4f9
begin
	rng = MersenneTwister(20)
	
	
	local sample_temp = 5 .- sum(rand(rng, 1,rep*n_sam_size) .<= cumsum(prob), dims=1)
	local sample_array = reshape(sample_temp, (n_sam_size,:))
	X = sum(sample_array .== 1,dims=1)/n_sam_size
	
	md"""
	##### sampling the sample means
	"""
end
	

# ╔═╡ 5523cb40-82b6-11eb-3e29-81d50ff29db6
begin	

	
	histogram(X[:], nbins=20,
	xlim=[0.06, 0.15], label=:none, xlabel="Sample mean", ylabel="Frequency"
	)
	
	plot!([0.1, 0.1], [0, rep/6], line=(3.2, 1.0, :line), linestyle=:dash, color = :red, label="10% limit")
	plot!([0.1056, 0.1056], [0, rep/6], line=(3.2, 1.0, :line), linestyle=:dash, color = :green, label="intrinsic mean")
end

# ╔═╡ 86962d00-8449-11eb-31f9-dfb502c7e132
md"""
Captain Venn's statement of having at least 10% free days is **wrong** in **$(round(100*sum(X.<0.1)/length(X), digits=1)) %** of all $(n_sam_size) day-long sailing turns *(a contract for $(round(n_sam_size/365, digits=1)) years)*"""

# ╔═╡ 8cc9f417-ad45-48d2-8960-6a8d465cb9a5
begin
	
		bayes = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bayes_50px.gif"
	bernoulli = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bernoulli_50px.gif"
	
	venn = "https://raw.githubusercontent.com/Captain-Bayes/images/main/venn_50px1.gif"
	
	md"""Images"""
end

# ╔═╡ 67f01600-82ae-11eb-2c1a-c906e8a6a892
begin
md"""
$(Resource(bayes, :width=>180)) 
$(Resource(venn, :width=>180))
	
**Captain Bayes and Captain Venn** are investigating the **golden Nautilus wheel** and are wondering how one can make reliable predictions about the minimum free days ratio.

A **rough rule of thumb** says that for most distributions the standard deviation can be used as a measure of how much probability mass is **spread around the mean value**, namely that within the following intervals one can find:

``P(X \in [μ - σ, μ + σ])  ≈ 67\%,`` 
	
``P(X ∈ [μ - 2σ, μ + 2σ]) ≈ 95\%,``
	
``P(X ∈ [μ - 3σ, μ + 3σ]) ≈ 99\%.``

We examine the standard error which is the standard deviation of the sample mean 	(since we want to find an estimate for the sample mean ``\overline{\boldsymbol{X}}``).
	


"""

	
end

# ╔═╡ 59607242-82b0-11eb-35cf-cb7b33cddf21
x_rand_var = [free_day, shrubbing, fishing, sailing]

# ╔═╡ d6519370-825a-11eb-1ae5-ed41bc0c343f
begin 
	function take_sample(N_sample_size, seed)
	rng = MersenneTwister(seed)
	sample = 5 .- sum(rand(rng, 1,N_sample_size) .<= cumsum(prob), dims=1)
	return sample
	end
	
	md"""
	##### Function for taking a sample of size N using a seed
	"""
end

# ╔═╡ 5e0bfb10-6d8a-11eb-06ef-9335eb90064c
begin	
	n_size = minimum([n_sample_size, 200])
	sample_1 = take_sample(n_size, seed)
	sample_count = [count(==(i), sample_1) for i = 1:4]
	
	plot(x_rand_var, sample_count,
    line = (1.0 , 2.0 , :bar),
    normalize = false,
	bar_width = 0.6,
    marker = (6, 0.5, :none),
    markerstrokewidth = 5.,
    color = [:steelblue],
    fill = 0.9,
    orientation = :v,
    title = "Histogram with total sample size: " * string(n_size),
	ylabel = "frequency N",
	xlabel = "Pennies (random variable X)",
	label = :none,
	ylim =[0,maximum([20,n_size/2])])
	
	
	
	plot!(
    x_rand_var,prob.*n_size, 
    line = ( 1, 0., :path),
    normalize = false,
    marker = (5, 1.0, :o),
    markerstrokewidth = 3.,
    color = [:red],
    fill = 0.,
    orientation = :v,
	label = "expected value",
	legend = :topleft
	)
end

# ╔═╡ 4171c850-82a6-11eb-1031-73a99aff7207
begin
	
	free_days = [(i>1) ? md"🔴" : md"🟢" for i in sample_1]
	free_days_table = reshape([free_days [md"" for i in 1:1, j in (1:(7-Integer(length(free_days)- floor(length(free_days)/7)*7)))]], (7,:))
	fd_table = permutedims(free_days_table, [2,1])
md"""
#### Working days:
 $(Resource(bernoulli, :width=>180))
	
	Bernoulli made a calender 📅 of all working 🔴 and free 🟢 days: 
	

	"""

end

# ╔═╡ 3f47bb1e-8350-11eb-2cca-cb42ea1105d2
	fd_table

# ╔═╡ 26395db0-82b4-11eb-3c44-d18d737d9e53
md"""
The estimated free days ratio from the data is: $(round(100*sum(sample_1 .==1)/length(sample_1))) %
"""

# ╔═╡ 2293a98e-d6a8-443a-9f84-47b632a199f4
TableOfContents()

# ╔═╡ Cell order:
# ╟─9637fe40-6c44-11eb-1df3-eb0b0d36db34
# ╟─f3f80e2e-51d2-4fce-b7df-b2cdd3a0cad5
# ╟─e03eeec0-8299-11eb-119b-5dfd576a2811
# ╟─8d180f60-829e-11eb-36a3-6fb2eab9c846
# ╟─5e0bfb10-6d8a-11eb-06ef-9335eb90064c
# ╟─32d0d060-82b1-11eb-37a0-4bcd4881e6e1
# ╟─4171c850-82a6-11eb-1031-73a99aff7207
# ╟─3f47bb1e-8350-11eb-2cca-cb42ea1105d2
# ╟─26395db0-82b4-11eb-3c44-d18d737d9e53
# ╟─67f01600-82ae-11eb-2c1a-c906e8a6a892
# ╟─b7a7b220-6c56-11eb-1e6c-6f7595f02439
# ╟─8b8cd540-6d86-11eb-339e-7b8a2df774f9
# ╟─5523cb40-82b6-11eb-3e29-81d50ff29db6
# ╟─86962d00-8449-11eb-31f9-dfb502c7e132
# ╟─b1515d9a-8039-4410-bbd2-54890804fda8
# ╟─936054d5-2863-4f69-9a12-c865d6dd37b0
# ╟─8d4298e0-6c44-11eb-3406-31a39340d1aa
# ╟─3cc85769-13d1-44d9-acd8-20353c848829
# ╟─a2541e60-8356-11eb-1b16-6fb19948ed1c
# ╟─70209d20-8350-11eb-2da3-9f99a25eb4f9
# ╟─48f7c480-6d84-11eb-1f24-e16d7f649c9c
# ╟─8cc9f417-ad45-48d2-8960-6a8d465cb9a5
# ╟─59607242-82b0-11eb-35cf-cb7b33cddf21
# ╟─d6519370-825a-11eb-1ae5-ed41bc0c343f
# ╟─2293a98e-d6a8-443a-9f84-47b632a199f4
