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

# ╔═╡ 08f70290-9dfb-11eb-31da-8d381c54dd70
begin
md"""
# RESET of Checkbox - SliderServerTest	
"""
	
end

# ╔═╡ 251d3b57-61b0-4089-af68-8d3b0c4e47d3
begin
using Plots
using PlutoUI
using HypertextLiteral
end

# ╔═╡ 9cee5c51-8de1-4a1a-82c3-2f7c6fb10ccc
md" Variable ``a_0``: $(b_0)\
Variable ``a_1``: $(b_1)\
Variable ``a_2``: $(b_2)\
for the evaluation of: 

$y(x) = a_2 x^2 + a_1 x + a_0$
"

# ╔═╡ 69802269-a887-4191-9cfd-9e4964615c89
md"
# Where is the maximum?
Where might be the maximum of the following function?

You can change its parameters by dragging the numbers

``y(x) = ``$(b_2) ``x^2 + `` $(b_1) ``x+`` $(b_0)
"

# ╔═╡ a260cd58-1986-4456-9fd9-f6be7dfb67a6
if show_results
	x = -10:0.01:10
	plot(x, y.(x), size = (300,200))
end

# ╔═╡ ac637700-eff2-410e-9371-abcf9fda7506
md"
Before to show plot, guess where the maximum is:

``y_{\text{max}}`` at ``\quad x < -5\quad\quad\quad\,`` 👉 $(@bind smaller CheckBox())

``y_{\text{max}}`` in ``\quad -5 < x < 5\quad`` 👉 $(@bind middle CheckBox())

``y_{\text{max}}`` at  ``\quad 5 < x\quad\quad\qquad`` 👉 $(@bind greater CheckBox())
"

# ╔═╡ 313964f7-994b-4363-824f-e7df509817be
begin 
	
	y(x) = a₂ * x^2 + a₁ * x + a₀
	der_y(x) = a₂ * x + a₁
	maxi = -a₁/a₂
	if maxi < -5
		if middle || greater
			keep_working()
		elseif smaller
			correct()
			
		end
			
			
		
	elseif maxi < 5
		if smaller || greater
			keep_working()
		elseif middle
			correct()
		end
	else
		if middle || smaller
			keep_working()
		elseif greater
			correct()
		end
		
	end
end

# ╔═╡ 9e61066c-3d0a-47e4-bb35-fba18649ae0b
md"""
Before to show plot, guess where the maximum is: 👉 $(show_results_box)\
**This checkbox is deactivated when changing any Scrubbable**
This creates an infinite loop.
"""

# ╔═╡ e45d11ee-1919-44cb-aea8-9a76e6370e55
begin
 a₀, a₁, a₂ #Variables from the Scrubbables
 show_results_box = @bind show_results CheckBox()
	md"Here we define the checkbox that will be **reset** upon change of any Scrubbable, "
end

# ╔═╡ c02b1e7d-1ea7-4eb2-8aad-ed89fc7ea970
a₂, a₁, a₀

# ╔═╡ 7bd3905d-4b0a-46a5-87ad-2c245eab6d40
begin
	b_0 = @bind a₀ Scrubbable(-10:10)
	b_1 = @bind a₁ Scrubbable(-10:10, default = 3)
	b_2 = @bind a₂ Scrubbable(-2:0.10001:2, default = 0.3)
end

# ╔═╡ ead93370-a917-4773-b517-1ccf0d5a3985
md" 
# Images
"

# ╔═╡ ed07623a-17ab-4edc-91e5-924df26bd756
Resource(lighthouse_gif, :width=>600)

# ╔═╡ e376ba52-b4c9-49ab-8808-bc333f9d199c
lighthouse_gif = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Lighthouse.gif"

# ╔═╡ dbfc41f6-203e-4862-9160-d442c9222471
md""" ![lighthouse](https://raw.githubusercontent.com/Captain-Bayes/images/main/Lighthouse.gif)"""

# ╔═╡ bfd7d2ac-0496-4253-825c-331561db8041
html"""<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/ABbv9g5kTdI" width=600 height=375  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>"""

# ╔═╡ 1e5dcccc-d105-4140-9d84-510a8bcedfdc
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

# ╔═╡ Cell order:
# ╟─08f70290-9dfb-11eb-31da-8d381c54dd70
# ╠═251d3b57-61b0-4089-af68-8d3b0c4e47d3
# ╟─9cee5c51-8de1-4a1a-82c3-2f7c6fb10ccc
# ╟─69802269-a887-4191-9cfd-9e4964615c89
# ╠═a260cd58-1986-4456-9fd9-f6be7dfb67a6
# ╟─ac637700-eff2-410e-9371-abcf9fda7506
# ╟─313964f7-994b-4363-824f-e7df509817be
# ╠═9e61066c-3d0a-47e4-bb35-fba18649ae0b
# ╠═e45d11ee-1919-44cb-aea8-9a76e6370e55
# ╠═c02b1e7d-1ea7-4eb2-8aad-ed89fc7ea970
# ╠═7bd3905d-4b0a-46a5-87ad-2c245eab6d40
# ╟─ead93370-a917-4773-b517-1ccf0d5a3985
# ╠═ed07623a-17ab-4edc-91e5-924df26bd756
# ╟─e376ba52-b4c9-49ab-8808-bc333f9d199c
# ╠═dbfc41f6-203e-4862-9160-d442c9222471
# ╠═bfd7d2ac-0496-4253-825c-331561db8041
# ╠═1e5dcccc-d105-4140-9d84-510a8bcedfdc
