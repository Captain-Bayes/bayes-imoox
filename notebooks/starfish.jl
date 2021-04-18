### A Pluto.jl notebook ###
# v0.14.2

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

# ╔═╡ a22bf9fc-7b28-11eb-30c1-0fa6d84c74d1

begin
	try
		using PlutoUI
		using Plots
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
	catch
		using Pkg;
		Pkg.activate(mktempdir())
		Pkg.add("PlutoUI")
		Pkg.add("Plots")
		Pkg.add("LaTeXStrings")
		Pkg.add("Markdown")
		Pkg.add("Images")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		#Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		#Pkg.add("Distributions")
		using PlutoUI, Plots, LaTeXStrings, Markdown, Images
		#using LinearAlgebra
		#using SparseArrays
		#using StatsBase
		#using Random
		md""" 
		### Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
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
	md" ### Newton Ralphson"
end

# ╔═╡ b033b45c-7b28-11eb-1216-5703dc0e7792
begin	
	aux1,𝜆_ME,q_r = Newton(L_r,μ_r; max_iter = 10000, ε = 1.e-3)

	txt2 = latexstring("\\mathrm{MaxEnt\\, probability\\,  for\\, given \\, true\\, mean\\, \\mu }")
	
	bar(L_r,q_r,
		line= false,
		title = txt2,
		ylim = (0.0, 1.1),
		xlabel = latexstring("R"),
		ylabel = latexstring("P\\,(R\\,|\\mu)"),		
		label = false
	)
	plot!(size=[500,300])

end


# ╔═╡ a0e51c0c-7b2f-11eb-2c1c-a77cfaf645f7
md"
 **The corresponding Lagrange parameter is**: $\lambda$ = $(round(𝜆_ME,digits=4))
"

# ╔═╡ 3bcf9ac2-213d-44fe-b8b5-8b54695c3029
begin
	N_iter_max = 10000
	eps_lagr = 1.e-8
	L_μ = [1.01:0.01:4.99;]
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


rating $\overline{\boldsymbol{R}}$:    $(@bind 	mean_r Slider(1.0:0.01:5, show_value=true,default=2.0)) 


number of votes $\mathcal{N}$: $(@bind 	N Slider(1:250, show_value=true,default=20)) 


α :    $slider_α     
β :    $slider_β     
      (_to change the values, click and pull the numbers_) 
"""

# ╔═╡ 1b9848f0-7a4a-4916-b7df-ffcd61c39415
begin
	# compute posterior 
	R       = N * mean_r
	L_ln_P 	= R * L_𝜆 .- N * log.(L_Z) .- log.(Prior)
	L_ln_P  = L_ln_P .- maximum(L_ln_P)
	L_P     = exp.(L_ln_P)
	L_P     = L_P/sum(L_P)
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
	ylim   = (0, 0.06)
	)
	plot(plot1,plot2,layout = (1, 2))
		plot!(size=[600,300])
end

# ╔═╡ f1586893-5fe6-4202-801b-80fda48511bc
begin
bind_prior = @bind rr Slider(1.00:0.001:4.999, default=2.0)
	nothing
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
# ╟─033db041-4b66-4a4f-a063-1b7d310c232c
# ╟─3bcf9ac2-213d-44fe-b8b5-8b54695c3029
# ╟─1b9848f0-7a4a-4916-b7df-ffcd61c39415
# ╟─248a131d-49c7-45cd-8e30-527386e317f5
# ╟─a22bf9fc-7b28-11eb-30c1-0fa6d84c74d1
# ╟─4c48af3c-dac8-43d4-9a57-7fed5052300a
# ╟─f1586893-5fe6-4202-801b-80fda48511bc
