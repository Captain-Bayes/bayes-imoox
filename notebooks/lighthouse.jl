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

# ╔═╡ 7127d313-c9a3-4206-bae7-ac7fc9fbe514
md"""
# TO BE FINISHED! WORK IN PROGRESS 🚧
"""

# ╔═╡ 6b2f6ea4-6d58-43f6-9527-e576422f1feb


# ╔═╡ 1c0c7b6a-e4f2-4e28-a6d5-1daf194ecf32
md"""
*Well there is this **misfit function** that might help to evaluate the parameter choices*

**Show quadratic misfit $(latexstring("\\chi^2"))**  of chosen parameters 👉 $(@bind show_misfit CheckBox())
"""

# ╔═╡ 8cdf76c3-263f-471b-8ac7-288ff669bca3
md"""
Well let's assume there might be a linear dependency for the azimuth  $(latexstring("a_{\\sphericalangle}")) and the height angle $(latexstring("h_{\\measuredangle}"))

Our first model shall have the simple form:
 $(latexstring("y = a_1 \\cdot x + a_2"))

So let's uns Bayes' theorem to derive the probability for the two parameters given the data of days $(latexstring("x")) and angles $(latexstring("\\boldsymbol a_{\\sphericalangle}")) and $(latexstring("\\boldsymbol h_{\\measuredangle}")).

 $(latexstring("p(\\vec a \\mid \\boldsymbol a_{\\sphericalangle}, \\boldsymbol x) = \\frac{1}{Z} p(\\boldsymbol a_{\\sphericalangle} \\mid \\vec a, \\boldsymbol x) \\cdot p(\\vec a) "))
"""

# ╔═╡ 70dd38b5-8447-428a-96a3-950fcecfcc91
begin
	h1 = heatmap(collect(P_a[1]), collect(P_a[2]), (T_a), 
		xlabel = latexstring("a_1"), 
		ylabel= latexstring("a_2"), 
		title = "Joint probability density: azimuth angle ",
	size = (600,400),
	labelfontsize = 20,
	tickfontsize = 15,
	bottom_margin =5mm,
	left_margin = 5mm,
	linewidth = 3,
	label = :none,
	titlefontsize = 20,	
	#foreground_color_grid = :black,
	#foreground_color_xticks = :black,
	background_color = :transparent,
	#foreground_color_axis = :black,
	#foreground_color_text = :black,
	#foreground_color_border = :black,
	foreground_color = :black,
	fontfamily="Computer Modern"
	)
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 7//Images//joint_prob_azimuth")
	
	
	

	
	plot(h1)
end

# ╔═╡ 75e89a64-94c0-4f95-b548-ecaf3e6587e9
begin
	h2 = heatmap(collect(P_h[1]), collect(P_h[2]), (T_h), 
		xlabel = latexstring("b_1"), 
		ylabel= latexstring("b_2"), title = "Joint probability density: height angle",	
		size = (600,400),
		labelfontsize = 20,
		tickfontsize = 15,
		bottom_margin =5mm,
		left_margin = 5mm,
		right_margin = 5mm,
		linewidth = 3,
		label = :none,
		titlefontsize = 20,	
		#foreground_color_grid = :black,
		#foreground_color_xticks = :black,
		background_color = :transparent,
		#foreground_color_axis = :black,
		#foreground_color_text = :black,
		#foreground_color_border = :black,
		foreground_color = :black,
		fontfamily="Computer Modern")
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 7//Images//joint_prob_height")
	plot(h2)
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
	x =  [4.73,  0.45, -1.73,  1.09,  2.19,  0.12,  1.31,  1.00,
                     1.32,  1.07,  0.86, -0.49, -2.59,  1.73,  2.11,  1.61,
                     4.98,  1.71,  2.23,-57.20,  0.96,  1.25, -1.56,  2.45,
                     1.19,  2.17,-10.66,  1.91, -4.16,  1.92,  0.10,  1.98,
                    -2.51,  5.55, -0.47,  1.91,  0.95, -0.78, -0.84,  1.72,
                    -0.01,  1.48,  2.70,  1.21,  4.41, -4.79,  1.33,  0.81,
                     0.20,  1.58,  1.29, 16.19,  2.75, -2.38, -1.79,  6.50,
                   -18.53,  0.72,  0.94,  3.64,  1.94, -0.11,  1.57,  0.57]
	
	
	md"""
	## The data: 
	> *Unfortunately the weather was **cloudy** and **rainy** during the shortest nights of the year. I took measurements before and after the **21st of June** but I have such **strong errors**! Can you help me to **find out the angles** which will guide me to my treasure?*
	$(Resource(image_of_data, :width=>600))
	$(Resource(diagram_of_data, :width=>600))
	
	"""
end

# ╔═╡ 70eedefd-0a0d-454f-a15e-13d47db594bc
begin 
	plot(x,rand(1:2:30, length(x)), line = :scatter, label = :none,
		title = "Light observations",
		xlabel = latexstring("\\textrm{days } x"), 
		ylabel = latexstring("h_{\\measuredangle}"),
		xlim = [-7,7],
	size = (640,320),
		labelfontsize = 15,
		tickfontsize = 13,
		bottom_margin =5mm,
		left_margin = 5mm,
		right_margin = 5mm,
		linewidth = 3,
		markersize = 4,
		titlefontsize = 7,	
		#foreground_color_grid = :black,
		#foreground_color_xticks = :black,
		background_color = :transparent,
		#foreground_color_axis = :black,
		#foreground_color_text = :black,
		#foreground_color_border = :black,
		foreground_color = :black,
		fontfamily="Computer Modern")
	#savefig("C://Lehre//Bayes MOOC//Lesson 8//Images//lighthouse")
	
	
end

# ╔═╡ 2630e21d-3f42-4d72-a2e7-b127b4ad09fe
begin
	histogram(x, bins = -15:1/3:15, ylim = [0,20])
	
	
end

# ╔═╡ b09f27cb-0461-4ead-9328-dd950c958f66
begin
	
	xx_az = P_a[1]' .+ P_a[2].*0
	yy_az = P_a[1]'.*0 .+ P_a[2]
	
	
	# plot(x, azimuth, line= :scatter, label="azimuth", legend=:bottom)
	plot(x,azimuth, line = :scatter, label = :none)

	for i = 1:length(xx_az)
		if T_a[i] > 0.7
			plot!(t, xx_az[i] .* t .+ yy_az[i], linewidth = 2, opacity = T_a[i]/30., color = :blue, label = :none)
		end
	end
	plot!(x,azimuth, line = :scatter, label = :none,
		title = "linear solutions for azimuthal angle",
		xlabel = latexstring("\\textrm{days } x"), 
		ylabel = latexstring("a_{\\sphericalangle}"),
	size = (600,400),
		labelfontsize = 20,
		tickfontsize = 15,
		bottom_margin =5mm,
		left_margin = 5mm,
		right_margin = 5mm,
		linewidth = 3,
		titlefontsize = 20,	
		#foreground_color_grid = :black,
		#foreground_color_xticks = :black,
		background_color = :transparent,
		#foreground_color_axis = :black,
		#foreground_color_text = :black,
		#foreground_color_border = :black,
		foreground_color = :black,
		fontfamily="Computer Modern")
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 7//Images//poss_sol_azimuth")
end

# ╔═╡ ac2f313d-1529-4366-ab58-00679e510f6a
md"""
$(Resource(bayes, :width=>140))
 
   *Dear **Captain Venn**, so let's have a **look on the data**, and plot them, maybe we discuss the **height angle first**. What kind of **model function** do you think would be suited for the given data?*

👉 $(@bind model_function Select(["Linear model", "Quadratic model", "Cubic model"]))

 $(Resource(venn, :width=>80)) 
    *Well let's try if we can fit those data by hand*

"""

# ╔═╡ 4c05708b-61d7-4b68-97e1-7fc155419460
begin
	if model_function == "Linear model"
		
		md"""
		👉 **Choose the parameters** of the **Linear** model function:  $(latexstring("y = ")) $(Lin_1)   $(latexstring("\\cdot x ")) $(Lin_2)"""
		
	elseif model_function == "Quadratic model"
		md"""
		👉 **Choose the parameters** of the **Quadratic** model function:  $(latexstring("y = ")) $(Quad_1)  $(latexstring("\\cdot x^2 ")) $(Quad_2)  $(latexstring("\\cdot x ")) $(Quad_3)
		"""
		
	elseif model_function == "Cubic model"
		md"""
👉 **Choose the parameters** of the **Cubic** model function:  $(latexstring("y = ")) $(Cubic_1) $(latexstring("\\cdot x^3")) $(Cubic_2) $(latexstring("\\cdot x^2 ")) $(Cubic_3) $(latexstring("\\cdot x  ")) $(Cubic_4)
"""
	end

	
	
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


# ╔═╡ 6b9ea181-a1c1-446c-88cc-d468dec2a60f
begin 
	plot(x,rand(1:2:20, length(x)), line = :scatter, label = :none,
		title = "Measured height angle",
		xlabel = latexstring("\\textrm{days } x"), 
		ylabel = latexstring("h_{\\measuredangle}"),
		xlim = [-7,7],
	size = (320,180),
		labelfontsize = 5,
		tickfontsize = 1,
		bottom_margin =1mm,
		left_margin = 1mm,
		right_margin = 1mm,
		linewidth = 3,
		markersize = 2,
		titlefontsize = 7,	
		#foreground_color_grid = :black,
		#foreground_color_xticks = :black,
		background_color = :transparent,
		#foreground_color_axis = :black,
		#foreground_color_text = :black,
		#foreground_color_border = :black,
		foreground_color = :black,
		fontfamily="Computer Modern")
	#savefig("C://Lehre//Bayes MOOC//Lesson 8//Images//lighthouse")
	
	days = 0:0.1:25
	f_lin(x) = lin_1.*x .+ lin_2
	f_quad(x) = quad_1.*x.^2 + quad_2.*x .+ quad_3
	f_cubic(x) = cubic_1.*x.^3 + cubic_2.*x.^2 + cubic_3 .*x .+ cubic_4
	
	M_lin(x) = [x ones(length(x),1)]
	M_quad(x) = [x.^2 x ones(length(x),1)]
	M_cubic(x) = [x.^3 x.^2 x ones(length(x),1)]
	
	
	if model_function == "Linear model"
	 	M(x) = M_lin(x)
		a_vec = [lin_1; lin_2]
	#=plot!(days, lin_1 .* days .+ lin_2,
		linewidth = 3,
		label = latexstring("\\textrm{Linear model: y =}" * sr(lin_1,2) * "\\cdot x + " * sr(lin_2,1)),
		legendfontsize = 12,
		)=#
		
	elseif model_function == "Quadratic model"
		M(x) = M_quad(x)
		a_vec = [quad_1; quad_2; quad_3]
		
		plot!(days, quad_1 .* days.^2 .+ quad_2 .* days .+ quad_3,
		linewidth = 3,
		label = latexstring("\\textrm{Quadratic model: y =}" * sr(quad_1,4) * "\\cdot x^2  " * sr(quad_2,1, add_sign =  true) * " x  " * sr(quad_3,1, add_sign =  true)),
		legendfontsize = 12,
		)
		
		
	elseif model_function == "Cubic model"
		M(x) = M_cubic(x)
		a_vec = [cubic_1; cubic_2; cubic_3; cubic_4]
		
		plot!(days, cubic_1 .* days.^3 .+ cubic_2 .* days.^2 .+ cubic_3 .* days .+ cubic_4,
		linewidth = 3,
		label = latexstring("\\textrm{Cubic model: y =}" * sr(cubic_1,4) * "\\cdot x^3  "  * sr(cubic_2,4, add_sign = true) * "\\cdot x^2  " * sr(cubic_3,1, add_sign =  true) * " x  " * sr(cubic_4,1, add_sign =  true)),
		legendfontsize = 12,
		)
			
			
	end
	
	
end

# ╔═╡ b8d59753-d6c1-46c3-b40b-1bc858be8ca2
begin 
	if show_misfit
		md""" The **quadratic misfit: $(latexstring("\\chi^2 = \\sum_\\nu \\frac{(\\textbf{d}_\\nu - f(\\textbf{x}_\\nu, \\vec a))^2}{\\sigma_\\nu^2} = "))
		$(sr(sum( (height - M(x) * a_vec).^2 ./ delta_height.^2),2))**
		
		**🔍 Check how you can minimize this misfit value 👆 by varying the parameters by hand before checking the "best solution" in the blue box 🟦 below 👇**
		"""
	
		
	end
end

# ╔═╡ 103cd28d-347e-487f-a2ac-3a2f72d18456
begin
	
	#if optimal_parameter
	hint( md"""**The optimal parameters** according to orthodox regression can be obtained by solving the matrix equation $(latexstring("M(\\textrm{\\textbf{x}}) \\cdot \\vec a = \\textbf{h}_{\\measuredangle}"))
		
 $(sr.(M(x)\height, 4))

 		

In this case we assume the uncertainties $(latexstring("\\sigma_\\nu")) of the height angle $(latexstring("h_{\\measuredangle}")) to be all the same for all data points.
		
		
""", "Optimal parameters for the "* model_function)
		
		
#	end
	
end

# ╔═╡ Cell order:
# ╟─6c070606-1411-40fc-b6cd-8f27f052136b
# ╟─ec784992-f4af-4ece-bf72-555960a054ca
# ╟─7127d313-c9a3-4206-bae7-ac7fc9fbe514
# ╟─5fc032bb-990d-424e-a256-ef2979980606
# ╟─70eedefd-0a0d-454f-a15e-13d47db594bc
# ╠═6b2f6ea4-6d58-43f6-9527-e576422f1feb
# ╟─ac2f313d-1529-4366-ab58-00679e510f6a
# ╠═2630e21d-3f42-4d72-a2e7-b127b4ad09fe
# ╟─4c05708b-61d7-4b68-97e1-7fc155419460
# ╠═6b9ea181-a1c1-446c-88cc-d468dec2a60f
# ╟─1c0c7b6a-e4f2-4e28-a6d5-1daf194ecf32
# ╟─b8d59753-d6c1-46c3-b40b-1bc858be8ca2
# ╟─103cd28d-347e-487f-a2ac-3a2f72d18456
# ╟─8cdf76c3-263f-471b-8ac7-288ff669bca3
# ╟─70dd38b5-8447-428a-96a3-950fcecfcc91
# ╟─75e89a64-94c0-4f95-b548-ecaf3e6587e9
# ╠═b09f27cb-0461-4ead-9328-dd950c958f66
# ╟─161bdcd4-55ac-4869-91bd-0141d0fc72db
# ╠═e7666210-a660-11eb-3e0d-7d9aec9a9f9e
# ╠═16938d4f-6f25-4924-8bdf-b0eb638a6c4f
# ╠═7bf32131-f749-41da-9923-2970f1487f7e
# ╟─5d349d39-c688-4431-b056-aa11d69376e9
