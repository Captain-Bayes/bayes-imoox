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

# ╔═╡ b9f3e82b-0792-4c42-a7c4-04b11ac9a44e
md"""
# Antigen tests
Experience why the **percentage of infected people** is important to **correctly interprete your personal test result.**
Note: The properties of a test - **sensitivity and specificity** - are independent of the population size or number of infected people!

> **Sensitivity** describes how good a test recognizes an infected person, so the percentage of the test to be positive if the person has the virus

> **Specificity** is the quantity that tells us how well healthy people (not infected) are recognized as such, so the probability that the test is negative for a healthy person
"""

# ╔═╡ 325c3295-20b3-4f67-84d0-277e9b01ecd3
md""" The **population size** of your city is $(@bind pop_size Slider(10000:10000:1000000, default = 300000, show_value = true)) among whom $(@bind test_ratio_percentage Scrubbable(1:100, default = 5))% **got tested** (think of an example where this number could be important).


The **percentage of infected people** is estimated to be $(@bind inf_rate_percent Scrubbable(0:1:100, default = 5))%

"""

# ╔═╡ 31c61c6d-1a97-451f-b07c-864eca18bff2
md"""
The **sensitvity** of an antigen test 💉 is ``P(B\mid V) = `` $(@bind sensi_percent Scrubbable(1:1:100, default = 95))%

and the **specificity** of the test is ``P(\neg B\mid \neg V) = `` $(@bind spec_percent Scrubbable(1:100, default = 90))%

"""

# ╔═╡ 1b7fd8d9-daa2-4808-939a-44548569fcc5
begin
	plot([0,1,1,0,0], [0,0,1,1,0], 
		line=(1,1,:path),
		fill = (1,:white),
		aspect_ratio=:equal,
		grid = :none,
		label=latexstring("\\textrm{ Tested persons: } " * sr(tested_people,0)),
		xlabel = latexstring(""),
		ylabel = latexstring(""),
		linewidth = 3,
		#aspect ratio for printing font sizes etc.
		size = (600,400),
		xlim = [0,1],
		legendfontsize = 10,
		leg = :outerright,
	tickfontsize = 15,
	bottom_margin =5mm,
	left_margin = 5mm,
	
	foreground_color = :black,
	foreground_color_yticks = :transparent,
	titlefontsize = 20,	
	#foreground_color_grid = :black,
	#foreground_color_xticks = :black,
	background_color = :transparent,
	#foreground_color_axis = :black,
	#foreground_color_text = :black,
	#foreground_color_border = :black,
	fontfamily="Computer Modern"
			
		)
	
	plot!([0,inf_rate,inf_rate,0,0], [0,0,1,1,0], 
		line=(1,0,:path),
		fill = (1,:green),
		fillalpha = 0.1, 
		label=latexstring("\\textrm{Infected}: "* sr(tested_people*(inf_rate),0)),
		)
	plot!([inf_rate, inf_rate], [0,1], 
		label = :none)
	
	plot!([1,inf_rate,inf_rate,1,1], [0,0,(1-spec),(1-spec),0],
		fill = (1,:red),
		fillalpha = 0.1,
		label=latexstring("\\textrm{False positive}: "* sr(tested_people*(1-inf_rate)*(1-spec),0)),
		
		)
	plot!([0,inf_rate,inf_rate,0,0], [0,0,(1-sensi),(1-sensi),0],
		fill = (1,:yellow),
		fillalpha = 0.4,
		label=latexstring("\\textrm{False negative}: "* sr(tested_people*(inf_rate)*(1-sensi),0)),
	)
	
end

# ╔═╡ b70ab060-2117-4c24-adac-27982e5065f3
md"""
The probability to have the virus if the test is positive or negative is
-  ``P(V\mid B) = `` $(sr(P_V_B,5))
-  ``P(V\mid \neg B) = `` $(sr(P_V_neg_B,5))

The probability for a positive test is:
-  ``P(B) = `` $(sr(P_positive_test))
"""

# ╔═╡ 813ea500-a2ec-11eb-29cb-89ed915aa25a

begin
	#try
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

	#=
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
	=#
end

# ╔═╡ d5e23d38-5a43-470d-846e-a05d8a56a726
begin
	inf_rate = inf_rate_percent / 100
	spec = spec_percent/100
	sensi = sensi_percent/100
	test_ratio = test_ratio_percentage/100
	
	tested_people = pop_size * test_ratio
	
	infected = pop_size * inf_rate
	
	
	
	P_positive_test = sensi*inf_rate + (1-spec)*(1-inf_rate)
	P_V_B = sensi * inf_rate/ P_positive_test
	
	P_neg_V_neg_B = spec * (1-inf_rate)/(1-P_positive_test)
	
	P_V_neg_B = (1-sensi)*inf_rate/(1-P_positive_test)
	md"""Program"""
end

# ╔═╡ 8b39a33a-d7bd-45f2-91e9-173688ea1ec5
function sr(variable, dig = 2)
	# string and round - converts a variable into a string with the predifined precission - to be extended to scientific and other formats
	if dig == 0
		return string(round(Int, variable))
	else
		return string(round(variable, digits = dig))
	end
end


# ╔═╡ Cell order:
# ╟─b9f3e82b-0792-4c42-a7c4-04b11ac9a44e
# ╟─325c3295-20b3-4f67-84d0-277e9b01ecd3
# ╟─31c61c6d-1a97-451f-b07c-864eca18bff2
# ╠═1b7fd8d9-daa2-4808-939a-44548569fcc5
# ╟─b70ab060-2117-4c24-adac-27982e5065f3
# ╟─813ea500-a2ec-11eb-29cb-89ed915aa25a
# ╟─d5e23d38-5a43-470d-846e-a05d8a56a726
# ╟─8b39a33a-d7bd-45f2-91e9-173688ea1ec5
