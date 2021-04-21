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

# ╔═╡ 4ff8a6cc-7159-11eb-1fc5-0948835a1233
begin 
	using SpecialFunctions
	using LaTeXStrings
	using PlutoUI
	using Plots
	
	begin
	try
		using PlutoUI
		using Plots
		#using Plots.PlotMeasures
		using LaTeXStrings
		#using Markdown
		#using Images
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
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
		#Pkg.add("Markdown")
		#Pkg.add("Images")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		#Pkg.add("Distributions")
		using PlutoUI, Plots, LaTeXStrings, SpecialFunctions
		#using LinearAlgebra
		#using SparseArrays
		#using StatsBase
		#using Random
		md""" 
		### Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
end
end

# ╔═╡ 4c0002d6-7159-11eb-22f3-93820c6bed3b
md"
# The mysterious island 🏝️🏝️🏝️"

# ╔═╡ 00383ed0-71b9-11eb-15ed-af46eb2a90c2
md"""
## Here is the story 📖:
* _The Bayesian crew approaches the shore of an island. They assume that this is one of the two islands on the treasure map._ 
* _For these islands they know the percentage_ $Q_\alpha$ (with $\alpha \in \{1,2\}$ ) _of frogfish_ 🐸/🐟.

* _They catch $(latexstring("\\mathcal{N}")) fish and observe_ $(latexstring("\\boldsymbol{K}")) _frogfish._

* ❓ _The question is : What is the probability_  $(latexstring("P(I_\\alpha \\mid \\boldsymbol{K}, \\mathcal{N})"))
  _that they discovered island_ $(latexstring("I_{\\alpha}"))

 
* 😟 _Here is the more worrying situation : Maybe it is a mysterious island for which they have no clue about the frog-fish percentage_ 

* _Let's assume the prior probability that it is indeed a mysterious island is_ $(latexstring("P(I_3) = \\alpha"))

* _The first case is actually covered for_ $(latexstring("P(I_3) = \\alpha = 0"))

"""

# ╔═╡ 3c3d53d6-715d-11eb-3c6d-1dcd6a5eda99
md"""
## Have fun experimenting with the problem  😊
"""

# ╔═╡ ca94159c-71e5-11eb-2d65-b72e0a5eeda6
md"""
**Prior probability for a mysterious island $(latexstring("P(I_3) = \\alpha")):** $(@bind Prior Slider(0:.001:1; default=.0,show_value=true))
"""

# ╔═╡ c52ad006-715b-11eb-0112-f903af616279
begin
	md"""
 $(latexstring("\\mathcal{N}")): $(@bind N NumberField(10:100; default=20)),    
	
Frogfish ratio 🐸/🐟 at treasure island $(latexstring("Q_1")):	$(@bind q1 Slider(0.05:.05:0.95; default=.2, show_value=true)),    

Frogfish ratio 🐸/🐟 at paradox island $(latexstring("Q_2")):	$(@bind q2 Slider(0.05:.05:0.95; default=.4, show_value=true))
	"""
end

# ╔═╡ 5b0d2077-05a2-4e36-a38f-19b038449fb5
md"""The probabilities for the 3 islands with $(latexstring("P(I_3) = \\alpha = ")) $(Prior) for $(latexstring("\\boldsymbol{K}")) = $(@bind K Scrubbable(0:N)) 
is 
"""

# ╔═╡ 8ca101d4-f1c1-4ec9-a344-afec8080d197
function sr(variable, dig = 2)
	# string and round - converts a variable into a string with the predifined precission - to be extended to scientific and other formats
	if dig == 0
		return string(round(Int, variable))
	else
		return string(round(variable, digits = dig))
	end
end

# ╔═╡ dc0bd828-7159-11eb-349a-216bfcc0835c
begin

	L_ln_Prior = log.([(1-Prior)/2 (1-Prior)/2 Prior])


	L_q  = [ q1 q2]
	L_n_ff = [0: N;]
	n_ff_max = maximum(L_n_ff)
	N_islands = 2
	# islands with known q-s
	L_ln_P1 = zeros(n_ff_max+1,2)
	for i in 1: N_islands 
		q    = L_q[i]
		lnq  = log(q)
		lnmq = log(1-q)
		for (j, ng) in enumerate(L_n_ff) 
		   L_ln_P1[j,i] =  ng.* lnq + (N - ng)*lnmq + L_ln_Prior[i]
	   end
	end

	L_ln_extra = [loggamma(ng+1)+loggamma(N-ng+1)-loggamma(N+2) for ng in L_n_ff]
	L_ln_extra = 	L_ln_extra .+ L_ln_Prior[3]
	L_ln_P =  hcat(L_ln_P1,L_ln_extra)


	P  = exp.(L_ln_P  .- maximum(L_ln_P))
	for ng in 1: n_ff_max+1
		P[ng,:] = P[ng,:]./sum(P[ng,:])
	end
	md"
### Program"
end

# ╔═╡ 1f6ec6d4-715a-11eb-1a01-3984eba81101
begin
    NN = N_islands+1
	Prob = P

	col = [:red,:blue,:black]
	L_label = ["island 1", "island 2","mysterious island"]
plot1 = plot(L_n_ff,Prob[:,1],
marker = :dot,
label  = "island 1",
color = col[1],
xlabel = L"n_g",
ylabel = L"P(I_\alpha |n_g)"
)
for i in 2: NN
    global plot1
    plot1 = plot!(L_n_ff,Prob[:,i],
    marker = :dot,
    color = col[i],
    label  = L_label[i],
    )
end

L_txt = [L"<n_1>",L"<n_2>"]
avg_n2 = L_q[2] * N
for i = 1: 2
    global plot1
    avg_ng = L_q[i] * N
    plot1 = plot!([avg_ng;avg_ng],[0;1],
    linewidth = 2,
    color = col[i],
    label = L_txt[i],
    legend = :outertopright
    )
end
	T = [L_n_ff Prob]
plot(plot1)


end

# ╔═╡ 75454b67-3066-42c2-808b-8af621ad477f
md"""
-  $(latexstring("I_1")) ... **treasure island**: $(sr.(T[K+1,2],3))
-  $(latexstring("I_2")) ... **paradox island**: $(sr.(T[K+1,3],3))
-  $(latexstring("I_3")) ... **misterious island:** $(sr.(T[K+1,4],3))

"""

# ╔═╡ Cell order:
# ╟─4c0002d6-7159-11eb-22f3-93820c6bed3b
# ╟─00383ed0-71b9-11eb-15ed-af46eb2a90c2
# ╟─3c3d53d6-715d-11eb-3c6d-1dcd6a5eda99
# ╟─ca94159c-71e5-11eb-2d65-b72e0a5eeda6
# ╟─c52ad006-715b-11eb-0112-f903af616279
# ╟─1f6ec6d4-715a-11eb-1a01-3984eba81101
# ╟─5b0d2077-05a2-4e36-a38f-19b038449fb5
# ╟─75454b67-3066-42c2-808b-8af621ad477f
# ╟─8ca101d4-f1c1-4ec9-a344-afec8080d197
# ╟─dc0bd828-7159-11eb-349a-216bfcc0835c
# ╟─4ff8a6cc-7159-11eb-1fc5-0948835a1233
