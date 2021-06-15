### A Pluto.jl notebook ###
# v0.14.8

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
		using PlutoUI, Plots, LaTeXStrings, Markdown, Images, Plots.PlotMeasures
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

# ╔═╡ 7127d313-c9a3-4206-bae7-ac7fc9fbe514
md"""
# TO BE FINISHED! WORK IN PROGRESS 🚧
"""

# ╔═╡ fd94fab8-c4c4-454e-9f5b-c0f1178143b3
begin
md"""
``P(x| a,b,\varphi)``
	
``P(a,b|\vec x) = \dfrac{P(\vec x| a,b) \cdot P(a,b)}{P(\vec x)}``
	
"""
	
	
end

# ╔═╡ 161bdcd4-55ac-4869-91bd-0141d0fc72db
begin 
	Lin_1 = @bind lin_1 Scrubbable(-2:0.01:2, default=-1, format=".3")
	Lin_2 = @bind lin_2 Scrubbable(40:1:60, default=50, format="+")
	
	Quad_1 = @bind quad_1 Scrubbable(-0.040:0.005:0.04, default=0.02, format=".4",)
	Quad_2 = @bind quad_2 Scrubbable(-2:0.1:2, default=-1.2, format="+.1")
	Quad_3 = @bind quad_3 Scrubbable(40:1:60, default=50, format="+")
	
	Cubic_1 = @bind cubic_1 Scrubbable(-0.01:0.001:0.01, default=0.008, format=".4")
	Cubic_2 = @bind cubic_2 Scrubbable(-2:0.01:2, default=-0.35, format="+.4")
	Cubic_3 = @bind cubic_3 Scrubbable(-5:0.1:5, default=3.6, format="+.4")
	Cubic_4 = @bind cubic_4 Scrubbable(20:60, default=40, format="+")
	
	md"""Define Sliders for parameter trials of height angle"""
end

# ╔═╡ d3f023b1-8a57-4690-b8d6-afbe2ff50d5e
begin
	
	a_slider = @bind a Scrubbable(-4:0.1:4, default= 1)
	b_slider = @bind b Scrubbable(0.1:0.1:4, default= 3)
	phi_slider = @bind φ Scrubbable(-pi/2:pi/60:pi/2, default= -3*pi/10)
	md""" 
	### Define sliders
	"""
end

# ╔═╡ 3c1cc3af-11f9-44ac-b07f-69704c4841c4
md"""
``\varphi``: $(phi_slider)

``a``: $(a_slider)

``b``: $(b_slider)

"""

# ╔═╡ b8942536-020b-4c8e-a875-b5aba3034d42
begin
	#a = 1
	
	x = a+b*tan(φ)
	beach_length = maximum([4, abs(x)])
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
		titlefontsize = 7,
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
	plot!([x,x], [-a_dist_y, a_dist_y]./2, linewidth = 3, color= :black, label = false)
	
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
	
	> *So this is the data of the lightpoints which I collected, Captain Bayes, can you help me to find the position of the lighthouse?*
	
	
	"""
end

# ╔═╡ 6b2f6ea4-6d58-43f6-9527-e576422f1feb
begin
	xmax = maximum(abs.(xx))
	plot(xx, rand(length(xx)) .* -0.9 .- 0.1, markershape = :x, 
	linewidths = 3,linealpha = 0,
	markerstrokewidth = 4,
	color = :blue,
	xlim = [-xmax, xmax],
	ylim = [-1, 4],
	label = "Observations",
	size = (640,320),
	labelfontsize = 15,
	tickfontsize = 13,
	legendfontsize = 11,
	bottom_margin =5mm,
	left_margin = 5mm,
	right_margin = 5mm,
	titlefontsize = 7,
	#foreground_color_grid = :black,
	#foreground_color_xticks = :black,
	background_color = :transparent,
	#foreground_color_axis = :black,
	#foreground_color_text = :black,
	#foreground_color_border = :black,
	foreground_color = :black,
	fontfamily="Computer Modern"
	
	)
	
	plot!([-xmax, xmax], [0,0], linewidth = 3, color= :black, label = false)
	
end

# ╔═╡ ac2f313d-1529-4366-ab58-00679e510f6a
md"""
$(Resource(bayes, :width=>140))
 
   *Dear **Captain Venn**, so let's have a **look on the data**, and plot them, maybe we discuss the **height angle first**. What kind of **model function** do you think would be suited for the given data?*

👉 $(@bind model_function Select(["Linear model", "Quadratic model", "Cubic model"]))

 $(Resource(venn, :width=>80)) 
    *Well let's try if we can fit those data by hand*

"""

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


# ╔═╡ Cell order:
# ╟─6c070606-1411-40fc-b6cd-8f27f052136b
# ╟─ec784992-f4af-4ece-bf72-555960a054ca
# ╟─8f919de1-356f-4e42-9f7e-5d29092ed80f
# ╟─3c1cc3af-11f9-44ac-b07f-69704c4841c4
# ╟─b8942536-020b-4c8e-a875-b5aba3034d42
# ╟─7127d313-c9a3-4206-bae7-ac7fc9fbe514
# ╟─5fc032bb-990d-424e-a256-ef2979980606
# ╟─6b2f6ea4-6d58-43f6-9527-e576422f1feb
# ╠═fd94fab8-c4c4-454e-9f5b-c0f1178143b3
# ╠═ac2f313d-1529-4366-ab58-00679e510f6a
# ╠═161bdcd4-55ac-4869-91bd-0141d0fc72db
# ╟─d3f023b1-8a57-4690-b8d6-afbe2ff50d5e
# ╟─e7666210-a660-11eb-3e0d-7d9aec9a9f9e
# ╟─16938d4f-6f25-4924-8bdf-b0eb638a6c4f
# ╠═7bf32131-f749-41da-9923-2970f1487f7e
# ╟─5d349d39-c688-4431-b056-aa11d69376e9
