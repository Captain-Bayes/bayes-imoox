### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

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

# ╔═╡ 6c070606-1411-40fc-b6cd-8f27f052136b
md"""
# Starpath prediction 🌠

Captain Venn tries to find to coordinates of the treasure chest
"""

# ╔═╡ ac2f313d-1529-4366-ab58-00679e510f6a


# ╔═╡ 16938d4f-6f25-4924-8bdf-b0eb638a6c4f
begin
	claire = "https://raw.githubusercontent.com/Captain-Bayes/images/main/claire_100px.gif"
	makabe = "https://raw.githubusercontent.com/Captain-Bayes/images/main/makeba_100px.gif"
	bernoulli = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Bernoulli_wet.gif"
	island = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Turtle_island_with_ship.png"
	map = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Fishground_map.png"
	frogfish_image = "https://raw.githubusercontent.com/Captain-Bayes/images/main/frogfish_green_full.gif"
	venn = "https://raw.githubusercontent.com/Captain-Bayes/images/main/venn_100px.gif"
	angles_view = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Gipfel_angles.png"
	mountain_view = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Gipfel_view.png"
	image_of_data = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Daten_brett.png"
	diagram_of_data = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Diagram.png"
	
	md"""Images"""
end

# ╔═╡ 5fc032bb-990d-424e-a256-ef2979980606
begin 
	x = [4, 11, 12, 13, 14, 15, 16, 17, 18, 23, 24, 25]
	azimuth = [278.7, 282.1, 280, 281.2, 282, 280.9, 280, 283.2, 281.3, 282.7, 283.7, 282.5]
	# wrong writing
	#azimuth = [278.7, 282.1, 280, 281.2, 282, 280.9, 280, 283.2, 231.3, 282.7, 283.7, 282.5]
	height = [45.9, 47.7, 44., 40.3, 36.2, 36.2, 39.8, 34.8, 38.3, 32.5, 31., 35.1]
	
	
	sigma_a = 2
	sigma_h = 3
	
	sigma_x = 1/12/24
	
	
	function fa(x,a) 
		return a[1].*x .+ a[2]
	end
	
	function fh(x,a) 
		return a[1].*x .+ a[2]
	end
	
	P_a = [range(-0.81,0.8,length = 201) , range(270,290; length = 200)]
	fa(x,[0.2,2]) - azimuth
	
	T_a = [exp.(sum(-0.5 .* (fa(x,[i, j]) - azimuth).^2 ./(sigma_a^2 .+ i.^2 .* sigma_x.^2))) for j in P_a[2], i in P_a[1]]
	T_a = T_a./(sum(T_a).* Float64(P_a[1].step) .* Float64(P_a[2].step))
	
	P_h = [range(-2,0,length = 200) , range(30,60; length = 200)]
	T_h = [exp.(sum(-0.5 .* (fa(x,[i, j]) - height).^2 ./(sigma_h^2 .+ i.^2 .* sigma_x.^2))) for j in P_h[2], i in P_h[1] ]
	T_h = T_h./(sum(T_h) .* Float64(P_h[1].step) .* Float64(P_h[2].step))
	
	#heatmap(collect(P_a[1]), collect(P_a[2]), T)
	# either use uncertainties in both directions or not
	
	# TODO: Check how to make data explorable in a Markdown environment
	#$([x azimuth height])
	md"""
	## The data: 
	
	$(Resource(image_of_data, :width=>600))
	$(Resource(diagram_of_data, :width=>600))
	
	"""
end

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

# ╔═╡ 2931f8f4-154d-46fd-b5a6-6cb5099eb692
begin
	#pl1 = plot(x, azimuth, line= :scatter, label="azimuth", legend=:bottom)
	
	pl2 = plot(x, height, line = :scatter, label="height", legend=:bottom)
	plot( pl2)
end

# ╔═╡ 5ef19a3a-fcfc-4607-88e6-c28197a572f8
begin
	# show data points and also possible solutions using the model defined above.
	# with a click one can choose to display these semitransparent lines (work in quantiles - the top % the second and so on (limit to a max of 500-1000 lines)
	# a maximum of
	xx_hz = P_h[1]' .+ P_h[2].*0
	yy_hz = P_h[1]'.*0 .+ P_h[2]
	
	t = 4:26
	# plot(x, azimuth, line= :scatter, label="azimuth", legend=:bottom)
	plot(x,height, line = :scatter, label = :none)

	for i = 1:length(xx_hz)
		if T_h[i] > 0.7
			plot!(t, xx_hz[i] .* t .+ yy_hz[i], linewidth = 2, opacity = T_h[i]/30., color = :blue, label = :none)
		end
	end
	plot!(x,height, line = :scatter, label = :none,
		title = "linear solutions for height angle",
		xlabel = latexstring("\\textrm{days } x"), 
		ylabel = latexstring("h_{\\measuredangle}"),
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
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 7//Images//poss_sol_height")
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

# ╔═╡ 68854d41-0400-405c-948a-bb244f46ce4d
begin 
	f_eval = [[fa(21,[i,j]) for  j in P_a[2], i in P_a[1]][:] T_a[:]]
	
	a_range = range(minimum(f_eval[:,1]), maximum(f_eval[:,1]), length = 200)
	
	y_a_range = [sum(f_eval[a_range[i] .<= f_eval[:,1] .<= a_range[i+1],2]) for i in 1:(length(a_range)-1)].* Float64(P_a[1].step) .* Float64(P_a[2].step)./Float64(a_range.step)
	
	plot(a_range[1:end-1], y_a_range,
		title = "Interpolation of azimuth angle at day 21",
		xlabel = latexstring("a_{\\sphericalangle}"), 
		ylabel = latexstring("p\\,(a_{\\sphericalangle})"),
		label = :none,
	size = (600,400),
		labelfontsize = 20,
		tickfontsize = 15,
		bottom_margin =5mm,
		left_margin = 5mm,
		right_margin = 10mm,
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
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 7//Images//sol_azimuth")
	
end

# ╔═╡ 4ba5f3c7-6a68-46ba-ba45-9c0b3b685385
begin 
	f_eval_h = [[fh(21,[i,j]) for    j in P_h[2], i in P_h[1]][:] T_h[:]]
	
	h_range = range(minimum(f_eval_h[:,1]), maximum(f_eval_h[:,1]), length = 200)
	
	y_h_range = [sum(f_eval_h[h_range[i] .<= f_eval_h[:,1] .< h_range[i+1],2]) for i in 1:(length(h_range)-1)].* Float64(P_h[1].step) .* Float64(P_h[2].step)./Float64(h_range.step)
	
	plot(h_range[1:end-1], y_h_range ,
		title = "Interpolation of height angle at day 21",
		xlabel = latexstring("h_{\\measuredangle}"), 
		ylabel = latexstring("p\\,(h_{\\measuredangle})"),
		label = :none,
	size = (600,400),
		labelfontsize = 20,
		tickfontsize = 15,
		bottom_margin =5mm,
		left_margin = 5mm,
		right_margin = 10mm,
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
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 7//Images//sol_height")
	
end

# ╔═╡ 5d349d39-c688-4431-b056-aa11d69376e9
function sr(variable, dig = 2)
	# string and round - converts a variable into a string with the predifined precission - to be extended to scientific and other formats
	if dig == 0
		return string(round(Int, variable))
	else
		return string(round(variable, digits = dig))
	end
end


# ╔═╡ Cell order:
# ╟─6c070606-1411-40fc-b6cd-8f27f052136b
# ╟─5fc032bb-990d-424e-a256-ef2979980606
# ╠═ac2f313d-1529-4366-ab58-00679e510f6a
# ╟─70dd38b5-8447-428a-96a3-950fcecfcc91
# ╟─75e89a64-94c0-4f95-b548-ecaf3e6587e9
# ╟─2931f8f4-154d-46fd-b5a6-6cb5099eb692
# ╟─b09f27cb-0461-4ead-9328-dd950c958f66
# ╟─5ef19a3a-fcfc-4607-88e6-c28197a572f8
# ╟─68854d41-0400-405c-948a-bb244f46ce4d
# ╟─4ba5f3c7-6a68-46ba-ba45-9c0b3b685385
# ╟─e7666210-a660-11eb-3e0d-7d9aec9a9f9e
# ╟─16938d4f-6f25-4924-8bdf-b0eb638a6c4f
# ╟─5d349d39-c688-4431-b056-aa11d69376e9
