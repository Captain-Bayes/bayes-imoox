### A Pluto.jl notebook ###
# v0.14.1

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

# ╔═╡ 73555af0-8353-11eb-215d-d3578a6f1e2e
begin
	try
		using PlutoUI
		using Plots
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
		#using StatsBase
		#using Random
		using Distributions
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
		#Pkg.add("StatsBase")
		Pkg.add("Distributions")
		using PlutoUI
		using Plots
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
		#using StatsBase
		#using Random
		using Distributions
		md""" 
		# Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
end

# ╔═╡ d141cf00-8352-11eb-2e51-f115e26e1570
md"""
# Popular probability distributions 🥳
Here you can explore some of the most famous discrete probability distributions
"""

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
	ylabel = "probability mass function",
	xlabel = "K - number of counting events",
	label = :none,
	ylim =[0,1],
)
	
end

# ╔═╡ 47882682-844f-11eb-335e-afc41d5498e1
md"""
_What could be the reason for the **strange behavior** for $\lambda \geq 14$ for large values of K?_ 

👉 The function becomes discontinuous for values larger 14  $(@bind is_discontinuous CheckBox())

👉 There is no problem, the function should look like that  $(@bind is_no_problem CheckBox())

👉 There are numerical issues  $(@bind is_num CheckBox())

"""

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
	color = col_pal[1]
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
	ylim = (0,.5),
	label = :none)
	
	plot!(L_k,P_k,
		line = ( 1, 0., :path),
    normalize = false,
    marker = (5, 1., :o),
    markerstrokewidth = 1.,
    color = col_pal[1],
	label = "Geometric"
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

# ╔═╡ 2fd9b8e0-8450-11eb-3bb3-47a5129b79d4
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));
#blue

# ╔═╡ 4dee8720-8450-11eb-2c00-ff79035aeddb
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));
#red

# ╔═╡ 5768fb00-8450-11eb-0960-b3f6ca4b4bb8
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));
#brown

# ╔═╡ 4027c390-8450-11eb-2bb2-c7f245b545e6
correct(text=md"Great! You got the right answer!") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));
#green

# ╔═╡ 92552af0-844f-11eb-23fa-5711044ae250
if !(is_num & !is_discontinuous & !is_no_problem)
	hint(md"The depicted values are wrong, guess what the reason in our implementation could be.")
else
	correct(md"**Great!** ✨ You got the right answer! 🎈
		
We are dividing two very large numbers - think and post in the forum of how this could be solved!")
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
# ╟─73555af0-8353-11eb-215d-d3578a6f1e2e
# ╟─2fd9b8e0-8450-11eb-3bb3-47a5129b79d4
# ╟─4dee8720-8450-11eb-2c00-ff79035aeddb
# ╟─5768fb00-8450-11eb-0960-b3f6ca4b4bb8
# ╟─4027c390-8450-11eb-2bb2-c7f245b545e6
