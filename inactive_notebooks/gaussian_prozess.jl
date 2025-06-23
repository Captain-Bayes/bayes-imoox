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

# ╔═╡ c823a222-6e1c-11eb-18a8-01a1b673d7b0
begin

	using Pkg
	Pkg.activate("C:/Users/Gerhard/.julia/environments/v1.11")
	using LinearAlgebra
	using Random
	using Plots
   	using PlutoUI
	using MacroTools

	using MarkdownLiteral: @mdx
		md""" **0) import packages** 	All needed Packages available :) """
	
end

# ╔═╡ 53b7c092-6e9b-11eb-0fa7-57fc1385457c
md"
# _The Gaussian Process_
Given a vector of pivot points $\boldsymbol t = t_1, \dots, t_k, \dots$,
the corresponding random vector  $\vec{x} = (x^{(t_1)}, \dots, x^{(t_k)}, \dots )$
is drawn from a multivariate Gaussian 

$\vec{x} \sim \mathcal{G}(\vec{\mu},\Sigma)$

with zero mean $\vec{\mu}  = \boldsymbol0$
and a covariance with matrix elements: $\Sigma_{kl} = k(t_k,t_l)$ which is given by the kernel function $k(\boldsymbol{t}, \boldsymbol{t})$ that defines how the pivot points $t_k$ are correlated.



Many different stochastic processes can be realized as Gaussian process just by using a different kernel function $k(\boldsymbol{t}, \boldsymbol{t})$:

1) Straight line process: $k(t_k,t_l) = \alpha \cdot t_k\cdot t_l$

2) Wiener process: $k(t_k,t_l) = \alpha \cdot \text{min}(t_k, t_l)$

3) Squared exponential kernel: $k(t_k,t_l) = \alpha \cdot \exp(- \frac{(t_k-t_l)^2}{\sigma^2})$

4) Ornstein-Uhlenbeck process: $k(t_k,t_l) = \alpha \cdot \exp(- \frac{|t_k-t_l|}{\sigma})$

GPs are magic ✨ 
"

# ╔═╡ 8fcdac1e-6648-457f-a44b-caa6fd391c13
md"""
# A simple example of a bivariate Gaussian distribution
Below you can choose the two measurements $\mu_1$ and $\mu_2$ at pivot points $t_1$ and $t_2$, set up a correlation matrix $\Sigma$ and observe the probability for a measurement $\boldsymbol{x} = \begin{pmatrix} x_1 \\ x_2 \end{pmatrix}$:

$\begin{align*}
P(\boldsymbol{x} \vert \boldsymbol{\mu}, \boldsymbol{\Sigma}) = \frac{1}{(2\pi)^{D/2} \sqrt{\det(\boldsymbol{\Sigma})}} \cdot \exp\left( -\frac{1}{2} (\boldsymbol{x} - \boldsymbol{\mu})^\top \cdot \boldsymbol{\Sigma}^{-1} \cdot (\boldsymbol{x}-\boldsymbol{\mu})  \right)
\end{align*}$

"""

# ╔═╡ ab3e957c-e6e6-4fe0-9dd7-99411bb8fe15
md""" 
pivot element t₁: $(@bind t₁ Slider(-5:0.1:5, default = 1, show_value = true)) \
pivot element t₂: $(@bind t₂ Slider(-5:0.1:5, default = 2, show_value = true)) \
measurement value μ₁: $(@bind μ₁ Slider(-5:0.1:5, default = 3, show_value = true)) \
measurement value μ₂: $(@bind μ₂ Slider(-5:0.1:5, default = 1, show_value = true)) \
correlation diagonal Σ₁₁ $(@bind Σ₁₁ Slider(-5:0.1:5, default = 1, show_value = true)) \
correlation diagonal Σ₂₂ $(@bind Σ₂₂ Slider(-5:0.1:5, default = 1, show_value = true)) \
correlation offdiag Σ₁₂ $(@bind Σ₁₂ Slider(-5:0.1:5, default = 0.1, show_value = true)) \
correlation offdiag Σ₂₁ $(@bind Σ₂₁ Slider(-5:0.1:5, default = 0.2, show_value = true)) \
"""

# ╔═╡ 9dd9b2d7-4df0-49f8-948c-a098073938c4
begin
	μ_bi = [μ₁,μ₂]
	Σ = [Σ₁₁ Σ₁₂; Σ₂₁ Σ₂₂]

	f(x⃗) = exp.(-1/2 * (x⃗ - μ_bi)' * inv(Σ) * (x⃗ - μ_bi))
	x_bi = -4:0.01:4
	P_bi = [f([i,j]) for i in x_bi, j in x_bi]
	md""" setting up and evaluating $P(\boldsymbol{x})$"""
end

# ╔═╡ 055b610c-647f-4eec-a85f-5a235db3cf0d
heatmap(x_bi,x_bi,P_bi)

# ╔═╡ ebe94eb8-7f2c-4590-a85b-4d4e2f16555f
md"""
# Approximation of measurement points
"""

# ╔═╡ 0dfff071-3c08-4801-b283-ff2464a82584
begin
	

end

# ╔═╡ fb7df973-bae3-4d2f-855c-9fc5061aaf15
@bind σₛₑ Slider(0.01:0.01:4, default = 0.2, show_value = true)

# ╔═╡ 277c22a4-a18a-4263-bd81-d7678224ef6c
@bind α Slider(0.2:0.1:20, default = 1, show_value = true)

# ╔═╡ cb214f85-3efa-4d10-8d10-98b36b6c4519
@bind σ_data Slider(0.:0.01:2, default = 0, show_value = true)

# ╔═╡ 627b21cb-bce6-43bd-8e50-46c2007dd1c9
md"""
#### Enter the function: μ(t) = `` 👉 $(@bind μ_text_equation confirm(PlutoUI.TextField(50,default = " 0 * t")))
This is an estimation for the mean value of all measurements
"""

# ╔═╡ b03f178d-edff-4e1e-b751-ae0bf026bad8
μ_func(t) = eval(MacroTools.replace(Meta.parse(μ_text_equation), :t, t))

# ╔═╡ 6be2bb7a-6eb6-11eb-2cfb-87383e68bf54
md"
**Specify the seed value of random number generator**  

1 $(seed_Slider = @bind seed Slider(1:200)) 200
"

# ╔═╡ 8d0be4b7-e190-4c87-a4cb-05aee57f2297
seed_Slider

# ╔═╡ 03438229-9c31-42ba-935c-977ec37f6263
round(pi, digits = 6)

# ╔═╡ e922003c-5f8c-4834-b21e-30386e3d9208
@bind kernel_type Select(["Squared Exponential", "Linear"])

# ╔═╡ 7516bb1a-03b6-4673-a985-6f61a40bb4ce
begin
	if kernel_type == "Linear"
		K(tᵢ, tⱼ, α = 1) = α * t₁ * t₂
	elseif kernel_type == "Squared Exponential"
		K(tᵢ, tⱼ, σₛₑ = 1, α = 1) = α * exp.(-1/2 * abs.(tᵢ - tⱼ)^2 / σₛₑ^2)
	end
end

# ╔═╡ c2bb21d3-87b0-4cb0-b161-c5f483e56f5f
K(1,1)

# ╔═╡ 0ac101ba-6ecc-11eb-090e-6b5998c6bbfd
md"
## Setting up the mathematical details
"

# ╔═╡ dca69d60-6e8c-11eb-3305-3fa2cedd5dac
begin
	Nslide = 100
	L_𝛼  = [0 100 ; 0.01 20 ; 0.01 40 ; 0.1 10]
	L_𝜎 = [0 1; 0 1; 0.1 20; 1 20]
	L_d_𝛼 = 	(L_𝛼[:,2]-L_𝛼[:,1])/Nslide
	L_d_𝜎 = 	(L_𝜎[:,2]-L_𝜎[:,1])/Nslide
	md"""**2) range of parameters**"""
end

# ╔═╡ 1edc6c32-6e1d-11eb-2f8a-b9dd2aff7b99
begin
	L_x0 = [-25:0.5:25;]
	md""" **3) pivot points** """
end

# ╔═╡ 21cff596-6ecc-11eb-093c-f97fac9ab7cb
md"
## Try it out! 
"

# ╔═╡ 2837bf6e-6eb2-11eb-2b2a-190fa3669085
md"""
**Choose a kernel:** $(@bind kernel Select(["1"=>"Straight lines","2"=>"Wiener process","3"=>"Squared exponential","4"=>"Ornstein-Uhlenbeck process"]))
"""

# ╔═╡ 0bef3462-6e1d-11eb-08f6-e3b2c36a0721

begin

if kernel == "1"
		txt = "Straight line";
		L_x    = L_x0;		
		K_o(x, y, 𝛼, sigma) = 𝛼 * x * y;
	elseif kernel == "2"
		txt = "Wiener process";
		L_x    = [x for x in L_x0 if x >= 0];
		K_o(x, y, 𝛼, sigma) = 𝛼 * min(x, y);
	elseif kernel == "3"
		txt = "Squared exponential";
		L_x    = L_x0;
		K_o(x, y, 𝛼, 𝜎) = 𝛼 * exp(- (x - y)^2/𝜎^2);
	elseif kernel == "4"
		txt = "Ornstein-Uhlenbeck process";
		L_x    = L_x0;
		K_o(x, y, 𝜶, 𝜎) = 𝜶 * exp(abs(x - y)/𝜎);
	else
		error("$(kernel) not supported")
	end	
	n = length(L_x);
	md"""**1) kernel definitions**"""
end

# ╔═╡ 05d7032c-6e25-11eb-0b48-7f9a594b5b88
begin
	rng = MersenneTwister(seed)
	u = randn(rng,n, 1)
	md"""**4) normal random vector zero mean, unit variance**"""
end

# ╔═╡ aaea3e3e-a462-4842-ad2a-82504f52a518
begin
	N = 10
	tₖ = sort(rand(rng, N) * 5) # random pivotal measurement points in the range (0, 5)
	μ = sin.(tₖ) * 3 + rand(rng, N)/5  # sinus like measurments in the range (-3,3) with noise
	plot(tₖ, μ,  markers = :x, linetype = :scatter)
	
end

# ╔═╡ a189ded8-649a-4bd9-b498-9b22d90ff75c
μₜ= [eval(MacroTools.replace(Meta.parse(μ_text_equation), :t, i)) for i in tₖ]

# ╔═╡ adf91301-81c9-43b6-be97-80e05a0ae3f5
begin
	tᵤ = 0:0.05:5 # unknown approximation pivot points (501) 
	#σₛₑ = 0.2
	#α = 10
	Σᵤᵤ = round.([K(i,j, σₛₑ, α) for i in tᵤ, j in tᵤ], digits = 16)
	Σₖₖ = round.([K(i,j, σₛₑ, α) for i in tₖ, j in tₖ], digits = 16)
	Σₖᵤ = round.([K(i,j, σₛₑ, α) for i in tₖ, j in tᵤ], digits = 16)
	Σᵤₖ = round.([K(i,j, σₛₑ, α) for i in tᵤ, j in tₖ], digits = 16)

	# guess the mean value of μᵤ depending on tᵤ
	μᵤ = μ_func.(tᵤ)
	# guess the mean value of μₖ depending on tₖ
	μₖ = μ_func.(tₖ)
	
	
	
		
end

# ╔═╡ 00229b6c-aa67-446e-ab15-fabc9114bc5b
eigvals(Σₖₖ)

# ╔═╡ 71711c7e-27cb-48f3-bddd-6c8ec77ec65f
begin
	# get the conditional μᵤ and Σᵤᵤ
	μᶜᵤ = μᵤ + Σᵤₖ * (Σₖₖ \ (μ - μₖ))
	Σᶜᵤᵤ = Σᵤᵤ - Σᵤₖ * inv(Σₖₖ + σ_data * I(length(μ))) * Σₖᵤ
	sig_diag = diag(Σᶜᵤᵤ)
end

# ╔═╡ 30a0a144-2406-4904-a3a0-86c5dc4fe5e9
Σᶜᵤᵤ

# ╔═╡ 5ec8bb79-baf1-49b0-ac17-f00143441d2e
begin
	# How to sample from a multivariate Gauss distribution
	# fix pivot elements
	tᵤ
	Σᵤᵤ # = [K(x, y, 𝛼, 𝜎) for x in tᵤ, y in tᵤ]
	U, S, V = svd(Σᶜᵤᵤ)
	P = U * Diagonal(sqrt.(S))	
	
	y = randn(rng,length(tᵤ), 1)
	x = μᶜᵤ + P * y # (p(x))
end

# ╔═╡ e2461854-8526-47ef-8947-bb84ef03e5ca
begin
	# plot the marginal probabilities for each tᵤ


	plot(tᵤ, μᶜᵤ, markers= :x, ylim = (-10,10))
	plot!(tₖ, μ, markers = :o)
	plot!(tᵤ, sin.(tᵤ) * 3)
	plot!(tᵤ, μᶜᵤ -  2*abs.(sig_diag), fillrange=μᶜᵤ + 2* abs.(sig_diag), fillalpha = 0.4, alpha = 0)

	plot!(tᵤ, x)
	
end

# ╔═╡ bc5fc60a-6e92-11eb-0003-b58331ceddcf
ik = parse(Int32,kernel);

# ╔═╡ 4fdde52e-6e8b-11eb-3199-8112d143a31a
md"""
The seed you chose: $(seed)
"""


# ╔═╡ 431df5da-6eb4-11eb-11af-898fdf3601d5
#	if L_𝜎[ik,2] > 0
		md"""**Choose parameters 𝛼:**
	$(@bind 𝛼 Slider(0.1:0.1:20, show_value=true, default=1))

and **𝜎:**$(@bind 𝜎 Slider(0.1:0.1:40, show_value=true, default=1)) (only for *Squared exponential* and *Ornstein-Uhlenbeck*)
		"""
	#else
#		𝜎 = L_𝜎[ik,2]
#				md"""**Choose parameter 𝛼:**
#	$(L_𝛼[ik,1]) $(@bind 𝛼 Slider(L_𝛼[ik,1]:L_d_𝛼[ik]:L_𝛼[ik,2])) $(L_𝛼[ik,2]) 
#	"""
#	end

# ╔═╡ 2506c99c-6e1d-11eb-31a2-dd1b99a80d8a
begin
	C = [K_o(x, y, 𝛼, 𝜎) for x in L_x, y in L_x];
	F = svd(C);
	A = F.U * Diagonal(sqrt.(F.S));	
	z = A * u;
	md""" **5) sample from mvG** """
end


# ╔═╡ ac913758-6e27-11eb-1649-37b1be855f5b
if L_𝜎[ik,2] > 0
	md" 	𝛼 = $(𝛼),    𝜎 = $(𝜎)		"
else
	md" 	𝛼 = $(𝛼)"
end

# ╔═╡ b3e26166-6e1e-11eb-1708-25be9e2a339f
plot(
    L_x,
    z,
	line =(1,1,:line),
    grid = true,
    title = txt,
    palette = :tab10,
    legend = :none,
    label = false,
    marker = :cross,
    xlabel = "x",
    ylabel = "y",
    ylim = (-20, 20),
)

# ╔═╡ c075d168-d482-4072-8fd2-2172c7c86e21
md"""
# About the creators

This notebook was created by **Prof. Wolfgang von der Linden** and by **[Gerhard Dorn](https://github.com/dorn-gerhard)** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes22&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ 6eed9d16-b3a0-45c5-a4c6-d266f6cf1adc
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

# ╔═╡ 6dd2d074-c47c-4803-98a0-5c88ad0ad48b
TableOfContents()

# ╔═╡ Cell order:
# ╟─53b7c092-6e9b-11eb-0fa7-57fc1385457c
# ╟─8fcdac1e-6648-457f-a44b-caa6fd391c13
# ╟─ab3e957c-e6e6-4fe0-9dd7-99411bb8fe15
# ╟─055b610c-647f-4eec-a85f-5a235db3cf0d
# ╠═9dd9b2d7-4df0-49f8-948c-a098073938c4
# ╠═ebe94eb8-7f2c-4590-a85b-4d4e2f16555f
# ╠═8d0be4b7-e190-4c87-a4cb-05aee57f2297
# ╠═aaea3e3e-a462-4842-ad2a-82504f52a518
# ╠═0dfff071-3c08-4801-b283-ff2464a82584
# ╠═a189ded8-649a-4bd9-b498-9b22d90ff75c
# ╠═b03f178d-edff-4e1e-b751-ae0bf026bad8
# ╠═adf91301-81c9-43b6-be97-80e05a0ae3f5
# ╠═00229b6c-aa67-446e-ab15-fabc9114bc5b
# ╠═71711c7e-27cb-48f3-bddd-6c8ec77ec65f
# ╠═30a0a144-2406-4904-a3a0-86c5dc4fe5e9
# ╠═fb7df973-bae3-4d2f-855c-9fc5061aaf15
# ╠═277c22a4-a18a-4263-bd81-d7678224ef6c
# ╠═cb214f85-3efa-4d10-8d10-98b36b6c4519
# ╟─627b21cb-bce6-43bd-8e50-46c2007dd1c9
# ╟─e2461854-8526-47ef-8947-bb84ef03e5ca
# ╠═6be2bb7a-6eb6-11eb-2cfb-87383e68bf54
# ╠═5ec8bb79-baf1-49b0-ac17-f00143441d2e
# ╠═03438229-9c31-42ba-935c-977ec37f6263
# ╠═e922003c-5f8c-4834-b21e-30386e3d9208
# ╠═7516bb1a-03b6-4673-a985-6f61a40bb4ce
# ╠═c2bb21d3-87b0-4cb0-b161-c5f483e56f5f
# ╟─0ac101ba-6ecc-11eb-090e-6b5998c6bbfd
# ╠═c823a222-6e1c-11eb-18a8-01a1b673d7b0
# ╠═0bef3462-6e1d-11eb-08f6-e3b2c36a0721
# ╠═dca69d60-6e8c-11eb-3305-3fa2cedd5dac
# ╠═1edc6c32-6e1d-11eb-2f8a-b9dd2aff7b99
# ╠═05d7032c-6e25-11eb-0b48-7f9a594b5b88
# ╠═2506c99c-6e1d-11eb-31a2-dd1b99a80d8a
# ╟─21cff596-6ecc-11eb-093c-f97fac9ab7cb
# ╠═2837bf6e-6eb2-11eb-2b2a-190fa3669085
# ╟─bc5fc60a-6e92-11eb-0003-b58331ceddcf
# ╠═4fdde52e-6e8b-11eb-3199-8112d143a31a
# ╟─431df5da-6eb4-11eb-11af-898fdf3601d5
# ╟─ac913758-6e27-11eb-1649-37b1be855f5b
# ╠═b3e26166-6e1e-11eb-1708-25be9e2a339f
# ╟─c075d168-d482-4072-8fd2-2172c7c86e21
# ╟─6eed9d16-b3a0-45c5-a4c6-d266f6cf1adc
# ╟─6dd2d074-c47c-4803-98a0-5c88ad0ad48b
