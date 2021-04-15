### A Pluto.jl notebook ###
# v0.14.2

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

# ╔═╡ 429cffb0-9d72-11eb-0722-8b23c24be58a
#add packages
begin
	try
#using HypertextLiteral
using PlutoUI
#using Plots

catch 
using Pkg
Pkg.activate(mktempdir())
#Pkg.add("Plots")
#Pkg.add("HypertextLiteral")
Pkg.add("PlutoUI")
#using Plots
#using HypertextLiteral
using PlutoUi
#plotly()
	end
	md"Packages"
end

# ╔═╡ 38aa1430-3456-4980-bc15-d50f8f7d4bdf
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

# ╔═╡ 431f88fd-32e7-4e9e-b7fe-e9113d1f338a
md"""$(@bind dial ClickCounterWithReset("Dial!", "Start over!"))"""

# ╔═╡ 298483e9-3871-498e-b231-91cf68da8abf
md"""
# Minimal example 

#### if new Interactive widget **ClickCounterWithReset**does work with PlutoSliderServer

dial: $(dial)"""

# ╔═╡ 02a6c890-ff1f-48de-9915-14de46dac7bc
begin
	dial
	
	md"some text...
	
this cell contains the variable that is changed by the button, so this cell is always updated the moment the button is pressed."
	
end


# ╔═╡ Cell order:
# ╟─429cffb0-9d72-11eb-0722-8b23c24be58a
# ╟─298483e9-3871-498e-b231-91cf68da8abf
# ╟─431f88fd-32e7-4e9e-b7fe-e9113d1f338a
# ╟─38aa1430-3456-4980-bc15-d50f8f7d4bdf
# ╟─02a6c890-ff1f-48de-9915-14de46dac7bc
