### A Pluto.jl notebook ###
# v0.15.1

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

# ╔═╡ e7666210-a660-11eb-3e0d-7d9aec9a9f9e
begin
	try
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
		using Random
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
		Pkg.add("Random")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		#Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		#Pkg.add("Distributions")
		using PlutoUI, Plots, LaTeXStrings, Markdown, Images, Plots.PlotMeasures, Random
		#using LinearAlgebra
		#using SparseArrays
		#using StatsBase
		#using Random
		md""" 
		### Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
end

# ╔═╡ ec784992-f4af-4ece-bf72-555960a054ca
html"""<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/ABbv9g5kTdI" width=600 height=375  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>"""

# ╔═╡ 8f919de1-356f-4e42-9f7e-5d29092ed80f
md"""
## Bayesian reasoning

The lighttower located at the unknown coordinates $(a|b)$ randomly emits light in all polar directions $\varphi$ measured to the perpendicular to the beach. The light hits the beach if the angle $\varphi$ of emitted light is in the interval $\varphi \in [-\pi/2, \pi/2]$. See the sketch below for a detailed definition of the used variables.

The location $x$ on the beach is given by 

$x = \tan(\varphi)\cdot b + a$


"""

# ╔═╡ fd94fab8-c4c4-454e-9f5b-c0f1178143b3
begin
md"""
## Derivation of the Likelihood and Posterior
So let's derive the Likelihood to spot a flash on the coastline position ``x``:

We know, that the lightsource 🔦 of the lighthouse is constantly rotating so all angles are equally probable independent of the actual position of the lighthouse:
	
``p(\varphi|a,b) = p(\varphi) = \frac{1}{2\pi}``
	
Then we know the relation between angle (``\varphi``), position of the lighthouse ``(a,b)`` and the coastline position ``x`` to spot a flash on the beach:
	
``x = a + b \cdot \tan(\varphi), \quad ``  for  ``\varphi \in [-\pi/2, \pi/2]``
	
So we are looking for the probability
	``p(x|a,b)``
	and can use the transformation law:
	
$p(x|a,b) = p\big(\varphi(x)|a,b\big) \cdot \left\lvert \frac{d\varphi(x)}{dx}\right\rvert$

With ``\frac{d\varphi(x)}{dx} = \frac{b}{b+(x-a)^2}`` and ``p(\varphi(x)) = \frac{1}{\pi}`` (we have to restrict the angle of ``\varphi`` to the halfplane to hit the coastline) we obtain the following Likelihood:

$p(x|a,b) = \frac{1}{\pi} \frac{b}{b^2 + (x-a)^2}$
	

For the posterior

$p(a,b|x) = \frac{1}{Z} p(x|a,b) \cdot p(a,b)$
	
we can assume a flat prior ``p(a,b)``.
	
"""
	
	
end

# ╔═╡ d3f023b1-8a57-4690-b8d6-afbe2ff50d5e
begin
	
	a_slider = @bind a Scrubbable(-4:0.1:4, default= 1)
	b_slider = @bind b Scrubbable(0.1:0.1:4, default= 3)
	phi_slider = @bind φ Scrubbable(-pi/2:pi/120:pi/2, default= -3*pi/10)
	
	fix_beach_box = @bind fix_beach CheckBox()
	
	flashes = @bind generate_flash Button("Generate Flashes")
	
	md""" 
	## The program
	### Define sliders and general checkboxes and buttons
	"""
end

# ╔═╡ 3c1cc3af-11f9-44ac-b07f-69704c4841c4
md"""
Angle of the emitted light ``\varphi``: $(phi_slider)

Horizontal distance of the lighthouse from the origin ``a``: $(a_slider)

Perpendicular distance of the lighthouse from the coastline ``b``: $(b_slider)

Fix beach length 👉 $(fix_beach_box)
"""

# ╔═╡ ed56b559-ea17-41c7-8fe5-6ae9440fd5b5
begin
	rng = MersenneTwister(42)
	md" ### Define random number seed"
	
end

# ╔═╡ b2dc9f9b-9f57-4ca8-82ef-9c6a3915d6d0
begin
	a
	b
	φ
	show_flash_box = @bind show_flashes CheckBox()
	md" ### CheckBox show flash (with reset)"
end

# ╔═╡ 656ac69b-4cf5-440b-a894-83a7a80f42f0
begin
	a
	b
	φ
	show_calculation_box = @bind show_calculation CheckBox(default=false)
	md" ### Define start calculation Checkbox"
end

# ╔═╡ a61337a8-e197-4a7b-817d-012a5c1c0f17
begin
	generate_flash
	rand_phi = (rand(rng,100) .- 0.5) * pi
	
	x_new = tan.(rand_phi).*b .+ a
	
	md" ### Generate new sample of flash points"
	
end

# ╔═╡ 51b1234a-9808-4dad-a588-f61db077767f
begin 
	range_a = -5:0.01:5
	range_b = 0.1:0.01:5
	
	p = zeros(length(range_b), length(range_a))
	lighttower = (0,0)
	
	if show_calculation
		for i = 1:length(range_a), j=1:length(range_b)
			a_temp = range_a[i]
			b_temp = range_b[j]

			p[j,i] = 1/pi * prod(b_temp ./(b_temp^2 .+ (x_new .- a_temp).^2))
		end
		p = p./sum(p);
	end
	
	index = findall(p .== maximum(p))[1]
	lighttower = (range_a[index[2]], range_b[index[1]])
	
	md""" ### Calculation of the Likelihood"""
end

# ╔═╡ b8942536-020b-4c8e-a875-b5aba3034d42
begin
	#a = 1
	
	x = a+b*tan(φ)
	if fix_beach
		beach_length = 10
	else
		beach_length = maximum([4, abs(x)])
	end
	a_dist = abs(a) > 0.10 ? 0.05 : 0
	a_dist_y = 0.15
	b_dist = beach_length/30
	# plot light ray
		plot([x,a], [0,b], linestyle = :solid, linewidth = 2, color = :yellow, label=false, 
	size = (640,320),
		labelfontsize = 15,
		tickfontsize = 13,
		legendfontsize = 11,
		bottom_margin =5mm,
		left_margin = 5mm,
		right_margin = 5mm,
		titlefontsize = 12,
		#foreground_color_grid = :black,
		#foreground_color_xticks = :black,
		background_color = :transparent,
		#foreground_color_axis = :black,
		#foreground_color_text = :black,
		#foreground_color_border = :black,
		foreground_color = :black,
		fontfamily="Computer Modern")
	plot!([x,a], [0,b], linestyle = :dash, linewidth = 2, color = :yellow3, label="Light")
	# plot beach
	
	plot!([-beach_length,beach_length], [0,0], color = :black, linewidth = 3, label=false, ylim=[0,4])
	# plot perpendicular
	plot!([a,a], [0,b], color=:black, linewidth = 2, linestyle = :dash,label = false)
	# plot lighthouse
	plot!([a], [b], markercolor=:red, marker=:o,linealpha = 0,markersize = 8, label="Lighttower")
	# plot distance b
	plot!(b_dist .+ [a,a,NaN,a,a], [a_dist_y,b-a_dist_y,NaN,b-a_dist_y,a_dist_y], color = :red, linewidth = 2.5, linestyle = :solid, label="\$b\$",arrow = true)
	annotate!(a+2*b_dist, b/2,text("\${b}\$", :red))
	#plot distance a
	plot!([sign(a)*a_dist,a-sign(a)*a_dist, NaN,a-sign(a)*a_dist,sign(a)*a_dist], [a_dist_y,a_dist_y, NaN, a_dist_y,a_dist_y], color=:green, linewidth = 2.5, linestyle = :solid, label= "\$a\$", arrow = true)
annotate!((a+b_dist/2)/2,2*a_dist_y,text("\${a}\$", :green, :center))

 	# plot varphi
varphi = atan((x-a)/b)
pl_angle =sign(varphi).* (0:0.01:abs(varphi))
rad = 1

	annotate!(a + sin(varphi/2)*2*rad/3, b-cos(varphi/2)*2*rad/3,"\$\\varphi\$")

plot!([a .+ sin.(pl_angle)*rad], [b.-cos.(pl_angle)*rad], label =false)
	
	# plot x
	annotate!(x,-2*a_dist_y, "\$x\$")
	
	if show_flashes
		plot!(x_new, zeros(size(x_new)), marker= :o, color = :orange,markeralpha = 0.4, linealpha = 0, label= "Flashes")
	end
	if show_calculation
	heatmap!(range_a, range_b, p, alpha = 0.4,
	title="The lighttower is most likely located at "*string(lighttower))
	end
	
	plot!([x,x], [-a_dist_y, a_dist_y]./2, linewidth = 3, color= :black, label = false, xlim = [-beach_length, beach_length])
	
	
	
end

# ╔═╡ ca076585-03b6-4381-b730-e32c7a30446e
if show_calculation
	heatmap(range_a, range_b, p, 
	title="The lighttower is most likely located at "*string(lighttower),   colorbar_ticks = (0, "0"))
	#clim=(0,0.00006)
end

# ╔═╡ 16938d4f-6f25-4924-8bdf-b0eb638a6c4f
begin
	claire = "https://raw.githubusercontent.com/Captain-Bayes/images/main/claire_100px.gif"
	makabe = "https://raw.githubusercontent.com/Captain-Bayes/images/main/makeba_100px.gif"
	bayes = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bayes_100px.gif"
	bernoulli = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Bernoulli_wet.gif"
	island = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Turtle_island_with_ship.png"
	map = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Fishground_map.png"
	frogfish_image = "https://raw.githubusercontent.com/Captain-Bayes/images/main/frogfish_green_full.gif"
	venn = "https://raw.githubusercontent.com/Captain-Bayes/images/main/venn_100px.gif"
	angles_view = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Gipfel_angles.png"
	mountain_view = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Gipfel_view.png"
	image_of_data = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Daten_brett.png"
	diagram_of_data = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Diagram.png"
	treasure_map = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Treasure_map_2.png"
	lighthouse_image = "https://raw.githubusercontent.com/Captain-Bayes/images/main/lighthouse_problem_draft.png"
	lighthouse_gif = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Lighthouse.gif"
	lyra = "https://raw.githubusercontent.com/Captain-Bayes/images/main/lyra_100px.gif"
	
	md"""Images"""
end

# ╔═╡ 6c070606-1411-40fc-b6cd-8f27f052136b
md"""
# The lighthouse problem
$(Resource(lighthouse_gif, :width=>600))

$(Resource(lyra, :width=>150))
> *It tell you from my observations I know, there must be a lighthouse somewhere over the sea. Have a look at my data!*


> *Watch the **video** below for the full story:*

"""
#$(Resource(treasure_map, :width=>500))


# ╔═╡ 5fc032bb-990d-424e-a256-ef2979980606
begin 
	xx =  [4.73,  0.45, -1.73,  1.09,  2.19,  0.12,  1.31,  1.00,
                     1.32,  1.07,  0.86, -0.49, -2.59,  1.73,  2.11,  1.61,
                     4.98,  1.71,  2.23,-57.20,  0.96,  1.25, -1.56,  2.45,
                     1.19,  2.17,-10.66,  1.91, -4.16,  1.92,  0.10,  1.98,
                    -2.51,  5.55, -0.47,  1.91,  0.95, -0.78, -0.84,  1.72,
                    -0.01,  1.48,  2.70,  1.21,  4.41, -4.79,  1.33,  0.81,
                     0.20,  1.58,  1.29, 16.19,  2.75, -2.38, -1.79,  6.50,
                   -18.53,  0.72,  0.94,  3.64,  1.94, -0.11,  1.57,  0.57]
	
	
md"""
## The data: 
$(Resource(lyra, :width=>140))
	
*Click on the Checkbox 👉 $(show_flash_box) to see the position of the 100 flashes which I recorded. You can start a new observation by pressing the Button $(flashes)*.
	
> *Captain Bayes, can you help me to find the position of the lighthouse?*	
	"""
end

# ╔═╡ 6dd8c883-dac4-4a31-b5ae-09ec067ba852
begin 
	
	md"""
	$(Resource(bayes, :width=>200))
	*For sure Lyra, below you can find the __derivation__ how I perform this calculation.*
	
	*Just tick the checkbox to __start the calculation__ 👉 $(show_calculation_box)*
	"""
	
	
end

# ╔═╡ 7bf32131-f749-41da-9923-2970f1487f7e
begin
almost(text, headline=md"Almost there!") = Markdown.MD(Markdown.Admonition("warning", string(headline), [text]));
#brown
	
correct(text=md"Great! You got the right answer!", headline=md"Got it!") = Markdown.MD(Markdown.Admonition("correct", string(headline), [text]));
#green
	
	
keep_working(text=md"The answer is not quite right.", headline=md"Keep working on it!") = Markdown.MD(Markdown.Admonition("danger", string(headline), [text]));
#red
	
hint(text, headline=md"Hint") = Markdown.MD(Markdown.Admonition("hint", string(headline), [text]));
#blue
	
md"definition of boxes"
end

# ╔═╡ 5d349d39-c688-4431-b056-aa11d69376e9
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


# ╔═╡ 1760c093-96c9-4ed9-8f4d-2c2ff3bfda5c
TableOfContents()

# ╔═╡ Cell order:
# ╟─6c070606-1411-40fc-b6cd-8f27f052136b
# ╟─ec784992-f4af-4ece-bf72-555960a054ca
# ╟─8f919de1-356f-4e42-9f7e-5d29092ed80f
# ╟─3c1cc3af-11f9-44ac-b07f-69704c4841c4
# ╟─b8942536-020b-4c8e-a875-b5aba3034d42
# ╟─5fc032bb-990d-424e-a256-ef2979980606
# ╟─6dd8c883-dac4-4a31-b5ae-09ec067ba852
# ╟─ca076585-03b6-4381-b730-e32c7a30446e
# ╟─fd94fab8-c4c4-454e-9f5b-c0f1178143b3
# ╟─d3f023b1-8a57-4690-b8d6-afbe2ff50d5e
# ╟─ed56b559-ea17-41c7-8fe5-6ae9440fd5b5
# ╟─b2dc9f9b-9f57-4ca8-82ef-9c6a3915d6d0
# ╟─656ac69b-4cf5-440b-a894-83a7a80f42f0
# ╟─a61337a8-e197-4a7b-817d-012a5c1c0f17
# ╟─51b1234a-9808-4dad-a588-f61db077767f
# ╟─e7666210-a660-11eb-3e0d-7d9aec9a9f9e
# ╟─16938d4f-6f25-4924-8bdf-b0eb638a6c4f
# ╟─7bf32131-f749-41da-9923-2970f1487f7e
# ╟─5d349d39-c688-4431-b056-aa11d69376e9
# ╟─1760c093-96c9-4ed9-8f4d-2c2ff3bfda5c
