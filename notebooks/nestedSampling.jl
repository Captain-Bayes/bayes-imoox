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

# ╔═╡ 53cbed91-a234-4e33-95c0-9b4a750c39ba
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
		md""" 
		### - Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
end

# ╔═╡ 36ebbc95-ca82-4e64-978c-7b51d0cd61ee
TableOfContents(aside = true)

# ╔═╡ b2ef74b7-fa8f-4647-a48c-8177395f55b2
md"# Nested Sampling 🎯

The goal of nested sampling is the evaluaiton of high-dimensional integrals of the form

$I = \int dV_{\vec x} f(\vec x)  p(\vec x)\;,$

where $p(\vec x)$ is the prior pdf.

As a simple example to illustrate the algorithm we use a 1D problem with uniform prior and 

$f(x) = \exp\bigg(-\frac{(x -x_1)^2}{2 \sigma_1^2}\bigg) + 1.5\; \exp\bigg(-\frac{(x -x_2)^2}{2 \sigma_2^2}\bigg)$

The exact result is $I = \sqrt{2 \pi \sigma_1^2} + 1.5\; \sqrt{2 \pi \sigma_2^2}$
## - Follow the algorithm step by step 🕵🏻‍♀️"

# ╔═╡ 93315217-1dd9-4a50-abeb-ef5ad5cf44ef
md"## - Check the integral"

# ╔═╡ 4659617d-b2ae-4e08-94e6-3ef71bcbf48e
md"# Auxiliary stuff"

# ╔═╡ fc692905-354b-4519-8956-f340b83ad661
md"""
## About the creators

This notebook was created by **Prof. Wolfgang von der Linden** and **Gerhard Dorn** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ 54e74311-1892-4120-b58f-e2cf0dc28016

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
	


# ╔═╡ 98567be3-d02e-4b32-b760-e25bd185c8d5
begin
	md"""$(@bind counter ClickCounterWithReset("NEXT STEP", "RESET"))"""
	#md"""Increase the steps 👉$(@bind counter NumberField(0:40; default=0))"""
	
end

# ╔═╡ 2f3bb4ef-2239-4617-b9fd-f6cffd0653e4
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

# ╔═╡ de042b85-4f4d-447f-8ec3-8406ca031718
begin
	x0 = 0.0
	𝜎_1  = 0.2
	𝜎_2  = 0.1
	f_𝜎_1 = 1/(2*𝜎_1^2)
	f_𝜎_2 = 1/(2*𝜎_2^2)	

	
	x_max = 2
	Nclim = 30 # number of single steps

	Ω = x_max 	
	
	
	

	md"### - initial values"
end

# ╔═╡ 627e437a-c271-4098-920e-12becf65b79c
begin
	flag_integral_checkbox = @bind flag_integral CheckBox()
	flag_prior_mass_checkbox = @bind flag_prior_mass CheckBox()
	seed_2_slider = @bind seed2 Slider(1:200, show_value=true,default=123)
	N_wi_slider = @bind N_wi Slider(1:200, show_value=true,default=100)
	md"### - Checkboxes and Sliders"
end

# ╔═╡ 7007f520-b514-456a-a2b3-70d8611b2f48
if counter > Nclim
	md"""
	Start testing the constraint prior mass distribution! 👉 $(flag_prior_mass_checkbox)
	"""
end

# ╔═╡ a7bb1c76-97e2-4c79-8928-99b173ce0f6d
if counter > Nclim && flag_prior_mass 
  md"   
	here you see the histogram of the distribution of the prior masses of the n-th step for n=1,...,6 in the a NESA run
	To this end, the initial n-steps of NESA are performed and f_n computed.
	From f_n the prior mass X_n is computed analytically (which is possible in this simple example)
	
$X_n = \int dx \;p(x) \;\theta(f(x) > f_n)$
	
	The NESA runs are performed repeatedly and histograms of X_n are ploted
	"
end

# ╔═╡ 0816fdd9-c529-48e1-8c31-40e4a700240e
if counter > Nclim && flag_prior_mass 
  md"   
The numerically obtained histogram is compared with the exact pdf, obtained from 
	order statistics

$p(X) = \frac{{\cal N}^n}{\Gamma(n)} \ln(X)^{n-1} X^{{\cal N}-1}$
	
number of walkers: ${\cal N}$
	"
end

# ╔═╡ b9c105d5-d296-4a57-8bc0-5294081dbba7
if counter > Nclim && flag_prior_mass
	md"the red vertical line depicts the mean of $<X_n> = (\frac{N}{N+1})^n$ that enters the computation of the Riemann sum
	"
end

# ╔═╡ 246d932a-5d4d-4628-bf5a-a2ac848779ec
if counter > Nclim && flag_prior_mass
	tipx("We find very good agreement 👍👏🏆 and can be convinced that NESA works	")
end

# ╔═╡ 585cb5a1-7276-4c82-8609-e6637166d048
if counter > Nclim && flag_prior_mass
	hintx("Next we want to see whether it also gives the right answer for the integral")
end

# ╔═╡ 1166b1ba-f08c-43cf-9ef1-19e664c3233f
if counter > Nclim && flag_prior_mass
	md"""
See, how the NESA integration performs?  👉 $(flag_integral_checkbox)
	"""
end

# ╔═╡ cf0f3b29-f601-4776-acd8-0f4a809819e4
if counter > Nclim && flag_integral
md"We use the formula $int = \sum_{n=1}^{\infty} f_n (X_{n-1}-X_{n})$

where we use that once $f_n$ does not change anymore the remainings sum can be summed by the geometric series.
"
end

# ╔═╡ 75fbf125-14e1-483a-8c8d-996166703057
if counter > Nclim && flag_integral
md"seed of the random number generator   $(seed_2_slider)
 _with a new seed you get a new sample_"
end

# ╔═╡ 026c059e-eaf9-479b-a8a4-ca44c3b60b1e
if counter > Nclim && flag_integral
md"number of walkers N   $(N_wi_slider)"
end

# ╔═╡ d1dbd77c-caaf-4e1c-b691-5f1ba201e21d
begin
	function likelihood(x,f_𝜎_1,f_𝜎_2)
		y1 = exp.(-f_𝜎_1 .* (x .- 1.0).^2) 
		y2 = exp.(-f_𝜎_2 .* (x .- 1.5).^2) 	
		return y1 .+ 1.5 .* y2
	end
	md"### - likelihood function"
end

# ╔═╡ dc7a78e0-3b84-4ee0-9db4-c5670183857a

#=
begin
N_steps = 100
N_w = 10

function one_run(N_steps,N_w,f_𝜎_1,f_𝜎_2)

	del = 0.05
	L_f_min = zeros(N_steps)
	L_x_min = zeros(N_steps)	

	L_x_pos = rand(rng,N_w) .* 2
	L_f_pos = likelihood(L_x_pos,f_𝜎_1,f_𝜎_2)
	ind     = argmin(L_f_pos)

	
	L_f_min = zeros(N_steps)
	L_x_min = zeros(N_steps)	
	L_f_new = zeros(N_steps)
	L_x_new = zeros(N_steps)		
	
	
	for i = 1: N_steps
		M_x_pos[i,:] = L_x_pos
		M_f_pos[i,:] = L_f_pos	

		
		f_thresh  = L_f_pos[1]  
		L_f_min[i] = f_thresh
		L_x_min[i] = L_x_pos[1]
		it = rand(rng,2:N_w)
		xt0 = L_x_pos[it]
		xt  = xt0 + del*randn(rng)
		ft  = likelihood(xt,f_𝜎_1,f_𝜎_2)
		while ft < f_thresh
			xt  = xt0 + del*randn(rng)
			ft  = likelihood(xt,f_𝜎_1,f_𝜎_2)
		end
		L_f_pos[1] = ft
		L_x_pos[1] = xt
		ind     = sortperm(L_f_pos)
		L_x_pos = L_x_pos[ind]
		L_f_pos = L_f_pos[ind]
		L_x_new[i] = xt
		L_f_new[i] = ft		
	end

end
end
=#

# ╔═╡ c0ce8108-4a56-4157-b180-d52c61e20964
begin
	function one_run(N_steps,N_w,f_𝜎_1,f_𝜎_2,x_max,rng)

		N_step_max = 1000	# for constraint prior sampling

		L_f_min = zeros(N_steps)
		L_x_pos = rand(rng,N_w) .* x_max
		L_f_pos = likelihood(L_x_pos,f_𝜎_1,f_𝜎_2)

		L_f_min = zeros(N_steps)
		let

		for i = 1: N_steps
			del        = std(L_x_pos)*10
			ind_min    = argmin(L_f_pos)
			f_thresh   = L_f_pos[ind_min]
			L_f_min[i] = f_thresh
			it 		   = rand(rng,1:N_w)
			while it == ind_min
				it = rand(rng,1:N_w)
			end
			xt0 = L_x_pos[it]

			for j = 1: N_step_max
				global xt  = xt0 + del*randn(rng)
				global ft  = likelihood(xt,f_𝜎_1,f_𝜎_2)
				if ft > f_thresh
					break
				end
			end	
			L_f_pos[ind_min] = ft
			L_x_pos[ind_min] = xt
		end
		end	
		return L_f_min
	end
	
	function trial_step(N_iter_max,xt0,f_thresh,del, rng)
		xt = 0.
		ft = 0.
		for j = 1: N_iter_max
			xt  = xt0 + del*randn(rng)
			ft  = likelihood(xt,f_𝜎_1,f_𝜎_2)
			if ft > f_thresh
				break
			end
		end	
		return xt, ft
	end
	md"### - some subroutines"
end

# ╔═╡ 7822f358-dbc7-461d-948b-8c5b60d4a59f
begin
	seed = 135
	rng   = MersenneTwister(seed) 
	let
		L_x = [0.0:.01:2.0;]
		L_y = likelihood(L_x,f_𝜎_1,f_𝜎_2)
	
		N_iter_max = 100
		
		N_steps = 100
		global N_w     = 10


		 L_f_min = zeros(N_steps)
		 L_x_min = zeros(N_steps)	

		 L_x_pos = rand(rng,N_w) .* x_max
		 L_f_pos = likelihood(L_x_pos,f_𝜎_1,f_𝜎_2)

		 M_x_pos = zeros(N_steps,N_w)
		 M_f_pos = zeros(N_steps,N_w)	

		 L_f_min = zeros(N_steps)
		 L_x_min = zeros(N_steps)	
		 L_f_new = zeros(N_steps)
		 L_x_new = zeros(N_steps)	
		
		for i = 1: N_steps
			ind_min    = argmin(L_f_pos)
			M_x_pos[i,:] = L_x_pos
			M_f_pos[i,:] = L_f_pos	

			del        = std(L_x_pos)*10

			f_thresh   = L_f_pos[ind_min]
			L_f_min[i] = f_thresh
			L_x_min[i] = L_x_pos[ind_min]			
			it 		   = rand(rng,1:N_w)
			while it == ind_min
				it = rand(rng,1:N_w)
			end
			xt0 = L_x_pos[it]
		
			xt, ft = trial_step(N_iter_max,xt0,f_thresh,del, rng)



			L_x_pos[ind_min] = xt			
			L_f_pos[ind_min] = ft
			L_x_new[i] = xt
			L_f_new[i] = ft							
		end
		
		# Plot 1
		
		
		
		global plot1
		if 0 < counter
				plot1 = plot(L_x,L_y, label = false)

				plot1 = plot!(title = @sprintf("n = %3.0d, N_walker = %3.0d",counter,N_w))		
				plot1 = plot!(M_x_pos[counter,:],M_f_pos[counter,:],
					seriestype = :scatter,markercolor = :green, marker = :dot, label = false)
				x_rej = L_x_min[counter]
				f_rej = L_f_min[counter]

				plot1 = plot!([x_rej],[f_rej],
					seriestype = :scatter,markercolor = :red, marker = :x,
					markersize = 8, label = false)
				x_new = L_x_new[counter]
				f_new = L_f_new[counter]		
				plot1 = plot!([x_new],[f_new],
					seriestype = :scatter,markercolor = :red, marker = :dot,
					markersize = 8, label = false)	

				plot1 = plot!([x_new,x_new],[f_new+.2,f_new+.05], 
					arrow=(:closed, 4.0),label =  false)
				plot1 = annotate!(x_new,f_new+.3,"added")

				plot1 = plot!([x_rej+.2,x_rej+0.05],[f_rej,f_rej], 
					arrow=(:closed, 4.0),label =  false)	
				plot1 = annotate!(x_rej+0.3,f_rej,"discarded",
				xlim = (0.,2.6),
				ylim = (-.2,2.9))
				plot1 = plot!([0,2.0],[0,0],color=:black,label=false)		

				plot1 = annotate!(2.08,3.1 ,text(latexstring("n \\ \\qquad   f_n \\qquad \\qquad X_n"),:left,8))

				plot1 = annotate!(2.05,2.95, text(@sprintf("%2.0d)   %8.4f   %8.4f",0,0.0,1.0),:left,7))


				for m = 1:counter
					plot1 = annotate!(2.05, 2.95 - m * 0.1 ,text(@sprintf("%2.0d)   %8.4f   %8.4f",m,L_f_min[m],(N_w/(N_w+1))^m),:left,7))
				end 

		end
	end


	md"### - prepare data for single step mode"
	
end

# ╔═╡ a3528065-dfa6-4cad-8080-c188583f638a

begin

	if counter == 0
		tipx("you can now perform individually the first $(Nclim) NESA steps
		by repeatedly pressing the NEXT STEP button")
		
	elseif counter ≤ Nclim 
		
		plot(plot1,size=(600,400))

	else
		hintx("Now that you know how NESA works, let's check whether the constraint prior mass has the assumed properties")
	end
	
	
end

# ╔═╡ 311a6427-767b-49f3-af28-0903116ecc98
begin
	# details for constraint prior mass test
	let
	L_x_X = [0.0:.00001:x_max;]
	N_x_X = length(L_x_X)
	L_y_X = likelihood(L_x_X,f_𝜎_1,f_𝜎_2)
	

	n_hist = 6
	N_rep  = 1000
	N_wh    = 40
	L_hist = zeros(N_rep,n_hist)
	
	for i = 1: N_rep
		L_fh = one_run(n_hist,N_wh,f_𝜎_1,f_𝜎_2,x_max,rng)
		L_Xh = [sum(L_y_X .> L_fh[j])/N_x_X for j = 1: n_hist]
		L_hist[i,:] = L_Xh
	end

	L_plot = Vector{Any}(undef,n_hist)
	L_mean = zeros(n_hist)

	for n = 1: n_hist
		h = fit(Histogram, L_hist[:,n], nbins=40)
		r = h.edges[1]
		local x = first(r)+step(r)/2:step(r):last(r)
		hh = h.weights./sum(h.weights)
		plotx = plot(x, hh, seriestype = :scatter,
		marker=:dot,
		markersize = 2,
		label = false
		)

		p = ((log.(x)).^(n-1)) .* x.^(N_wh-1)
		p = p/sum(p)
		plotx = plot!(x,p,
			legendfont = 6,
			label = false,
			xaxis = ("X", (0,1.1),0:0.5:1,font(6, "Verdana")),
			yaxis = ("p(X)", (0,.16),0:0.1:0.2,font(6, "Verdana")),
			)

		plotx = annotate!(.2,0.14,text("n=$(n)", :left, 8))
		avg = (N_wh/(N_wh+1))^n
		plotx = plot!([avg,avg],[0,2],color=:red,linewidth = 2)
		L_plot[n] = plotx
		
       L_mean[n] = sum(x.*p)
	end


	global plot2 = plot(L_plot...)
	end
	md"## - Check the constraint prior mass distribution"
end

# ╔═╡ 9ecef464-1a0d-4830-8d27-7de069e11380
if counter > Nclim && flag_prior_mass 
	plot(plot2,size = (600,600))
end

# ╔═╡ 5a5a20be-cc27-4f06-a2ee-ffff9a4a59a2
begin
	if counter > Nclim && flag_integral
	rng2   = MersenneTwister(seed2) 
	N_stepsi = 1000
	N_repi   = 100
	L_ni = [0:N_stepsi-1;]
	L_dX_mean = (1/(N_wi+1)) .* (N_wi/(N_wi+1)) .^ L_ni
	L_int = zeros(N_repi)

	for i = 1: N_repi
		L_fa = one_run(N_stepsi,N_wi,f_𝜎_1,f_𝜎_2,x_max,rng2)
		L_sumand = L_fa .* L_dX_mean
		int_nesa_1 = Ω *sum(L_sumand)
		L_int[i]  = int_nesa_1 + Ω * L_fa[end] * (N_w/(N_w+1)) ^ N_stepsi
	end

	int_ex = sqrt(2*π*𝜎_1^2) + 1.5 * sqrt(2*π*𝜎_2^2)
	L_int  = L_int ./ int_ex

	L_avg = zeros(N_repi)
	L_ste = zeros(N_repi)
	for i = 1: N_repi
		L_aux    = L_int[1:i]
		L_avg[i] = mean(L_aux)
		L_ste[i] = 2*std(L_aux) / sqrt(i)
	end
	L_ste[1] = 0.1

	L_n   = [1:N_repi;]
	ploti = plot(L_n,L_int, 
	seriestype = :scatter,
	marker = :dot,
	ylim = (0.5,1.5),
	label = latexstring("\\mathrm{nesa \\ data}")
	)

	ploti = plot!(L_n,L_avg,
	ribbon = L_ste,
	linewidth = 2,
	label = latexstring("\\mathrm{mean\\ and \\ 2 \\sigma \\ uncertainty}")
	)
txtx = @sprintf("N walker = %3.0d",N_wi)
	ploti  = plot!([0,N_repi],[1,1],color = :black,
	label  = latexstring("\\mathrm{exact}"),
	xlabel = latexstring("\\mathrm{no. \\ of\\ repeated \\ nesa \\ runs}"),
	ylabel = latexstring("\\mathrm{integral}"),
	title = txtx,
	titlefont = 8
			)

end

end

# ╔═╡ 38257648-8beb-49c1-9c7c-11204cb6cd08
if counter > Nclim && flag_integral
	txt = @sprintf("int_nesa/int_exact = %8.3f ± %8.3f (2σ)" ,mean(L_int),std(L_int)/sqrt(N_repi))
	md"The numerical result yields:     $txt"
end

# ╔═╡ Cell order:
# ╟─36ebbc95-ca82-4e64-978c-7b51d0cd61ee
# ╟─b2ef74b7-fa8f-4647-a48c-8177395f55b2
# ╟─98567be3-d02e-4b32-b760-e25bd185c8d5
# ╟─a3528065-dfa6-4cad-8080-c188583f638a
# ╟─7007f520-b514-456a-a2b3-70d8611b2f48
# ╟─311a6427-767b-49f3-af28-0903116ecc98
# ╟─a7bb1c76-97e2-4c79-8928-99b173ce0f6d
# ╟─0816fdd9-c529-48e1-8c31-40e4a700240e
# ╟─9ecef464-1a0d-4830-8d27-7de069e11380
# ╟─b9c105d5-d296-4a57-8bc0-5294081dbba7
# ╟─246d932a-5d4d-4628-bf5a-a2ac848779ec
# ╟─93315217-1dd9-4a50-abeb-ef5ad5cf44ef
# ╟─585cb5a1-7276-4c82-8609-e6637166d048
# ╟─1166b1ba-f08c-43cf-9ef1-19e664c3233f
# ╟─cf0f3b29-f601-4776-acd8-0f4a809819e4
# ╟─75fbf125-14e1-483a-8c8d-996166703057
# ╟─026c059e-eaf9-479b-a8a4-ca44c3b60b1e
# ╟─5a5a20be-cc27-4f06-a2ee-ffff9a4a59a2
# ╟─38257648-8beb-49c1-9c7c-11204cb6cd08
# ╟─4659617d-b2ae-4e08-94e6-3ef71bcbf48e
# ╟─fc692905-354b-4519-8956-f340b83ad661
# ╟─54e74311-1892-4120-b58f-e2cf0dc28016
# ╟─2f3bb4ef-2239-4617-b9fd-f6cffd0653e4
# ╟─53cbed91-a234-4e33-95c0-9b4a750c39ba
# ╟─de042b85-4f4d-447f-8ec3-8406ca031718
# ╟─627e437a-c271-4098-920e-12becf65b79c
# ╟─d1dbd77c-caaf-4e1c-b691-5f1ba201e21d
# ╟─7822f358-dbc7-461d-948b-8c5b60d4a59f
# ╟─dc7a78e0-3b84-4ee0-9db4-c5670183857a
# ╟─c0ce8108-4a56-4157-b180-d52c61e20964
