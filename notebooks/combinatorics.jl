### A Pluto.jl notebook ###
# v0.20.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 476521e1-fbdb-40f3-b133-2df5acca59bc
begin
	#try
		using Pkg
		Pkg.activate(joinpath(DEPOT_PATH[1], "environments/v1.11"))
		using PlutoUI
		using Plots, Plots.PlotMeasures
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
		#using StatsBase
		using Random
		using Distributions
		using LaTeXStrings	
		using Markdown
		using Combinatorics
		using Images
		
		md""" 
		# Packages
		
		All needed Packages available :) """
	#=catch
		import Pkg
		Pkg.activate(mktempdir())
		Pkg.add("PlutoUI")
		Pkg.add("Plots")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		Pkg.add(["Distributions","Random", "LaTeXStrings", "Markdown", "Combinatorics", "Images"])
		
		using PlutoUI
		using Plots, Plots.PlotMeasures
		#using LinearAlgebra
		#using SparseArrays
		using SpecialFunctions
		#using StatsBase
		using Random
		using Distributions
		using LaTeXStrings
		using Combinatorics
		using Images
		md""" 
		# Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	=#
end

# ╔═╡ 958b8590-75b7-4a37-8661-5f230f6026a4
md"""
If you want to see **all possible arrangements**  (sometimes called permutations),
tick the following box 👉 $(@bind show_all_permutations CheckBox())
"""

# ╔═╡ ae23d612-0be7-4c69-ab11-9158a8b215b2
md"""
## Factorial
The factorial is a function for integer numbers ``N`` that describes how many ways there are to arrange ``N`` different objects in a row. 

It is abbreviated by an **exclamation mark** and given by the formula

> $N! = N\cdot (N-1) \cdot (N-2)  \cdots 2 \cdot 1$

Note, that ``0! = 1``
"""

# ╔═╡ f18c200e-bb37-4de2-8be9-26b8b4f28dc0
md"""
# Drawing
"""

# ╔═╡ 54177438-53b8-4a3a-94ed-70c64b607424
md"""
# Distributing
"""

# ╔═╡ 79cd1cb8-569f-4d24-aef5-76d841bb6c65
md"""
# About the creators

This notebook was created by **[Gerhard Dorn](https://github.com/dorn-gerhard)** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes22&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ d71ed580-cdbc-11eb-08ab-11e87cff1cb9
TableOfContents()

# ╔═╡ 85c95bb5-8503-4af0-ba35-cbcc8bdc164e
html"""
<script>
 if (!document.body.classList.contains("static_preview")) {
  console.log("Do nothing in normal notebooks")
  return
 }
 console.log("Override onclick")
 for (const cell of document.querySelectorAll('pluto-cell')) {
  const fold_btn = cell.querySelector('button.foldcode')
  fold_btn.onclick = (e) => {
   console.log("Toggling code folded of ", cell)
   cell.classList.toggle("show_input")
  }
 }
</script>
"""

# ╔═╡ a3c995ff-b2e6-4b87-b801-347eaa07e72d
begin
	rng = MersenneTwister(3)
	md""" Initialize random numbers"""
end

# ╔═╡ ca4d4e9f-5e7a-417f-944a-7f6a80ecd2ff
begin
	bayes = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bayes_100px.gif"
	pascal = "https://raw.githubusercontent.com/Captain-Bayes/images/main/pascal-100px.gif"
	fruit = repeat([""],5,1)
	fruit[1] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Plum-export.png"
	fruit[2] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Apricot-export.png"
	fruit[3] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Strawberry_export.png" 
	fruit[4] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/blue_berry-export.png"
	fruit[5] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/lemon-export.png"
	bottle = repeat([""],5,1)
	bottle[1] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/brown_jar-export.png"
	bottle[2] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/red_jar-export.png" 
	bottle[3] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/blue_jar-export.png"
	bottle[4] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/green_bottle-export.png"
	bottle[5] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/purple_bottle-export.png"
	
	md""" Images"""
end

# ╔═╡ d2b8ddf9-4761-4f05-a19e-59db50ec5694
md"""
# Arranging
$(Resource(pascal, :width => 200))
The question is, how many ways are there to arrange 5 different objects in a row?

Try out some examples and reshuffle the bottles and jars by pressing the button 👉 $(@bind arrange Button("Arrange"))

"""

# ╔═╡ 2faeccea-1e90-4eea-a1d7-7d644a6fa809
begin
	Bottles = transpose(transpose.(load.(download.(bottle))))
	Fruits = load.(download.(fruit))
end

# ╔═╡ 57d0509d-5b15-4fb6-976f-96b24d3ffa4c
begin
	arrange
	
	shuffle(rng, Bottles)
	
end

# ╔═╡ 2f28ba0a-56be-443a-8250-a837fd25f601
if show_all_permutations
	collect(permutations(Bottles))
end

# ╔═╡ 70bb4336-ce69-4e3f-ba86-6ccc9064c2ce


# ╔═╡ 76b890f2-e995-440c-9470-5d8bbee5ddd9
imresize(Bottles[1],300,300)

# ╔═╡ Cell order:
# ╟─d2b8ddf9-4761-4f05-a19e-59db50ec5694
# ╟─57d0509d-5b15-4fb6-976f-96b24d3ffa4c
# ╟─958b8590-75b7-4a37-8661-5f230f6026a4
# ╟─2f28ba0a-56be-443a-8250-a837fd25f601
# ╟─ae23d612-0be7-4c69-ab11-9158a8b215b2
# ╟─f18c200e-bb37-4de2-8be9-26b8b4f28dc0
# ╟─54177438-53b8-4a3a-94ed-70c64b607424
# ╟─79cd1cb8-569f-4d24-aef5-76d841bb6c65
# ╟─d71ed580-cdbc-11eb-08ab-11e87cff1cb9
# ╟─476521e1-fbdb-40f3-b133-2df5acca59bc
# ╟─85c95bb5-8503-4af0-ba35-cbcc8bdc164e
# ╟─a3c995ff-b2e6-4b87-b801-347eaa07e72d
# ╟─ca4d4e9f-5e7a-417f-944a-7f6a80ecd2ff
# ╠═2faeccea-1e90-4eea-a1d7-7d644a6fa809
# ╠═70bb4336-ce69-4e3f-ba86-6ccc9064c2ce
# ╠═76b890f2-e995-440c-9470-5d8bbee5ddd9
