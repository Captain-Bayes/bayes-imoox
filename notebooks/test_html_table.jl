### A Pluto.jl notebook ###
# v0.14.1

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

# ╔═╡ 0fe07ad2-dd62-40cd-abf6-0bd44bc43aa4
#add packages
begin
	try
using HypertextLiteral
using PlutoUI
#using Plots

catch 
using Pkg
Pkg.activate(mktempdir())
#Pkg.add("Plots")
Pkg.add("HypertextLiteral")
Pkg.add("PlutoUI")
#using Plots
using HypertextLiteral
using PlutoUi
#plotly()
	end
	md"Packages"
end

# ╔═╡ e023d584-b95b-4e45-bbba-497c175e4e08
html"""
	<style>
	.compasstable td {
		font-size: 30px;
		text-align: center;
	}
	
	</style>
"""

# ╔═╡ 4978f47b-2da3-4cd7-b9f9-f7747de17ec1
begin
	# used to reset the compass to make it fair again, when entering the next section
	
	W1 = @bind W Scrubbable(0:1:3, default=1)
	N1 = @bind N Scrubbable(0:1:3, default=1)
	E1 = @bind E Scrubbable(0:1:3, default=1)
	S1 = @bind S Scrubbable(0:1:3, default=1)
	
	md"define tablestyle"
end

# ╔═╡ 55abd7c5-235f-41d0-ac2b-056989845148
md"""
# Minimal example 

#### if **htl table** (Package HypertextLiteral) works with PlutoSliderServer

🔼: $(N1), 

▶: $(E1), 

🔽: $(S1), 

◀: $(W1)"""

# ╔═╡ a6cc31b0-9d70-11eb-3a8f-a3e534ed0eeb
@htl("""
<table class="compasstable">
	
    <tbody>
        <tr>
            <td></td>
            <td style="text-align:center">	$(N1)</td>
            <td></td>
        </tr>
        <tr>
            <td>$(W1)</td>
            <td><img src="https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_empty.png" width=200></td>
            <td>$(E1)</td>
        </tr>
        <tr>
            <td></td>
            <td style="text-align:center">	$(S1)</td>
            <td></td>
        </tr>
    </tbody>
</table>
""")

# ╔═╡ Cell order:
# ╟─0fe07ad2-dd62-40cd-abf6-0bd44bc43aa4
# ╟─55abd7c5-235f-41d0-ac2b-056989845148
# ╟─a6cc31b0-9d70-11eb-3a8f-a3e534ed0eeb
# ╟─e023d584-b95b-4e45-bbba-497c175e4e08
# ╟─4978f47b-2da3-4cd7-b9f9-f7747de17ec1
