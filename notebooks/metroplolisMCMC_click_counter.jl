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

# ╔═╡ 03b75df2-b63b-11eb-31ea-51aedea29d36
begin
	try
		using Random
		using PlutoUI
		using Plots
		using Markdown
		using LaTeXStrings
		using InteractiveUtils
		using Statistics
		using StatsBase
		using Printf
		using HypertextLiteral

		md""" 
		### - Packages
		
		All needed Packages available :) """
	catch
		using Pkg;
		Pkg.activate(mktempdir())
		Pkg.add("Random")
		Pkg.add("PlutoUI")
		Pkg.add("Plots")
		Pkg.add("LaTeXStrings")
		Pkg.add("Markdown")
		Pkg.add("InteractiveUtils")
		Pkg.add("Statistics")
		Pkg.add("StatsBase")
		Pkg.add("Printf")
		Pkg.add("HypertextLiteral")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		#Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		#Pkg.add("Distributions")
		using Random
		using PlutoUI
		using Plots
		using Markdown
		using LaTeXStrings
		using InteractiveUtils
		using Statistics
		using StatsBase
		using Printf
		using HypertextLiteral

		md""" 
		### - Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
end

# ╔═╡ 5ca51224-da81-4580-a385-561e6fd801d7
TableOfContents(aside = true)

# ╔═╡ 3a500c66-fdb5-4610-820c-a869cccc387a
md"# Metropolis Markov Chain Monte Carlo
## Follow the algorithm step by step"

# ╔═╡ b0ef1450-312b-43da-ace8-b0d15697c42d
md"## Real MCMC simulation

### bare simulation
"

# ╔═╡ 4620e8bd-a5c9-4f37-8139-d5957a9a9f14
md"### autocorrelation analysis"

# ╔═╡ 0b51a7d4-5a66-43bc-9755-eb7c29bc8606
md"### final result"

# ╔═╡ 583ad6aa-7bf1-4c59-bcff-bc3548b2bce6
md"________________________________________________________________________________
## Auxiliary stuff"

# ╔═╡ 40d8dcc5-2f27-46aa-9391-95155fc9850c
begin
	x0 = 0.0
	𝜎  = 0.2
	N_step_max = 10000
	seed = 132
	rng   = MersenneTwister(seed) 
	md"### - initial values"
end

# ╔═╡ cda88397-7aa4-4fc8-b8b5-3823f41a6e8e
begin
	function posterior(x)
		p1 = exp.(-(x .- 1.0).^2 ./(2*𝜎^2)) ./ sqrt(2*π*𝜎^2)
		p2 = exp.(-(x .- 1.5).^2 ./(2*𝜎^2)) ./ sqrt(2*π*𝜎^2)
		return (p1 + p2)/2
	end
	md"### - posterior pdf"
end

# ╔═╡ f06a9996-0be1-4542-9c23-b6d1b00077fc
begin
	L_xt    = zeros(N_step_max)
	L_x     = zeros(N_step_max)	
	L_p_acc = zeros(N_step_max)		
	L_r     = zeros(N_step_max)		
	L_x[1]  = x0
	for i = 1: 	N_step_max-1
		if i > 20
			dx = randn(rng) * 𝜎 /5
		else
			dx = randn(rng) * 𝜎/2			
		end
		xt = L_x[i] + dx
		p_acc = min(posterior(xt) / posterior(L_x[i]),1.)		
		L_xt[i] = xt			
		r = rand(rng)
		L_r[i] = r
		L_p_acc[i] = p_acc
		if r < p_acc
			L_x[i+1] = xt
		else
			L_x[i+1] = L_x[i]
		end
	end

     md"### - generate MCMC data"
end

# ╔═╡ 0646e617-6fd3-4249-9f60-c130d9b48a6e

ClickCounterWithReset(text="Click", reset_text="Reset") = HTML("""
<div>
<button>$(text)</button>&nbsp;&nbsp;&nbsp;&nbsp;
<a id="reset" href="#">$(reset_text)</a>
</div>
<script id="blabla">
// Select elements relative to `currentScript`
const div = currentScript.previousElementSibling
const button = div.querySelector("button")
const reset = div.querySelector("#reset")
// we wrapped the button in a `div` to hide its default behaviour from Pluto
let count = 0
button.addEventListener("click", (e) => {
	count += 1
	
	div.value = count
	div.dispatchEvent(new CustomEvent("input"))
	e.stopPropagation()
})
	reset.addEventListener("click", (e) => {
	count = 0
	
	div.value = count
	div.dispatchEvent(new CustomEvent("input"))
	e.stopPropagation()
	e.preventDefault()
})
// Set the initial value
div.value = count
</script>
""")


# ╔═╡ 7150c842-3c12-4b1b-b456-cc831b5d4f9f
begin
	md"""$(@bind counter ClickCounterWithReset("NEXT STEP", "RESET"))"""
	#md"""Increase the steps 👉$(@bind counter NumberField(0:30; default=0))"""
	

end

# ╔═╡ edf2f357-b73f-42e7-ab41-ae79c7b0cc4d
if counter > 20
md"""
Start real simulation! 👉 $(@bind real_simulation CheckBox())
"""
end

# ╔═╡ 435ce2aa-488f-42e1-b27f-4e92373c6b6a
if counter > 20
	if real_simulation
md"""
Let's study the autocorrelation! 👉 $(@bind do_acc CheckBox())
"""
end
end

# ╔═╡ e5aebcc2-6f45-4a30-a92b-1f4566e01947
if counter > 20
	if real_simulation
		if do_acc
md"""
Let's skip the correlated data points! 👉 $(@bind do_new CheckBox())
"""
		end
end
end

# ╔═╡ 9ffc5b26-e08c-48b9-a4da-b55c13c71319
begin

	hint(txt1,text)   = Markdown.MD(Markdown.Admonition("hint",txt1, [text]))		
	danger(txt1,text) = Markdown.MD(Markdown.Admonition("danger", txt1, [text]))
	note(txt1,text) = Markdown.MD(Markdown.Admonition("note", txt1, [text]))
	tip(txt1,text) = Markdown.MD(Markdown.Admonition("tip", txt1, [text]))
	hintx(txt1)   = Markdown.MD(Markdown.Admonition("hint",txt1, []))	
	dangerx(txt1) = Markdown.MD(Markdown.Admonition("danger", txt1, []))	
	notex(txt1) = Markdown.MD(Markdown.Admonition("note", txt1, []))	
	tipx(txt1) = Markdown.MD(Markdown.Admonition("tip", txt1, []))
	
	wrong = Markdown.MD(Markdown.Admonition("danger", "😞 sorry, not correct", []))	
	select = Markdown.MD(Markdown.Admonition("note","🤔 please select", []))	
	correct = Markdown.MD(Markdown.Admonition("beware", "👍 great  🏆", []))	
	md"### - admonitions"
end

# ╔═╡ 27a8af50-b9b6-4cf1-9075-e54617662e7a
if 0 < counter < 21
	tipx(
	"left panel: you see the current position (red dot) and the trial (green diamamod) and the posterior pdf. On top you see the step counter")
end

# ╔═╡ 2e6e1d6a-35d6-4f9d-ac63-3538adeb67f3
if 0 < counter < 21
	notex("right panel: vertical line: acceptance probability P_acc (red dot) and the uniform random number r (green dot and arrow). The trial is accepted if r < P_acc.
	On top you see the acceptance decision. The list gives the elements of the Markov chain"
	)
end

# ╔═╡ 5667ded2-1e9c-4a68-a3b2-750f3e09651e
if counter > 20
notex("We observe that the exact result (E(x) = 1.25) is far outside the two-sigma interval. 
		This is due to the fact that we started far away from the important region.
		We have to perform thermalization, i.e. ignore some initial steps.
			")
end

# ╔═╡ cf2effed-8eb2-42c1-b5ae-c40f4fd4c48e
if counter > 20 
	if real_simulation
		begin	
			II = [floor(Int64,N_step_max*0.1):N_step_max;]
			L_N = [1:length(II);]
			L_xsk = L_x[II]

			avg_sk = 	mean(L_xsk)
			ste_sk = 	2*std(L_xsk)/sqrt(length(L_xsk))
			txtsk = @sprintf("<x> = %8.3f ± %8.3f",avg_sk,ste_sk)
			tipx("after thermalization we obtain the MCMC result: $txtsk
			
				Now the mean looks ok, but the two-sigma uncertainty is stll to small
				That is because the MCMC data are correlated due to the small
				changes in each move
			")
		end
	end
end

# ╔═╡ 2f4b80af-fabf-459f-9104-8723c40bc96c
begin 
	function plot_steps()
	xx = [-1.5:0.01:2;] .+ 1
	plot1 = plot(xx,posterior(xx),label ="posterior",title = "step n = $(counter) ",ylim = (-.1, 3))
	
	plot1 = plot!([L_x[counter]],[posterior(L_x[counter])],marker = :dot,
		markersize = 5,label =L"x_n")
	plot1 = plot!([L_xt[counter]],[posterior(L_xt[counter])],marker = :diamond,
		markersize = 5,label =L"x_t",xlim = (-0.5,2.5))
	plot2 = plot([0.39,0.39],[0,1],linewidth = 2,xlim=(0.0,1.0),ylim = (0,1.1),label = false)
	plot2 = plot!([0.39],[L_p_acc[counter]],marker= :dot, markersize = 4, label = L"P_{acc}",legend=:bottomright)
		GR.setarrowsize(1.5)
		r = L_r[counter]
    plot2 = plot!([0.1,0.39],[r,r], marker =:circle, arrow=(:closed, 2.0),label = "r")
		if r < L_p_acc[counter]
			plot2 = plot!(title = L"r < P_{acc} \Rightarrow accepted")
		else
			plot2 = plot!(title = L"r < P_{acc} \Rightarrow rejected")
		end
		for i = 1: counter
				txt = @sprintf("x_%3.0d = %6.3f",i,L_x[i+1])
			plot2 = annotate!(.5, 1.1 - i*.04,text(txt, :red, :left, 8))
		end

		plot(plot1,plot2,layouit = (1,3))
		end


function plot_data()
	plot3 = plot(L_N,L_x[II],label="MCMC",title="10 % skipped")
	plot3 = plot!([1,N_step_max],[1.25,1.25],label="exact mean")
	running_mean = cumsum(L_xsk) ./ L_N
	plot3 = plot!([1:length(L_N);],running_mean,label="running mean")
end
	
	function acc_plot()
	L_ac = autocor(L_xsk,[1:floor(Int64,length(L_xsk)/2);]; demean=true)
	N_ac = length(L_ac)
	N_skip = findfirst(L_ac .< 0.1)

	plot_acc = 	plot([1:N_ac;],L_ac,marker = :dot, ylim=(-1,1),
		label="autocorrelation",
			title="autocorr. after thermalization for all elements",
		titlefontsize = 8
	)

	if N_skip == nothing
		N_skip = N_ac
	end
	plot_acc = plot!([N_skip,N_skip],[-1,1],label="autocorr-length = $(N_skip)")

	I =  [1:N_skip:length(L_xsk);]
	L_xpp = L_xsk[I]
	N_ac_pp  = length(L_xpp)
	L_ac_pp = autocor(L_xpp,[1:floor(Int64,N_ac_pp/2);]; demean=true)
	plot_acc2 = plot(L_ac_pp,marker = :dot, ylim=(-1,1),
		title="autocorr. always skipping $(N_skip) elements",
	titlefontsize=8,label=false)
	plotac = plot(plot_acc,plot_acc2)
	return plotac, N_skip, L_ac, L_xpp
	
end


	md"### - functions for plotting"
end

# ╔═╡ 7d678458-234b-456f-b26d-eda77abd087a
if counter == 0
	tipx("you can now perform individually the first 20 MCMC steps
		by repeatedly pressing the NEXT STEP button")
else
	if counter > 20
			x_avg = mean(L_x[1:20])
			x_ste = 2*sqrt(var(L_x[1:20]))/sqrt(20)
			txt = @sprintf("E(x) = %5.3f ± %5.3f",x_avg,x_ste)
			notex("from the first 20 steps we obtain: $txt")
	else
		plot(plot_steps())
end
end

# ╔═╡ dbfe7c71-cbe7-4808-b9c2-d820ca72ee59
if counter > 20
	if real_simulation
		plot4 = plot_data()
		plot(plot4)
	end
end

# ╔═╡ 5641e205-31f9-49b4-88a3-e4253f0000a6
if counter > 20 
	if real_simulation
	if do_acc
		plotac, N_skip, L_ac, L_xpp = acc_plot()
		plot(plotac)
	end
	end
end

# ╔═╡ 7acf8dc2-a215-4973-8ff7-a8235b69c71e
if counter > 20 
	if real_simulation
	if do_acc
		md"In the left panel after ignoring the first 10% for thermalization, the autocorrelation for all other data points is plotted.

We see that the autocorrelation is large for small lag, indicating correlation between successive steps.
		The autocorrelation length is set to the number of steps needed to have an acc less then 0.1.

Here, autocorrelation length = $(N_skip)
		"
	end
	end
end

# ╔═╡ 3f6daf82-ba74-4836-a5bf-0e48456bc890
begin	
	if counter > 20
		if real_simulation
			if do_acc
				if do_new
					
	avg = 	mean(L_xpp)
	ste = 	2*std(L_xpp)/sqrt(length(L_xpp))
    txtx = @sprintf("<x> = %8.3f ± %8.3f",avg,ste)
	md"if we always skip $(N_skip) steps then we obtain the MCMC result: $txtx
					
					Now everythings looks fine 😄👍👏
	"
										
				end
			end
		end
	end
end

# ╔═╡ Cell order:
# ╟─5ca51224-da81-4580-a385-561e6fd801d7
# ╟─3a500c66-fdb5-4610-820c-a869cccc387a
# ╟─7150c842-3c12-4b1b-b456-cc831b5d4f9f
# ╟─7d678458-234b-456f-b26d-eda77abd087a
# ╟─27a8af50-b9b6-4cf1-9075-e54617662e7a
# ╟─2e6e1d6a-35d6-4f9d-ac63-3538adeb67f3
# ╟─b0ef1450-312b-43da-ace8-b0d15697c42d
# ╟─5667ded2-1e9c-4a68-a3b2-750f3e09651e
# ╟─edf2f357-b73f-42e7-ab41-ae79c7b0cc4d
# ╟─dbfe7c71-cbe7-4808-b9c2-d820ca72ee59
# ╟─cf2effed-8eb2-42c1-b5ae-c40f4fd4c48e
# ╟─4620e8bd-a5c9-4f37-8139-d5957a9a9f14
# ╟─435ce2aa-488f-42e1-b27f-4e92373c6b6a
# ╟─5641e205-31f9-49b4-88a3-e4253f0000a6
# ╟─7acf8dc2-a215-4973-8ff7-a8235b69c71e
# ╟─e5aebcc2-6f45-4a30-a92b-1f4566e01947
# ╟─0b51a7d4-5a66-43bc-9755-eb7c29bc8606
# ╟─3f6daf82-ba74-4836-a5bf-0e48456bc890
# ╟─583ad6aa-7bf1-4c59-bcff-bc3548b2bce6
# ╟─40d8dcc5-2f27-46aa-9391-95155fc9850c
# ╟─cda88397-7aa4-4fc8-b8b5-3823f41a6e8e
# ╟─f06a9996-0be1-4542-9c23-b6d1b00077fc
# ╟─2f4b80af-fabf-459f-9104-8723c40bc96c
# ╟─0646e617-6fd3-4249-9f60-c130d9b48a6e
# ╟─03b75df2-b63b-11eb-31ea-51aedea29d36
# ╟─9ffc5b26-e08c-48b9-a4da-b55c13c71319
