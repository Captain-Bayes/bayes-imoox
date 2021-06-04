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

# ╔═╡ 673b5f44-0db4-4848-95d7-24a31e7e86b1
begin
	try
		using PlutoUI
		using Plots
		using Plots.PlotMeasures
		using LaTeXStrings
		using Markdown
		using StatsBase
		using Images
		using DelimitedFiles

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
		Pkg.add("DelimitedFiles")
		Pkg.add("StatsBase")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		#Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		#Pkg.add("Distributions")
		using PlutoUI, Plots, LaTeXStrings, Markdown, Images, Plots.PlotMeasures, Random, DelimitedFiles, StatsBase

		#using LinearAlgebra
		#using SparseArrays
		#using StatsBase

		md""" 
		### Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
end

# ╔═╡ e342faf1-550f-4b6f-963e-ef53ac581c0b
#todo:
#scale invariance
#vdL im Video nix von multiple orders of magnitude erwähnt, also was jetzt?
#i am confused

# ╔═╡ 2dde8f33-1166-42b9-834f-7bcb54895992
md""" # Benford's Law"""

# ╔═╡ 245d5573-09f4-4536-b104-351a7669cd8b
md""" If you haven't already, you can watch the new episode here!"""

# ╔═╡ 9a4bc5f5-7acd-4640-a71b-82051b6d3db3
html"""<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/ABbv9g5kTdI?start=394" width=600 height=375  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>"""

# ╔═╡ 27811f40-08a7-4da7-9788-db4b0c47153b
Markdown.MD(Markdown.Admonition("hint", string("Benford's law"), [md"""For a lot of naturally occurring datasets, the probability that the leading digit of a number in the set is the number  $(latexstring("d  \quad d \in \{1, 2, 3, .. 9\}")) can be calculated with

$(latexstring("P(d) = log_{10}(d + 1) - log_{10}(d)"))"""]))

# ╔═╡ 0527804c-68b7-42f9-8830-c41d6b9036f4
md""" **Bayes:** 
...But to be sure, let's have a look at your data!"""

# ╔═╡ 91d8c001-c210-4c42-a7f2-5e84ee907ea6
md""" **Lyra:** I've collected data on different kinds of things - litter in the ocean, how many Frogfish are caught on a weekly basis, and the population of all organisms on the reefs! Which one do you want to see first?"""

# ╔═╡ fb1b6ea0-330c-4744-b3b8-19730b55e7e5
begin
	md"""
	Choose the **data** to compare 👉 $(@bind data_list Select(["Mass of marine litter in g🚯", "Mass of marine litter in lbs 🚯", "Pieces of litter on the beach", "Frogfish caught weekly", "Reef population", "Random data"]))
	"""
	
end

# ╔═╡ 56b1302d-6a0e-4262-aa0e-9ae98c2167df
if data_list == "Random data"
md""" Choose a seed for the randomly generated data! $(@bind seed Scrubbable(0:1:20))"""
end

# ╔═╡ c13206e8-ff41-405a-b9b8-50b589854901
md""" **Lyra:** You're right, it does coincide quite well! But there are some cases, where it does not work at all! Do you know why, Captain Bayes?

**Bayes:** Benford's law applies to many, albeit not all naturally occurring datasets.

**Bayes:** Specifically, it is required that the data is spread out over several order of magnitudes. Let's say x is the smallest number in our set. Benford's law will work best, if there are numbers in our set that are 10000x or higher. It is plausible that your data does not always fulfill this criterium - we're going to plot a logarithmic histogram of your data to clear that up!


"""

# ╔═╡ 8a30e661-3057-4a30-a495-b1523b42207b
begin
	MarineLitter = html"<a href = 'https://catalogue.data.govt.nz/dataset/marine-litter-2018-2019' title = 'Hello' >Marine Litter</a>"
	ReefPopulation = html"<a href = 'https://data.world/gmoney/us-city-populations' title = 'Hello' >Reef Population</a>"
	Frogfish = html"<a href = https://datadryad.org/stash/dataset/doi:10.5061/dryad.ng8pf' title = 'Hello' >Frogfish</a>"
	
	md""" ## Did you know?
	
	The data analyzed here is acual scientific data! You can find our sources here:
	
	$(MarineLitter) (yes this is actual litter collected from beaches)
	
	
	$(ReefPopulation) (this is actually the population of US cities with more than 6000 inhabitants)
	
	
	$(Frogfish) (this is actually Pacific Salmon caught weekly) 
	
	
	
	"""
	
end

# ╔═╡ 4f48ef9a-05ea-41f9-a2a0-381865b8be6a
md""" # Derivation of Benford's Law using scale invariance"""

# ╔═╡ 601c53ed-ac2f-48fe-8afa-6b511a3ef369
html"""<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/udDNi8yZH4o?start=1328" width=600 height=375  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>"""

# ╔═╡ ea7c16d9-dd13-41c6-9c03-431d068fd105
begin
	claire = "https://raw.githubusercontent.com/Captain-Bayes/images/main/claire_100px.gif"
	lyra = "https://raw.githubusercontent.com/Captain-Bayes/images/main/lyra_50px.gif"
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
	
	md"""Images"""
end

# ╔═╡ 0615b18c-23b6-4f93-99ff-2044588dccf2
md""" $(Resource(lyra, :width=>180))

When strolling on the beach, I find all kinds of stuff getting washed up by the ocean!


I keep a statistic on my findings, and I have noticed a strange pattern regarding the distribution of the first digits of my data: 

I would have expected to find an equal distribution of all numbers as the first digit in my statistics, but it turns out that most entries in my datasets start with a 1, followed by 2, and decreasing - up to the point, that it is 6.6 times more likely to find an entry starting with a 1 than with a 9!


Weird, isn't it?"""

# ╔═╡ 468c679f-6a42-4801-a908-82ab5a4c9507
md"""$(Resource(bayes, :width=>180))

That's interesting. Your description does sound like we could apply Benford's law.
"""

# ╔═╡ 7959439c-f947-40b3-8d2a-7dc96e90bbdc
#commentaries
begin
	if data_list =="Mass of marine litter in g🚯"
		
		md"""
		The data's range spans 4 orders of magnitude.
		
		 $(Resource(bayes, :width=>180))"""
		
	elseif data_list =="Mass of marine litter in lbs 🚯"
		md"""
		**Bayes:** The data's range spans 4 orders of magnitude. However, there doesn't seem to be a scale invariance for the first ci - I must admit, I am a bit puzzeled...
		
		 $(Resource(bayes, :width=>180))"""	
	elseif data_list =="Pieces of litter on the beach"
		md"""
		**Bayes:** The data's range spans 3 orders of magnitude
		
		$(Resource(bayes, :width=>180))"""
				
	elseif data_list =="Frogfish caught weekly"
		md""" 
		**Bayes:** The data's range only spans 1 order of magnitude! This explains the strong deviations!
		
		$(Resource(bayes, :width=>180))"""
		
	elseif data_list =="Reef population"
		md""" 
		**Bayes:** The data's range spans almost 3 orders of magnitude. But since there surely are populations at the Reef that have less inhabitants, I am guessing you have cut off the data at some point, is that correct?
		
		$(Resource(bayes, :width=>180))
		
**Lyra:**  Oh my, yes that is correct! I got so bored with counting groups of only 10 fish! I decided to only count populations that are higher than 6000! Does that interfere with the analysis of the numbers?
		
		$(Resource(lyra, :width=>180))

**Bayes:** I'm afraid so. But at least that can explain the peak at 6!"""
					
	elseif data_list == "Random data"
		md""" 
		This data was generated by generating 10000 random (equally distributed) numbers A in a range of (ln(10^-8), ln(10^+8")) and then calculating exp(A). This way, we can assure data spanning multiple orders of magnitude. This type of data is called **log uniform**
		""" 
	
					end
end

# ╔═╡ 1f8c2dfc-1f42-41f9-b18d-3f04df20e527
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

# ╔═╡ ce366a2b-3933-4b4b-a01c-c0a1ed7da96a
#definition of get_firstdigit
function get_first_digit(data) #data must be array of numbers
	#get rounded number (to highest power of 10)
	rounded = floor.(log.(10, data))
	#get number between 0 and 10
	mantissa = data ./ (10 .^rounded)
	digit = floor.(mantissa)
	firstdigit = digit[0 .< digit .< 10]
	return firstdigit


end

# ╔═╡ deb756be-10ee-43c5-b466-9909b4431268
function normalize(array)
	#gets keys and values out of countmap and returns keys and normed values in 2D list
	dict_values = []
	key = sort(collect(keys(countmap(array))))
	for i in key
		append!(dict_values, countmap(array)[i])
		end
	if key[1] == 0
	normed_dict_values = dict_values/sum(dict_values[2:10])
	return [key[2:10], normed_dict_values[2:10]]
	else
		normed_dict_values = dict_values/sum(dict_values)
		return [key, normed_dict_values]
	end
end

# ╔═╡ ac233104-737c-4a92-843d-45042ba25cd1
begin
#data

	if data_list == "Random data"
		#generate data
		rng = MersenneTwister(seed)
		sample_size = 10000
		# parameters of random number generator fort scale invariant random numbers
		x0     = 10^(-10)   # smallest number
		x1     = 10^10      # largest number

		ln0    = log(x0)
		ln1    = log(x1)
		lsx    = rand(rng,ln0:ln1,sample_size)
		a1 = exp.(lsx)
		
		
		
	elseif data_list == "Reef population"
		#get data
		datasetpopulation = readdlm("data_city_population.csv", '\\')
		population_1 = []
		population = []
		for i in 2:6890
			append!(population_1, [split(datasetpopulation[i], ";")[3]])
			b = filter(x -> !isspace(x), population_1[i-1])
			append!(population, [b])
		end
		a1 = parse.(Int64, population)
		
		
		
		
		
	elseif data_list == "Frogfish caught weekly"
		#get data
		datasetfish = readdlm("data_salmon.csv", '\\')
		fish_nr = []
		for i in 3:986
			append!(fish_nr, split(datasetfish[i], ",")[5])
			end
		a1 = parse.(Int64, fish_nr)
		

		
		
		
	elseif data_list == "Pieces of litter on the beach"
		#get data
		datasetlitter = readdlm("data_marine_litter.csv", '\\')
		marine_numbers = []
		for i in 3:986
			append!(marine_numbers, parse(Float64, reverse(split(datasetlitter[i], ","))[8]))
			end
		a1 = convert(Array{Float64,1}, marine_numbers)
		
		
		
		
	elseif data_list == "Mass of marine litter in g🚯"
		#get data
		datasetlitter = readdlm("data_marine_litter.csv", '\\')
		marine_mass_g = []
	
		for i in 3:986
			append!(marine_mass_g, parse(Float64, reverse(split(datasetlitter[i], ","))[7]))
			end
		a1 = convert(Array{Float64,1}, marine_mass_g)
		
		
		
		
	elseif data_list == "Mass of marine litter in lbs 🚯"
		#get data
		datasetlitter = readdlm("data_marine_litter.csv", '\\')
		marine_mass_lbs = []
		for i in 3:986
			append!(marine_mass_lbs, parse(Float64, reverse(split(datasetlitter[i], ","))[7])*0.00220462)
		end
	
		a1= convert(Array{Float64,1}, marine_mass_lbs)
		
	end
	
#get first digits
first_digits = get_first_digit(a1)
#plot
bar(normalize(first_digits)[1], normalize(first_digits)[2], label = "Data")

#theory
	
d = range(1,stop = 9, length = 50)
p_benford = log.(10, (d .+ 1.0)) - log.(10, d)
	
d_discrete = range(1,stop = 9, length = 9)
p_benford_discrete = log.(10, (d_discrete .+ 1.0)) - log.(10, d_discrete )
	
plot!(d , p_benford, label = "Theory")
plot!(d_discrete,p_benford_discrete, line = :scatter, label = :none,
		title = "Testing Benford's Law for " * String(data_list),
		xlabel = "first digit", 
		ylabel = "relative frequency",
		#xlim = [0,10],
		size = (1200,800),
		labelfontsize = 15,
		tickfontsize = 13,
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

	
end

# ╔═╡ d16680ec-541d-42f0-867e-4259b30adcdb
begin
#plot logarithmic histogram of data
a2 = a1[0 .< a1]
	bins_exp = range(log10(minimum(a2)), log10(maximum(a2)), step = 0.1)
		bins =  10 .^ bins_exp
	
	plot((histogram(a1; bins, xaxis=(:log10, [minimum(a2), :auto]))))
	
end

# ╔═╡ Cell order:
# ╟─e342faf1-550f-4b6f-963e-ef53ac581c0b
# ╟─2dde8f33-1166-42b9-834f-7bcb54895992
# ╟─245d5573-09f4-4536-b104-351a7669cd8b
# ╟─9a4bc5f5-7acd-4640-a71b-82051b6d3db3
# ╟─0615b18c-23b6-4f93-99ff-2044588dccf2
# ╟─468c679f-6a42-4801-a908-82ab5a4c9507
# ╟─27811f40-08a7-4da7-9788-db4b0c47153b
# ╟─0527804c-68b7-42f9-8830-c41d6b9036f4
# ╟─91d8c001-c210-4c42-a7f2-5e84ee907ea6
# ╟─fb1b6ea0-330c-4744-b3b8-19730b55e7e5
# ╟─56b1302d-6a0e-4262-aa0e-9ae98c2167df
# ╟─ac233104-737c-4a92-843d-45042ba25cd1
# ╟─c13206e8-ff41-405a-b9b8-50b589854901
# ╟─d16680ec-541d-42f0-867e-4259b30adcdb
# ╟─7959439c-f947-40b3-8d2a-7dc96e90bbdc
# ╟─8a30e661-3057-4a30-a495-b1523b42207b
# ╟─4f48ef9a-05ea-41f9-a2a0-381865b8be6a
# ╟─601c53ed-ac2f-48fe-8afa-6b511a3ef369
# ╟─673b5f44-0db4-4848-95d7-24a31e7e86b1
# ╟─ea7c16d9-dd13-41c6-9c03-431d068fd105
# ╟─1f8c2dfc-1f42-41f9-b18d-3f04df20e527
# ╟─ce366a2b-3933-4b4b-a01c-c0a1ed7da96a
# ╟─deb756be-10ee-43c5-b466-9909b4431268
