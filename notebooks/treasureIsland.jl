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
end

# ╔═╡ 4c0002d6-7159-11eb-22f3-93820c6bed3b
md"
# The mysterious island 🏝️🏝️🏝️"

# ╔═╡ 00383ed0-71b9-11eb-15ed-af46eb2a90c2
md"""
## Here is the story 📖:
* _The Bayesian crew approaches the shore of an island. They assume that this is one of the two islands on the treasure map._ 
* _For these islands they know the percentage_ $q_\alpha$ (with $\alpha \in \{1,2\}$ ) _of frogfish._

* _They catch $N$ fish and observe_ $n_{ff}$ _frogfish._

* ❓ _The question is : What is the probability_ $P(I_\alpha\mid n_{ff},N)$ _that they discovered island_ $I_{\alpha}$ 

* 😟 _Here is the more worrying situation : Maybe it is a mysterious island for which they have no clue about the frog-fish percentage_ 

* _Let's assume the prior probability that it is indeed a mysterious island is_ $Prior_{myst.island}$ 

* _The first case is actually covered for_ $Prior_{myst.island}=0$

"""

# ╔═╡ 3c3d53d6-715d-11eb-3c6d-1dcd6a5eda99
md"""
## Have fun experimenting with the problem  😊
"""

# ╔═╡ ca94159c-71e5-11eb-2d65-b72e0a5eeda6
md"""
**Prior probability for a mysterious island :**	0 $(@bind Prior Slider(0:.001:1; default=.0,show_value=true)) 1
"""

# ╔═╡ c52ad006-715b-11eb-0112-f903af616279
begin
	md"""
	**N:** $(@bind N NumberField(10:100; default=20)),    
	**q1:**	$(@bind q1 Slider(0:.05:1; default=.2, show_value=true)),    
		**q2:**	$(@bind q2 Slider(0:.05:1; default=.4, show_value=true))
	"""
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
plot(plot1)


end

# ╔═╡ d39c0658-71e3-11eb-3d58-edf898c00fae


# ╔═╡ Cell order:
# ╟─4c0002d6-7159-11eb-22f3-93820c6bed3b
# ╟─4ff8a6cc-7159-11eb-1fc5-0948835a1233
# ╟─00383ed0-71b9-11eb-15ed-af46eb2a90c2
# ╟─dc0bd828-7159-11eb-349a-216bfcc0835c
# ╟─3c3d53d6-715d-11eb-3c6d-1dcd6a5eda99
# ╟─ca94159c-71e5-11eb-2d65-b72e0a5eeda6
# ╟─c52ad006-715b-11eb-0112-f903af616279
# ╟─1f6ec6d4-715a-11eb-1a01-3984eba81101
# ╟─d39c0658-71e3-11eb-3d58-edf898c00fae
