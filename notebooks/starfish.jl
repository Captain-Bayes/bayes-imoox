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

# ╔═╡ a22bf9fc-7b28-11eb-30c1-0fa6d84c74d1

begin
	using Pkg
	Pkg.activate(joinpath(DEPOT_PATH[1], "environments/v1.11"))
	using PlutoUI
	using Plots
	using Plots.PlotMeasures
	using LaTeXStrings
	using Markdown
	using Images
	#using LinearAlgebra
	#using SparseArrays
	#using SpecialFunctions
	#using StatsBase
	#using Random
	#using Distributions
	md""" 
	### Packages
	
	All needed Packages available :) """
	
	# TODO: make it more generally, so one understands how to compare rating
	# maybe make to diagrams next to each other to make them compareable
	
end

# ╔═╡ 9428fba4-67b3-4d2f-a09f-7dc5f28deadd
TableOfContents(aside=true)

# ╔═╡ 5210a326-7b34-11eb-0d14-67f67a882d68
md"""
# The starfish rating problem ⭐⭐⭐⭐⭐
## MaxEnt probabilities, given the true  mean 
 Here we use Maximum entropy to determine the rating probabilities given the normalization constraint and the instrinsic mean $\mu = \langle R \rangle$ with $R$ $\in$ $\{1,2,3,4,5\}$. 
"""

# ╔═╡ 852d6e36-7b31-11eb-0653-61bcf655249d
md"
choose intrinsic mean rating $\mu$  between 1 and 5:    $(@bind μ_r Slider(1.00:0.001:4.999, show_value=true,default=2.0)) 
"

# ╔═╡ 8240f678-7b35-11eb-1a68-bb2b66ce0d04
begin
	# images
	grey_starfish_url = "https://raw.githubusercontent.com/Captain-Bayes/images/main/starfish_grey_five.png"
	red_starfish_url = "https://raw.githubusercontent.com/Captain-Bayes/images/main/starfish_red_five.png"
	grey_starfish_local = download(grey_starfish_url)
	red_starfish_local = download(red_starfish_url)
	grey_starfish = load(grey_starfish_local)
	red_starfish = load(red_starfish_local)
	
	
	ir = Int64(round(μ_r))
	L_stars = ["⭐","⭐⭐","⭐⭐⭐","⭐⭐⭐⭐","⭐⭐⭐⭐⭐","★★★★★"]
md"""	
	$(L_stars[ir])
	"""
	
	[red_starfish[:,1:Int(ceil(μ_r/5*size(red_starfish,2)))] grey_starfish[:,(Int(ceil(μ_r/5*size(red_starfish,2)))):end]]
end

# ╔═╡ 0649912d-5164-4709-ad64-ca79b5256bf3
md"""
## Probability for the true mean, given the sample mean  of $\mathcal{N}$ votes
Here we use Bayesian probability theorem to determine the probability 
$P(\mu \mid \overline{\boldsymbol{R}},\mathcal{N})$ for the intrinsic mean $\mu$ given the average rating $\overline{\boldsymbol{R}}$  based on $\mathcal{N}$ votes.

"""

# ╔═╡ f1646630-8507-4967-beab-a61c2f26bd17
md"""
### Bayesian theory  

Eager to see the theory ? 🤓🧐😋😃👏  _click here_ 👉$(@bind show_Bayes CheckBox())


"""

# ╔═╡ d22311d9-c2c5-4dbd-be38-a377c6b19c37
if show_Bayes
md"""
- we seek: $P(\mu \mid \mathcal{\boldsymbol{R}}, \mathcal{N})$, where $\mathcal{\boldsymbol{R}}$ is the sum of the $ \mathcal{N}$ votes

- Bayes' theorem gives: $P(\mu\mid \mathcal{\boldsymbol{R}}, \mathcal{N}) \propto P(\mathcal{\boldsymbol{R}}\mid \mu , \mathcal{N}) \; P(\mu)$

- We marginalize over the unknown ratings $\boldsymbol{R}_{\nu}$ of the $\mathcal{N}$ voters
$P(\mathcal{\boldsymbol{R}}\mid \mu , \mathcal{N})  = \sum_{\boldsymbol{R}_{1},\ldots \boldsymbol{R}_{\mathcal{N}}=1}^{5}  
P(\mathcal{\boldsymbol{R}}\mid  \boldsymbol{R},\mu , \mathcal{N})\;  \prod_{\nu}  P(R = \boldsymbol{R}_{\nu}\mid \mu)$ 

- the terms $P(R_{i}\mid \mu)$ have been computed in the MaxEnt section

- the remaining probability for the total rating $\boldsymbol{\mathcal{R}}$ given the individual ratings is
$P(\boldsymbol{\mathcal{R}}\mid \boldsymbol{R})
=
\begin{cases}
	1 & \text{if }\sum_{\nu} \boldsymbol{R}_{\nu} = \boldsymbol{\mathcal{R}}\\
	0 & \text{otherwise}
\end{cases}$

- which simply leads to a restricted sum  
$P(\mu\mid \mathcal{\boldsymbol{R}},\mathcal{N}) \propto
\sum^{\sum_{\nu}\boldsymbol{R}_\nu = \boldsymbol{\mathcal{R}}}_{\boldsymbol{R}_{1},\ldots \boldsymbol{R}_{\mathcal{N}}}\;
\prod_{\nu}\frac{e^{\lambda(\mu) \boldsymbol{R}_{\nu}}}{Z(\mu)}
\propto
\sum^{\sum_{\nu}\boldsymbol{R}_\nu = \boldsymbol{\mathcal{R}}}_{\boldsymbol{R}_{1},\ldots \boldsymbol{R}_{\mathcal{N}}}  \;
\; \frac{e^{\lambda(\mu) \sum_{\nu}\boldsymbol{R}_{\nu}}}{(Z(\mu))^{\mathcal{N}}}
\propto
\bigg[\sum^{\sum_{\nu}\boldsymbol{R}_\nu = \boldsymbol{\mathcal{R}}}_{\boldsymbol{R}_{1},\ldots \boldsymbol{R}_{\mathcal{N}}} 1\bigg] \;
\frac{e^{\lambda(\mu) \mathcal{\boldsymbol{R}}}}{(Z(\mu))^{\mathcal{N}}}$

- final result:
$P(\mu\mid \overline{\boldsymbol{R}},\mathcal{N})  =\frac{1}{Z}
\frac{e^{\lambda(\mu) \mathcal{\boldsymbol{R}}}}{(Z(\mu))^{\mathcal{N}}}\;P(\mu)$


"""
end

# ╔═╡ f6a34d0c-2591-45f9-baac-f58fd5eace8b
md"""
### Prior
"""

# ╔═╡ 74a7a904-f043-4a69-93ea-2483d9eb0826
begin
	
	image_claire = "https://raw.githubusercontent.com/Captain-Bayes/images/main/claire_100px.gif"
	tin_pot = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Tin_pot.png"
	iron_pot = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Iron_pot.png"
	brass_pot = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Brass_pot.png"
	copper_pot = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Copper_pot.png"
	
	
	md"""
	The pot ratings of Claire's pottery store
	 were the following:
	
	- Tin pot: ``\overline{\boldsymbol{R}} = 3.9,\, \mathcal{N} = 250``
	- Brass pot: ``\overline{\boldsymbol{R}} = 4.2,\, \mathcal{N} = 80``
	- Iron pot: ``\overline{\boldsymbol{R}} = 5,\, \mathcal{N} = 2``
	- Copper pot: ``\overline{\boldsymbol{R}} = 4.5,\, \mathcal{N} = 15``
	$(Resource(image_claire, :width=> 200))
	$(Resource(tin_pot, :width=> 80)) 
	$(Resource(brass_pot, :width=> 100)) 
	$(Resource(iron_pot, :width=> 130)) 
	$(Resource(copper_pot, :width=> 100))
	"""
end

# ╔═╡ 44ea4b68-20d0-4f67-95d6-4228c9174c2b
md"""
## Some nice large plots
"""

# ╔═╡ 8102cbf7-e2ad-4492-9756-278fb8d072e7
begin
	Q = [0.000001;0.01:0.01:1]
	ll = -Q.*log.(Q)
	
	plot(Q, ll, 
	size = (600,400),
	xlabel = latexstring("Q_i"),
	ylabel = latexstring("S(Q_i)"),
	labelfontsize = 20,
	tickfontsize = 15,
	bottom_margin =5mm,
	left_margin = 5mm,
	linewidth = 3,
	label = :none,
		title= "Entropy",
	titlefontsize = 20,	
	#foreground_color_grid = :black,
	#foreground_color_xticks = :black,
	background_color = :transparent,
	#foreground_color_axis = :black,
	#foreground_color_text = :black,
	#foreground_color_border = :black,
	foreground_color = :black,
	fontfamily="Computer Modern"
	)
	
	#	savefig("C://Lehre//Bayes MOOC//Lesson 6//Images//entropy")
	
	
end

# ╔═╡ 9345ab4c-69f9-47b2-a1a4-388adeb4f74c
begin
	Rat = 1:5
	lam = -5:0.01:5
	
	normierung = sum(exp.(lam'.*Rat),dims=1)
	mean_value = sum(Rat.*exp.(lam'.*Rat)./normierung, dims = 1)
	
	plot(lam, mean_value', 
	size = (600,400),
	xlabel = latexstring("\\lambda"),
	ylabel = latexstring("\\mu(\\lambda)"),
	labelfontsize = 20,
	tickfontsize = 15,
	bottom_margin =5mm,
	left_margin = 5mm,
	linewidth = 3,
	label = :none,
	titlefontsize = 20,	
		title = "Lagrange paramter and mean value",
	#foreground_color_grid = :black,
	#foreground_color_xticks = :black,
	background_color = :transparent,
	#foreground_color_axis = :black,
	#foreground_color_text = :black,
	#foreground_color_border = :black,
	foreground_color = :black,
	fontfamily="Computer Modern"
	)
	
	#	savefig("C://Lehre//Bayes MOOC//Lesson 6//Images//lagrange")
	
	
end

# ╔═╡ ded10d5c-4001-4335-9612-2c7ac99104e7
md"""
# About the creators

This notebook was created by **[Gerhard Dorn](https://github.com/dorn-gerhard)** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes22&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ 033db041-4b66-4a4f-a063-1b7d310c232c
md"""
## Program code
"""

# ╔═╡ 248a131d-49c7-45cd-8e30-527386e317f5
begin
	L_r = [1:5;]
	
	function Newton(L_r,μ_r; max_iter = 10000, ε = 1.e-8)
		#=
			for given true mean μ_r compute 
			Z(μ_r) und λ(μ_r) of Maxent solution for
			probability q_r = P(r| μ_r)   = exp(λ r)/Z
		=#

		λ = 0.0
		Z = 0.0
		q_r = zeros(size(L_r))
		for i_step = 1: max_iter
			𝜌_r = exp.(λ .* L_r)
			Z   = sum(𝜌_r)
			q_r = 𝜌_r ./ Z
			avg_r = sum(L_r .* q_r)
			var_r = sum(L_r.^2 .* q_r) - avg_r^2
			𝛷 = avg_r - μ_r
			𝛥𝜆 = 𝛷 / var_r
			λ  = λ - 𝛥𝜆 
			if abs(𝛥𝜆) < ε
				break
			end
		end

		return Z,λ,q_r
	end
	md" ### Newton Raphson"
end

# ╔═╡ b033b45c-7b28-11eb-1216-5703dc0e7792
begin	
	aux1,𝜆_ME,q_r = Newton(L_r,μ_r; max_iter = 10000, ε = 1.e-3)

	txt2 = latexstring("\\mathrm{MaxEnt\\, probability\\,  for\\, given \\, true\\, mean\\, \\mu }")
	col_pal = palette(:default) # color palette
	
	plot(L_r,q_r,
		line= (0.0 , 2.0 , :bar),
		bar_width = 0.05,
		title = txt2,
		ylim = (0.0, 1.1),
		xlabel = latexstring("R"),
		ylabel = latexstring("P\\,(R\\,|\\mu)"),		
		label = false
	)
	plot!(L_r,q_r,size=[500,300],
		line = ( 1, 0., :path),
		marker = (5, 1., :o),
		markerstrokewidth = 1.,
    	color = col_pal[1],
		label = false
	)

end


# ╔═╡ a0e51c0c-7b2f-11eb-2c1c-a77cfaf645f7
md"
 **The corresponding Lagrange parameter is**: $\lambda$ = $(round(𝜆_ME,digits=4))
"

# ╔═╡ 3bcf9ac2-213d-44fe-b8b5-8b54695c3029
begin
	N_iter_max = 10000
	eps_lagr = 1.e-8
	μ_Delta = 0.01
	L_μ = [1.01:μ_Delta:4.99;]
	L_𝜆 = zeros(length(L_μ))
	L_Z = zeros(length(L_μ))

	for (i,μ_r) in enumerate(L_μ)
		Z,λ,aux2  = Newton(L_r,μ_r; max_iter = 10000, ε = 1.e-8)
		L_𝜆[i]   = λ
		L_Z[i]   = Z	
	end
	
	md"""
	 ### determine auxiliary Maxent functions 
	 $\lambda(\mu)$  and $Z(\mu)$
	"""
end


# ╔═╡ 4c48af3c-dac8-43d4-9a57-7fed5052300a
begin
	slider_α = @bind 	α 	Scrubbable(0:.1:5, default=2.0)
	slider_β = @bind 	β   Scrubbable(0:.1:5, default=3.0)
	md"### sliders "
end

# ╔═╡ cdf3d720-bc21-44f5-976e-87fb5d8ed64b
md"""
  We still need to choose the prior probability $P(\mu)$ that encode our prior knowledge/ expectation about the true rating-mean $\mu$

We seek a function of $\mu \in [1,5]$, that (depending on some paramerters) is flexble enough to cover all conceivable shapes a prior probability  distribution my have.


Such a function is given by an adjusted Beta distribution

$P(\mu) \propto (\mu-1)^{\alpha-1}  (5-\mu)^{\beta-1}$ 

which depends only on two parameters.

---------------
_Choose the paramters_ $\alpha$ and $\beta$ and try to match your prior expectations

🔊 **to change the values, click and pull the numbers**

α:    $slider_α     
β:    $slider_β
"""

# ╔═╡ 53365c4a-b00a-4bdf-8314-9ab9dbd19db6
begin
	Prior = (L_μ .- 1).^(α-1)  .* (5 .- L_μ).^(β-1)
	Prior = Prior ./ (sum(Prior)*(L_μ[2]-L_μ[1]))
	
	plot1 = plot(L_μ,Prior,
	xlim = (1,5), ylim = (0, 1),
	label = false,
	xlabel = latexstring("\\mu"),
	ylabel = latexstring("P\\,(\\mu)"),		
	title = "Prior probabilities"
	)
	plot!(size=(400,200))
end

# ╔═╡ 4b6c15b2-7ac8-42cf-8c6b-070ae19405bd
md"""
### Posterior
_now you can study how the posterior probability_ $P(\mu\;| \overline{\boldsymbol{R}}, \mathcal{N} )$
depends on the sample rating-mean $\overline{\boldsymbol{R}}$, the sample size (# of votes) $\mathcal{N}$
and your prior choice
(_remember_  $\boldsymbol{\mathcal{R}} = \mathcal{N}\overline{\boldsymbol{R}}$)

-------------


rating $\overline{\boldsymbol{R}}$:    $(@bind 	mean_r Scrubbable(1.0:0.05:5, default=4.5)) 


number of votes $\mathcal{N}$: $(@bind 	N Slider(1:250, show_value=true,default=80)) 


Parameters for prior probability (flat prior: ``\alpha = \beta = 1``):

 ``\alpha``:    $slider_α     
 ``\beta``:    $slider_β     
      (_to change the values, click and pull the numbers_) 
"""

# ╔═╡ 1b9848f0-7a4a-4916-b7df-ffcd61c39415
begin
	# compute posterior 
	R       = N * mean_r
	L_ln_P 	= R * L_𝜆 .- N * log.(L_Z) .- log.(Prior)
	L_ln_P  = L_ln_P .- maximum(L_ln_P)
	L_P     = exp.(L_ln_P)
	L_P     = L_P/(sum(L_P)*μ_Delta)
    md"### compute posterior "
end

# ╔═╡ 7cde88e1-a4c0-4541-aa8d-61845b479192
begin
    # plot posterior	
	txt    = "Posterior probability "
	plot2  = plot(L_μ,L_P,
	label  = false,
	xlabel = latexstring("\\mu"),
	ylabel = latexstring("P\\, (\\mu |  \\textbf{R}, \\mathcal{N})"),
	title  = txt,
	ylim   = (0, 6)
	)
	plot(plot1,plot2,layout = (1, 2))
		plot!(size=[600,300])
end

# ╔═╡ 9096d5fe-ee6b-4842-ac4b-0fd8a421db32
begin
	mean_rating = sum(L_μ.*L_P)
	stdeviation = sqrt(sum((L_μ .-mean_rating).^2 .*L_P))
	string(round(mean_rating, digits=3))*"±"*string(round(stdeviation,digits=2))
	md"### mean rating"
end

# ╔═╡ eb0a9de2-48b4-4220-abfc-433ce87c879c
function sr(variable, dig = 2)
	# string and round - converts a variable into a string with the predifined precission - to be extended to scientific and other formats
	if dig == 0
		return string(round(Int, variable))
	else
		return string(round(variable, digits = dig))
	end
end

# ╔═╡ 43389709-7d95-4d06-a284-a532b3d23dee
begin
	
	#plotting for video
	title_mu_plots = latexstring("\\overline{\\boldsymbol{R}} = " * string(round(mean_r,digits=2)) * ",\\, \\mathcal{N} = "*string(round(Int,N)))
	
	plot(plot2,size=(600,400), 
	xlabel = latexstring("\\mu_{\\textrm{copper}}"),
	labelfontsize = 20,
	tickfontsize = 15,
	bottom_margin =5mm,
	left_margin = 5mm,
		linewidth = 3,
	#title = title_mu_plots,
	titlefontsize = 20,
	background_color = :transparent,
	fontfamily="Computer Modern",
		ylim = [0,2],
		label=latexstring("\\overline{\\mathbf{R}} = "* sr(mean_r,2) * ", \\mathcal{N} = "* sr(N,0) ),
		legendfontsize = 15,
		leg = :topleft,

		
		
	)
	#savefig("C://Lehre//Bayes MOOC//Lesson 6//Images//posterior_copper")
	
	# copper: 
	
end

# ╔═╡ f1586893-5fe6-4202-801b-80fda48511bc
begin
bind_prior = @bind rr Slider(1.00:0.001:4.999, default=2.0)
	nothing
end

# ╔═╡ e821ecaa-e974-407d-84b1-61479965c796
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
# ╟─9428fba4-67b3-4d2f-a09f-7dc5f28deadd
# ╟─5210a326-7b34-11eb-0d14-67f67a882d68
# ╟─8240f678-7b35-11eb-1a68-bb2b66ce0d04
# ╟─852d6e36-7b31-11eb-0653-61bcf655249d
# ╟─b033b45c-7b28-11eb-1216-5703dc0e7792
# ╟─a0e51c0c-7b2f-11eb-2c1c-a77cfaf645f7
# ╟─0649912d-5164-4709-ad64-ca79b5256bf3
# ╟─f1646630-8507-4967-beab-a61c2f26bd17
# ╟─d22311d9-c2c5-4dbd-be38-a377c6b19c37
# ╟─f6a34d0c-2591-45f9-baac-f58fd5eace8b
# ╟─cdf3d720-bc21-44f5-976e-87fb5d8ed64b
# ╟─53365c4a-b00a-4bdf-8314-9ab9dbd19db6
# ╟─4b6c15b2-7ac8-42cf-8c6b-070ae19405bd
# ╟─7cde88e1-a4c0-4541-aa8d-61845b479192
# ╟─74a7a904-f043-4a69-93ea-2483d9eb0826
# ╟─44ea4b68-20d0-4f67-95d6-4228c9174c2b
# ╟─43389709-7d95-4d06-a284-a532b3d23dee
# ╟─8102cbf7-e2ad-4492-9756-278fb8d072e7
# ╟─9345ab4c-69f9-47b2-a1a4-388adeb4f74c
# ╟─ded10d5c-4001-4335-9612-2c7ac99104e7
# ╟─033db041-4b66-4a4f-a063-1b7d310c232c
# ╟─3bcf9ac2-213d-44fe-b8b5-8b54695c3029
# ╟─1b9848f0-7a4a-4916-b7df-ffcd61c39415
# ╟─9096d5fe-ee6b-4842-ac4b-0fd8a421db32
# ╟─248a131d-49c7-45cd-8e30-527386e317f5
# ╟─a22bf9fc-7b28-11eb-30c1-0fa6d84c74d1
# ╟─4c48af3c-dac8-43d4-9a57-7fed5052300a
# ╟─eb0a9de2-48b4-4220-abfc-433ce87c879c
# ╟─f1586893-5fe6-4202-801b-80fda48511bc
# ╟─e821ecaa-e974-407d-84b1-61479965c796
