### A Pluto.jl notebook ###
# v0.19.23

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

# ╔═╡ 53b7c092-6e9b-11eb-0fa7-57fc1385457c
md"
# _The Gaussian Process_
Given a vector of pivot points $\boldsymbol t = t_1, \dots, t_k, \dots$,
the corresponding random vector  $\vec{x} = (x^{(t_1)}, \dots, x^{t_k}, \dots )$
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

# ╔═╡ 0ac101ba-6ecc-11eb-090e-6b5998c6bbfd
md"
## Setting up the mathematical details
"

# ╔═╡ c823a222-6e1c-11eb-18a8-01a1b673d7b0
begin

	#try
		using LinearAlgebra
		using Random
		using Plots
   	 	using PlutoUI
		md""" **0) import packages** 	All needed Packages available :) """
	#=catch
		using Pkg;
		Pkg.activate(mktempdir())
		Pkg.add("PlutoUI")
		Pkg.add("Plots")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("Random")
		
		using LinearAlgebra
		using Random
		using Plots
   	 	using PlutoUI
		md""" **0) import packages** Some Package sources not added, this will take 			approx. 3-6 minutes"""
	end
	=#
end

# ╔═╡ 0bef3462-6e1d-11eb-08f6-e3b2c36a0721

begin

if kernel == "1"
		txt = "Straight line";
		L_x    = L_x0;		
		K(x, y, 𝛼, sigma) = 𝛼 * x * y;
	elseif kernel == "2"
		txt = "Wiener process";
		L_x    = [x for x in L_x0 if x >= 0];
		K(x, y, 𝛼, sigma) = 𝛼 * min(x, y);
	elseif kernel == "3"
		txt = "Squared exponential";
		L_x    = L_x0;
		K(x, y, 𝛼, 𝜎) = 𝛼 * exp(- (x - y)^2/𝜎^2);
	elseif kernel == "4"
		txt = "Ornstein-Uhlenbeck process";
		L_x    = L_x0;
		K(x, y, 𝜶, 𝜎) = 𝜶 * exp(abs(x - y)/𝜎);
	else
		error("$(kernel) not supported")
	end	
	n = length(L_x);
	md"""**1) kernel definitions**"""
end

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

# ╔═╡ 05d7032c-6e25-11eb-0b48-7f9a594b5b88
begin
	rng = MersenneTwister(seed)
	u = randn(rng,n, 1)
	md"""**4) normal random vector zero mean, unit variance**"""
end

# ╔═╡ 2506c99c-6e1d-11eb-31a2-dd1b99a80d8a
begin
	C = [K(x, y, 𝛼, 𝜎) for x in L_x, y in L_x];
	F = svd(C);
	A = F.U * Diagonal(sqrt.(F.S));	
	z = A * u;
	md""" **5) sample from mvG** """
end


# ╔═╡ 21cff596-6ecc-11eb-093c-f97fac9ab7cb
md"
## Try it out! 
"

# ╔═╡ 2837bf6e-6eb2-11eb-2b2a-190fa3669085
md"""
**Choose a kernel:** $(@bind kernel Select(["1"=>"Straight lines","2"=>"Wiener process","3"=>"Squared exponential","4"=>"Ornstein-Uhlenbeck process"]))
"""

# ╔═╡ bc5fc60a-6e92-11eb-0003-b58331ceddcf
ik = parse(Int32,kernel);

# ╔═╡ 6be2bb7a-6eb6-11eb-2cfb-87383e68bf54
md"
**Specify the seed value of random number generator**  

1 $(@bind seed Slider(1:200)) 200
"

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

# ╔═╡ Cell order:
# ╟─53b7c092-6e9b-11eb-0fa7-57fc1385457c
# ╟─0ac101ba-6ecc-11eb-090e-6b5998c6bbfd
# ╟─c823a222-6e1c-11eb-18a8-01a1b673d7b0
# ╟─0bef3462-6e1d-11eb-08f6-e3b2c36a0721
# ╟─dca69d60-6e8c-11eb-3305-3fa2cedd5dac
# ╟─1edc6c32-6e1d-11eb-2f8a-b9dd2aff7b99
# ╟─05d7032c-6e25-11eb-0b48-7f9a594b5b88
# ╟─2506c99c-6e1d-11eb-31a2-dd1b99a80d8a
# ╟─21cff596-6ecc-11eb-093c-f97fac9ab7cb
# ╟─2837bf6e-6eb2-11eb-2b2a-190fa3669085
# ╟─bc5fc60a-6e92-11eb-0003-b58331ceddcf
# ╟─6be2bb7a-6eb6-11eb-2cfb-87383e68bf54
# ╟─4fdde52e-6e8b-11eb-3199-8112d143a31a
# ╟─431df5da-6eb4-11eb-11af-898fdf3601d5
# ╟─ac913758-6e27-11eb-1649-37b1be855f5b
# ╟─b3e26166-6e1e-11eb-1708-25be9e2a339f
