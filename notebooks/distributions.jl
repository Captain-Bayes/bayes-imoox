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

# ╔═╡ d141cf00-8352-11eb-2e51-f115e26e1570
begin
	md"""
# Popular discrete probability distributions 🥳
Here you can explore some of the most famous discrete probability distributions
"""
end

# ╔═╡ e6d68ef0-8352-11eb-1999-0384c7ff8526
md"""
## Poisson distribution

The Poisson distribution is given by
> $P_{\cal P}(K|\lambda) =\textrm{e}^{-\lambda} \frac{\lambda^K}{K!}$

with $K$ the number of observed counts per interval given that $\lambda$ discribes the fixed average of counts per interval.
"""


# ╔═╡ 6196a940-8353-11eb-1a09-29cb2338d697
md"""
Vary the parameter of 👉 $\lambda$: $(@bind lambda Slider(0:1:18, default=1, show_value = true))
"""

# ╔═╡ a88ae050-8353-11eb-3eee-b7ee9b717fdb
begin	
	
	k =0:1:17
	poisson = lambda.^k./gamma.(k.+1).*exp(-lambda)
	col_pal = palette(:default) # color palette
	
	plot(
    k, poisson,
    line = (0.0 , 2.0 , :bar),
    normalize = false,
	bar_width = 0.2,
    marker = (6, 0.5, :none),
    markerstrokewidth = 5.,
    color = col_pal[1],
    fill = 0.9,
    orientation = :v,
    title = "The Poisson distribution with lambda: "*string(lambda),
	ylabel = "probability mass function",
	xlabel = "Points",
	label = :none,
	ylim =[0,1],)
	
	plot!(
    k, poisson,
    line = ( 1, 0., :path),
    normalize = false,
    marker = (5, 1., :o),
    markerstrokewidth = 1.,
    color = col_pal[1],
    fill = 0.,
    orientation = :v,
    title = "The Poisson distribution with lambda: "*string(lambda),
	ylabel = latexstring("P_{\\mathcal{P}}(K\\,|\\, \\lambda)"),
	xlabel = "K - number of counting events",
	label = :none,
	ylim =[0,1],	
	#xtick = [0,10],
	#ytick = [0,1/10],
	#xticklabel = latexstring("x_{\\textrm{max}}"),
	#ylim = [0,50],
	legend= :right,
	#xlim = [0,60],
	# series properties
	# size of image, margins, font size, ...
	size = (600,400),  
	labelfontsize = 20,
	legendfontsize = 15,
	tickfontsize = 15,
	bottom_margin =25mm,
	left_margin = 5mm,
	right_margin = 10mm,
	titlefontsize = 15,	
	background_color = :transparent,  
	# this is really cool, transparent background :)
	foreground_color = :black,
	# makes it look like LaTeX
	fontfamily="Computer Modern"
)
end

# ╔═╡ 47882682-844f-11eb-335e-afc41d5498e1
md"""
_What could be the reason for the **strange behavior** for $\lambda \geq 14$ for large values of K?_ 

👉 The function becomes discontinuous for values larger 14  $(@bind is_discontinuous CheckBox())

👉 There is no problem, the function should look like that  $(@bind is_no_problem CheckBox())

👉 There are numerical issues  $(@bind is_num CheckBox())

"""

# ╔═╡ 92552af0-844f-11eb-23fa-5711044ae250
if !(is_num & !is_discontinuous & !is_no_problem)
	hint(md"The depicted values are wrong, guess what the reason in our implementation could be.")
else
	correct(md"**Great!** ✨ You got the right answer! 🎈
		
We are dividing two very large numbers - think and post in the forum of how this could be solved!")
end

# ╔═╡ 7799e4c0-844b-11eb-2484-051807211341
md"""
## Binomial distribution  

> $P_{\cal B}(K|N,Q)  = {N\choose K}  Q^K (1-Q)^{N-K}$

_When can a Binomial be approximated by a Gaussian or a Poissonian?_  🤔


"""

# ╔═╡ 9acafce0-844b-11eb-331c-0186de214a59
md"""
Vary the parameters of the **the total number of experiments** 👉 N: $(@bind N_binom Scrubbable(0:1:20)) and of the **success probability** 👉 Q: $(@bind Q_binom Scrubbable(0:0.05:1)) 

Compare with **Gauss distribution** 👉 $(@bind check_gauss CheckBox())
and with **Poisson distribution** 👉 $(@bind check_poisson CheckBox())

_For which parameters do they match?_ 🤔
"""

# ╔═╡ 3a1c82a0-844c-11eb-05a6-75924317db64
begin
	L_m = [0:1:N_binom;]
	P_m = pdf.(Binomial(N_binom,Q_binom),L_m)

	plot(L_m,P_m,
	line = (.0 , 3.0 , :bar),
	ylim = (0,1),
	label = :none,
    normalize = false,
	bar_width = 0.2*N_binom/18,
    marker = (8, 1.5, :none),
    markerstrokewidth = 1,
    #color = [:steelblue],
    fill = 0.9,
	)
	
	
	
	if check_gauss
		avg = N_binom*Q_binom
	var = N_binom*Q_binom*(1-Q_binom)

	P_g2 = [exp(-(m - avg)^2 /(2*var)) for m in L_m]

	P_g2 = P_g2 / sum(P_g2)
	plot!(L_m,P_g2,
		line = (1.,0.,:path),
		marker = (6, :square),
		opacity = 0.4,
		color = :red,
		label = "Gauss with same mean and variance"
	)
	end
	

	
	if check_poisson
		avg = N_binom*Q_binom
		Poisson_m = pdf.(Poisson(avg),L_m)
		plot!(L_m,Poisson_m,
		line = (1.,0.,:path),
		
		marker = (10., :s,:blue),
		opacity = 0.4,
		color = :red,
		label = "Poisson with same mean"
	)
	end
	plot!(
    L_m,P_m,
    line = ( 1., 0., :path),
    normalize = false,
    marker = (5, 1., :o),
    markerstrokewidth = 1.,
	label = "Binomial",
	color = col_pal[1],
	xlabel = latexstring("K"), 
	ylabel = latexstring("P_{\\mathcal{B}}(K\\,|\\, N,Q)"),
	#xtick = [0,10],
	#ytick = [0,1/10],
	#xticklabel = latexstring("x_{\\textrm{max}}"),
	#ylim = [0,50],
	legend= :right,
	title = "Binomial distribution",
	#xlim = [0,60],
	# series properties
	# size of image, margins, font size, ...
	size = (600,400),  
	labelfontsize = 20,
	legendfontsize = 15,
	tickfontsize = 15,
	bottom_margin =25mm,
	left_margin = 5mm,
	right_margin = 10mm,
	titlefontsize = 20,	
	background_color = :transparent,  
	# this is really cool, transparent background :)
	foreground_color = :black,
	# makes it look like LaTeX
	fontfamily="Computer Modern"
)

end

# ╔═╡ 73b7eb70-8452-11eb-0f2e-df6b5cd0da4a
md"""
## Geometric distribution  

> $P_{\cal G}(K|Q_a)  = Q_a (1-Q_a)^{K-1}$

_What's the connection to the Binomial distribution?_  🤔


"""

# ╔═╡ 08562f30-8453-11eb-36bd-7b55fcd4b82e
begin 
md"""
Vary the **success probability** 👉 $Q_a$:  $(@bind q_a_aux Scrubbable(0.3:0.05:0.99,default = sqrt(1/6))) 
"""
end

# ╔═╡ b10c08c0-8453-11eb-1614-ef634e6929e5
begin
	Q_a = q_a_aux^2
	avg_k = 1/Q_a
	md"""
	For $Q_a$ = $(round(Q_a,digits=3)) the mean waiting time is $(round(avg_k,digits=3))
	"""
end

# ╔═╡ 65567910-8453-11eb-1de3-d38bd5010350
begin
    k_max = ceil(10/Q_a)
	L_k = [0:1:k_max;]
	P_k = Q_a.*(1-Q_a).^L_k
	
	plot(L_k,P_k,
	line = (0.0 , 2.0 , :bar),
    normalize = false,
	bar_width = 0.3,
    marker = (6, 0.5, :none),
    markerstrokewidth = 5.,
    color = col_pal[1],
	xlim = (0,40),
	ylim = (0,.3),
	label = :none)
	
	plot!(L_k,P_k,
		line = ( 1, 0., :path),
    normalize = false,
    marker = (5, 1., :o),
    markerstrokewidth = 1.,
    color = col_pal[1],
	label = "Geometric",
	xlabel = latexstring("K"), 
	ylabel = latexstring("P_{\\mathcal{G}}(K\\,|\\, Q_a)"),
		title = "Geometric distribution",
	#xtick = [0,10],
	#ytick = [0,1/10],
	#xticklabel = latexstring("x_{\\textrm{max}}"),
	#ylim = [0,50],
	legend= :right,
	#xlim = [0,60],
	# series properties
	# size of image, margins, font size, ...
	size = (600,400),  
	labelfontsize = 20,
	legendfontsize = 15,
	tickfontsize = 15,
	bottom_margin =25mm,
	left_margin = 5mm,
	right_margin = 10mm,
	titlefontsize = 20,	
	background_color = :transparent,  
	# this is really cool, transparent background :)
	foreground_color = :black,
	# makes it look like LaTeX
	fontfamily="Computer Modern"
)
		
#=	
	avg = N*q
	var = N*q*(1-q)

	P_g2 = [exp(-(m - avg)^2 /(2*var)) for m in L_m]

	P_g2 = P_g2 / sum(P_g2)

	plot!(L_m,P_g2,
		line = false,
		marker = :dot,
		color = :red,
		label = "Gauss with same mean and variance"
	)
=#
end

# ╔═╡ 1cc62475-2dd3-488b-9647-9d5b2986d791
md"""
# Popular continuous probability distributions 🐱‍👤
"""

# ╔═╡ 48811336-16f6-496f-848d-54fd834bb0da
md"""
## Gamma distribution

> $p_{\Gamma}(x\,|\,\alpha, \beta)  = \frac{\beta^\alpha}{\Gamma(\alpha)} x^{\alpha-1} e^{-\beta x}, \quad x \in [0,\infty)$
> $\Gamma(\alpha):= \int_0^\infty t^{\alpha-1} e^{-t} dt$


_What's the connection to the Poisson distribution?_  🤔

"""

# ╔═╡ fb470501-cea4-4ac9-a652-d9874dbd7bdc
md"""
Choose **parameters** $\alpha$ 👉 $(@bind α Scrubbable(0:0.1:5, default = 2)) and 

 $\beta$ 👉 $(@bind β Scrubbable(0:0.1:5, default = 2))
"""

# ╔═╡ c3fad29d-ffa2-4bab-a164-6b53573b6050
begin
	
	md"""asdf $asdf$ $(α)  as"""
	gamma_x = 0:0.1:10
	
	
	gamma_pdf = β^α / gamma(α) .* gamma_x.^(α-1) .* exp.(-β .* gamma_x)
	
	plot(gamma_x, gamma_pdf,
	lines = :path,
	title = "Gamma distribution" ,
	#yscale = :log10,
	# labels
	xlabel = latexstring("x"), 
	ylabel = latexstring("p_\\Gamma(x\\,|\\, \\alpha, \\beta)"),
	label = latexstring(" \\alpha = " * sr(α,2) * ", \\beta = " * sr(β,2)),
	#xtick = [0,10],
	#ytick = [0,1/10],
	#xticklabel = latexstring("x_{\\textrm{max}}"),
	#ylim = [0,50],
	legend= :right,
	#xlim = [0,60],
	# series properties
	linewidth = 4,
	# size of image, margins, font size, ...
	size = (600,400),  
	labelfontsize = 20,
	legendfontsize = 15,
	tickfontsize = 15,
	bottom_margin =25mm,
	left_margin = 5mm,
	right_margin = 10mm,
	titlefontsize = 20,	
	background_color = :transparent,  
	# this is really cool, transparent background :)
	foreground_color = :black,
	# makes it look like LaTeX
	fontfamily="Computer Modern"
)
	
	
end

# ╔═╡ 3d85408a-b356-4107-b604-b39fb5a6982e
md"""
## Beta distribution

> $p_{\beta}(x\,|\,\alpha, \rho)  = \frac{1}{B(\alpha,\rho)} x^{\alpha-1} (1-x)^{\rho-1}, \quad x \in [0,1]$
> $B(\alpha, \rho):= \int_0^1 p^{\alpha-1} (1-p)^{\rho-1}dp$


_What's the conjugated Likelihood?_  🤔

"""

# ╔═╡ 8ced1f19-501a-47ff-8b0a-eee49816bd4a
md"""
Choose **parameters** $\alpha$ 👉 $(@bind α_b Scrubbable(0:0.1:5, default = 2)) and 

 $\rho$ 👉 $(@bind ρ Scrubbable(0:0.1:5, default = 2))


"""

# ╔═╡ 2ba5aa6f-cdb8-4a82-85c2-66820ceefd4b
begin
	beta_x = 0:0.01:1
	
	
	beta_pdf = 1 ./beta(α_b, ρ) .* beta_x.^(α_b-1) .* (1 .- beta_x).^(ρ-1)
	
	plot(beta_x, beta_pdf,
	lines = :path,
	title = "Beta distribution",
	#yscale = :log10,
	# labels
	xlabel = latexstring("x"), 
	ylabel = latexstring("p_\\beta(x\\,|\\, \\alpha, \\rho)"),
	label = latexstring(" \\alpha = " * sr(α_b,2) * ", \\rho = " * sr(ρ,2)),
	#xtick = [0,10],
	#ytick = [0,1/10],
	#xticklabel = latexstring("x_{\\textrm{max}}"),
	ylim = [0,4],
	legend= :top,
	#xlim = [0,60],
	# series properties
	linewidth = 4,
	# size of image, margins, font size, ...
	size = (600,400),  
	labelfontsize = 20,
	legendfontsize = 15,
	tickfontsize = 15,
	bottom_margin =25mm,
	left_margin = 5mm,
	right_margin = 10mm,
	titlefontsize = 20,	
	background_color = :transparent,  
	# this is really cool, transparent background :)
	foreground_color = :black,
	# makes it look like LaTeX
	fontfamily="Computer Modern"
)
	
	
	#savefig("C://beta_alpha_01_rho_01")
	
end

# ╔═╡ 8efc6cb4-23f3-4ff3-84ee-2cd7891dd1a8
md"""
## Gaussian distribution

> $p_{\mathcal{N}}(x\,|\,x_0, \sigma)  = \frac{1}{\sqrt{2\pi\sigma^2}} \exp\left( -\frac{(x-x_0)^2}{2\sigma^2}\right), \quad x \in (-\infty,\infty)$


_What's the definition in more dimensions?_  🤔

"""

# ╔═╡ ed6970b0-8f76-4490-aef6-7bdfba026c27
md"""
Choose **parameters** $x_0$ 👉 $(@bind x_0 Scrubbable(-10:0.1:10, default = 0)) and 

 $\sigma$ 👉 $(@bind σ Scrubbable(0.1:0.1:5, default = 2))


"""

# ╔═╡ 49cbd69b-e140-422c-9c1e-e9dd2a0545d8
begin
	d = -10:0.01:10
	
	d1_pdf = 1 ./sqrt(2*pi*σ^2) .* exp.(- (d .-x_0).^2 ./(2*σ^2))
	plot(d, d1_pdf,
	lines = :path,
	title = "Gaussian distribution",
	#yscale = :log10,
	# labels
	xlabel = latexstring("x"), 
	ylabel = latexstring("p\\,(x\\,|\\, \\vec a)"),
	label = latexstring(" x_0 = " * sr(x_0,2) * ", \\sigma = " * sr(σ,2)),
	#xtick = [0,10],
	#ytick = [0,1/10],
	#xticklabel = latexstring("x_{\\textrm{max}}"),
	ylim = [0,1],
	legend= :topright,
	#xlim = [0,60],
	# series properties
	linewidth = 4,
	# size of image, margins, font size, ...
	size = (600,400),  
	labelfontsize = 20,
	legendfontsize = 15,
	tickfontsize = 15,
	bottom_margin =25mm,
	left_margin = 5mm,
	right_margin = 10mm,
	titlefontsize = 20,		
	background_color = :transparent,  
	# this is really cool, transparent background :)
	foreground_color = :black,
	# makes it look like LaTeX
	fontfamily="Computer Modern"
)
end

# ╔═╡ 44d4d19e-b0d2-4768-bc6b-eb63affc3898
md"""
# About the creators

This notebook was created by **Prof. Wolfgang von der Linden** and **Gerhard Dorn** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ 73555af0-8353-11eb-215d-d3578a6f1e2e
begin
	#try
		using PlutoUI
		using Plots, Plots.PlotMeasures
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
		#using StatsBase
		#using Random
		using Distributions
		using LaTeXStrings	
		using Markdown
		
		md""" 
		# Packages
		
		All needed Packages available :) """
	#=catch
		import Pkg
		Pkg.activate(mktempdir())
		Pkg.add("PlutoUI")
		Pkg.add("Plots")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		Pkg.add(["Distributions", "LaTeXStrings", "Markdown"])
		
		using PlutoUI
		using Plots, Plots.PlotMeasures
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
		#using StatsBase
		#using Random
		using Distributions
		using LaTeXStrings
		md""" 
		# Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	=#
end

# ╔═╡ 02f9fccb-594a-4594-b3f1-900f0847e01e
function sr(variable, dig = 2; add_sign = false)
	# string and round - converts a variable into a string with the predifined precission - to be extended to scientific and other formats
	if dig == 0
		st = string(round(Int, variable))
	else
		st =  string(round(variable, digits = dig))
	end
	
	if add_sign
		st = (variable < 0 ? "" : "+") * st
	end
	
	return st
	
	
end


# ╔═╡ 3554f46b-3a86-4e97-8c02-4911f8f0776a
	TableOfContents()


# ╔═╡ 1bf9a33d-da46-4dec-8c17-75243c3b84a9
begin
keep_working(text=md"The answer is not quite right.", title="Keep working on it!") = Markdown.MD(Markdown.Admonition("danger", title, [text]));

almost(text, title="Almost there!") = Markdown.MD(Markdown.Admonition("warning", title, [text]));

hint(text, title ="Hint") = Markdown.MD(Markdown.Admonition("hint", title, [text]));
	
correct(text=md"Great! You got the right answer! Let's move on to the next section.", title="Got it!") = Markdown.MD(Markdown.Admonition("correct", title, [text]));
md" Definition of Boxes"
end

# ╔═╡ Cell order:
# ╟─d141cf00-8352-11eb-2e51-f115e26e1570
# ╟─e6d68ef0-8352-11eb-1999-0384c7ff8526
# ╟─6196a940-8353-11eb-1a09-29cb2338d697
# ╟─a88ae050-8353-11eb-3eee-b7ee9b717fdb
# ╟─47882682-844f-11eb-335e-afc41d5498e1
# ╟─92552af0-844f-11eb-23fa-5711044ae250
# ╟─7799e4c0-844b-11eb-2484-051807211341
# ╟─9acafce0-844b-11eb-331c-0186de214a59
# ╟─3a1c82a0-844c-11eb-05a6-75924317db64
# ╟─73b7eb70-8452-11eb-0f2e-df6b5cd0da4a
# ╟─08562f30-8453-11eb-36bd-7b55fcd4b82e
# ╟─b10c08c0-8453-11eb-1614-ef634e6929e5
# ╟─65567910-8453-11eb-1de3-d38bd5010350
# ╟─1cc62475-2dd3-488b-9647-9d5b2986d791
# ╟─48811336-16f6-496f-848d-54fd834bb0da
# ╟─fb470501-cea4-4ac9-a652-d9874dbd7bdc
# ╟─c3fad29d-ffa2-4bab-a164-6b53573b6050
# ╟─3d85408a-b356-4107-b604-b39fb5a6982e
# ╟─8ced1f19-501a-47ff-8b0a-eee49816bd4a
# ╟─2ba5aa6f-cdb8-4a82-85c2-66820ceefd4b
# ╟─8efc6cb4-23f3-4ff3-84ee-2cd7891dd1a8
# ╟─ed6970b0-8f76-4490-aef6-7bdfba026c27
# ╟─49cbd69b-e140-422c-9c1e-e9dd2a0545d8
# ╟─44d4d19e-b0d2-4768-bc6b-eb63affc3898
# ╟─73555af0-8353-11eb-215d-d3578a6f1e2e
# ╟─02f9fccb-594a-4594-b3f1-900f0847e01e
# ╟─3554f46b-3a86-4e97-8c02-4911f8f0776a
# ╠═1bf9a33d-da46-4dec-8c17-75243c3b84a9
