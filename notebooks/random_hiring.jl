### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ ac65c4de-58f3-11eb-00c2-f9f83a4c01a2
using PlutoUI

# ╔═╡ 5580aee0-6165-11eb-2967-ff278167c8d5
md"""
#### Random hiring
Captain Bayes: **To become a member of my crew please show how well you can produce random numbers. Proof your randomness!**

👉 Enter **200 digits** ´0-9´ in the textbox below!

$$G(x,y)=\frac{1}{2\pi \sigma^2}e^{\frac{-(x^2+y^2)}{2\sigma^2}}$$
"""

# ╔═╡ be49b1d0-58f3-11eb-1770-23439de5d5b9
@bind random_string TextField((40, 5); default="")

# ╔═╡ 57cfdfc0-6149-11eb-19bd-5f941bb1d8a5
@bind test Slider(0:10)

# ╔═╡ 2e10cb10-61a6-11eb-2f51-6b30066a00e6
HTML("<div><br><br><br><br><br><br><br></div>")

# ╔═╡ 4a826c10-6163-11eb-0077-fb171c3a7379
begin
	function arra(inp)
	try 
			if length(inp) == 0
				[]
			else
				parse.(Int,split(inp, "")) 
			end
	catch 
		0
	end
	end
end

# ╔═╡ 6650f3d2-6163-11eb-27e8-d7db2c942e54
arr = arra(random_string)

# ╔═╡ e76f7270-58f3-11eb-37b2-fd410fcf6082
 

# ╔═╡ df0e72f0-58f5-11eb-0e71-f7978d71a236
md"TODOs: Catch error of non entering a digit!"

# ╔═╡ 697e0370-58f5-11eb-3da4-510b6c3d0118
length(arr) + test

# ╔═╡ ecc1d590-58f5-11eb-1583-7d6ca45be736
md"Write code to evaluate randomness of input"

# ╔═╡ dba94ef0-58f5-11eb-1857-cf90de0c4e14
prob = rand()

# ╔═╡ d37c5710-6163-11eb-36c6-dde1fbcc2099

if arr == 0
	
	md"""
!!! danger "Wrong characters!"
    **Please enter digits**: 0, 1, 2, 3, 4, 5, 6, 7 ,8 ,9
	"""

	else
		if isempty(arr)
	Markdown.MD(Markdown.Admonition("warning", "Hiring task!", [md"Please enter 200 digits below in the textbox."]))
elseif length(arr) == 200
	#!!! correct "Completed!" 
		
	#Captain Bayes asserts your random series stems from a good flat random generator with a probability of **$(prob)** %
	Markdown.MD(Markdown.Admonition("correct", "Completed!", [md"Captain Bayes asserts your random series stems from a good flat random generator with a probability of **$(prob)** %"]))
else
		Markdown.MD(Markdown.Admonition("warning", "Hiring task!", [md"Please enter $(200-length(arr)) digits below in the textbox."]))
end
	
end

# ╔═╡ Cell order:
# ╟─ac65c4de-58f3-11eb-00c2-f9f83a4c01a2
# ╟─5580aee0-6165-11eb-2967-ff278167c8d5
# ╟─d37c5710-6163-11eb-36c6-dde1fbcc2099
# ╠═be49b1d0-58f3-11eb-1770-23439de5d5b9
# ╠═57cfdfc0-6149-11eb-19bd-5f941bb1d8a5
# ╟─2e10cb10-61a6-11eb-2f51-6b30066a00e6
# ╟─4a826c10-6163-11eb-0077-fb171c3a7379
# ╟─6650f3d2-6163-11eb-27e8-d7db2c942e54
# ╠═e76f7270-58f3-11eb-37b2-fd410fcf6082
# ╠═df0e72f0-58f5-11eb-0e71-f7978d71a236
# ╠═697e0370-58f5-11eb-3da4-510b6c3d0118
# ╠═ecc1d590-58f5-11eb-1583-7d6ca45be736
# ╠═dba94ef0-58f5-11eb-1857-cf90de0c4e14
