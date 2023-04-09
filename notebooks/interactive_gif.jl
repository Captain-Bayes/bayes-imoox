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

# ╔═╡ ec27106b-574e-4f76-a701-afe08165d984
md"""
# Change of slope
"""

# ╔═╡ 8883936b-cda0-42a9-b514-b80b140d466e
md"""
#### Enter the function: ``y(x) = `` 👉 $(@bind text_equation confirm(PlutoUI.TextField(50,default = " x^3/100 + b * x^2/10 -3*x + 4")))
"""

# ╔═╡ f7e39d29-4391-4f68-9d6e-bab9c815e87b
md"""
#### Choose the parameter of ``x_b``: 👉 $(@bind x_point Scrubbable(0:0.2:10))
"""

# ╔═╡ 538a435b-12a8-413e-82ac-792e1805bfc1
md"""
#### Choose the parameter of ``b\, ``: 👉 $(@bind b_val Slider(0:0.1:10, show_value = true)) 
to match the desired slope
"""
#to match the desired slope at ``x = 5`` 

# ╔═╡ 73bc4715-f9fd-4d79-bbe8-0bf77302eba4
begin 
	
	plot(x_range, y_val, linewidth = 3, label = latexstring("\\textrm{Polynom:} y(x)=") * equation, legendfont = font(14,"Computer Modern"), title = "Find " * latexstring(b) * " so that " * latexstring("y'($(x_point)) = 2"), titlefont = font(20,"Computer Modern"), legend = :top)
	plot!(x_range, slope .* x_range .+ y_point .- x_point*slope, linewidth = 2, style = :dash, alpha = 0.7, label = latexstring("\\textrm{Slope:} y'($(x_point)) = $(round(slope, digits = 2))"), xlabel = latexstring("x"), ylabel = latexstring("y(x)"), guidefont = font(14, "Computer Modern"), tickfont = font(10, "Computer Modern"))
	plot!([x_point], [y_point], marker = :o, label = :none, ylim = [-25, 70])
end

# ╔═╡ ce7a1670-b149-11ed-28d4-a1fc1ed88df8
begin
	using PlutoUI
	using Plots
	using PlutoTeachingTools
	using PlutoTest
	using Symbolics
	using SymbolicUtils
	using MarkdownLiteral: @mdx
	using MacroTools
	using LaTeXStrings
end

# ╔═╡ 09a37561-fd16-4d4c-8963-82d7de82cccb
Meta.parse(text_equation)

# ╔═╡ f1683762-9f2d-44e2-a0b9-7f0458fcdb3e
func = Meta.parse(text_equation)#:( x^3/100 + b * x^2/10 -3*x + 4)

# ╔═╡ 4e53ab3a-2d58-4337-9709-ff14cf64fcca
eval(func)

# ╔═╡ 9188b13a-7f3a-4091-baa6-e37cedd65e64
equation = (Symbolics.latexify(func))

# ╔═╡ 6bf0389f-1570-436f-84d2-ef7e13b1ff77
equation2 = replace(equation[1:end], "b" => "{\\color{blue}b}")

# ╔═╡ a9374295-1653-49b5-9125-bb5735f40e15
latexstring(equation2)

# ╔═╡ d01377fa-46c7-4360-8a3b-8e5eed74d778
slope = Symbolics.value(substitute(Symbolics.derivative(eval(func), x), Dict(x=> x_point, b => b_val)))

# ╔═╡ 29c3c90a-8018-4c20-a8b2-6405a42aa9d4
y_point = Symbolics.value(substitute(eval(func), Dict(x=> x_point, b => b_val)))

# ╔═╡ ea32ed15-e68d-45d6-a78a-860235d8cd98
y_val = [eval(MacroTools.replace(MacroTools.replace(func, :x, i), :b, b_val)) for i in x_range]

# ╔═╡ c327c42d-a27d-43ef-b844-e92128db56f9
begin
	x_range = 0:0.1:10
	#y_val = [substitute(eval(func), Dict(x=>i, b => b_val)) for i in x_range]
end

# ╔═╡ 0a295743-1e5d-42a6-8987-102d02f896f5
LaTeXStrings.latexstring("\\text{test} \\color{blue}{y}(x)")

# ╔═╡ 24fb240d-e070-4743-9dd5-101d4b6e6f15


# ╔═╡ 887e671e-ba63-4225-9261-2131ae5d8666
left_part = :((x^2 - 1)/(3x^2))

# ╔═╡ 1dd7e413-0106-40ee-a3a7-c701bf4b643e
@variables x

# ╔═╡ 5e101611-2618-478d-b164-c7afa1e87bac
Symbolics.latexify(left_part)

# ╔═╡ 1422565e-82e5-4e02-91e6-903c4e16406e
typeof(left_part)

# ╔═╡ ca3058da-4ec9-462b-bb00-cae29a05c730
rs = PlutoTest.prettycolors.(PlutoTest.@pretty_step_by_step((1-x^2)/(3x^2)) )

# ╔═╡ 887c9c1d-4ff3-4277-9742-d5f51112027c
PlutoTest.frames(rs)

# ╔═╡ e7f51c4a-2555-45a3-bd67-3a4bcf3c6745
@mdx("""
$(rs[8])
""")

# ╔═╡ 4d50da4a-cd6d-4e03-be97-ec57903997da
begin
c = Symbolics.latexify(1/( x -1)^2 == 3/(x^2-1) - 2/(x^2+x))
end

# ╔═╡ a2590e99-68b3-4f3d-9f0b-87ba89f981f0
typeof(c)

# ╔═╡ f120355b-c356-4938-a3a7-21cebe572071
latexify_md(1/(x^2-1))

# ╔═╡ b9d2d437-1e35-4abd-ac5a-23129b9399c2
left = round(1/( x_var -1)^2, digits = 4)

# ╔═╡ 66c9b974-95a9-430c-b490-728a150ac7fb
right = round(3/(x_var^2-1) - 2/(x_var^2+x_var), digits = 4)

# ╔═╡ 3fa025db-f9b1-4f56-a6b0-b47f2bb88af6
@mdx("""
test
""")

# ╔═╡ 80ea3abd-7b4c-4344-89dc-aa322cbe6733
md"""
``x =  `` $(@bind x_var Slider(0.01:0.01:20, show_value = true))
"""

# ╔═╡ c3ab0ec0-fbc4-49e9-aa8e-7c34691b9c97
@mdx("""
``` math
\\begin{align} \\frac{1}{\\left(  x-1 \\right)^{2}} &= \\frac{3}{ x^{2}-1} - \\frac{2}{x + x^{2}}  \\\\[0.4cm]
$(left) \\quad &= \\quad $(right)
\\end{align}
```
""")

# ╔═╡ 77c88fa7-9ca7-45fb-8cb4-0560b5da3c65
begin
	time = 0:0.01:200
	plot(time, 1 ./( time .- 1).^2, label = "left side",linewidth = 2, size = (700,300))
	plot!(time,3 ./(time.^2 .- 1) - 2 ./(time.^2+time), linewidth = 2,label = "right side", ylim = [0,5])


end

# ╔═╡ e195238f-fdf0-434a-a932-6d63771bbe35
@test (3 + x)^2 * -(8x+2) /(4+x*(2+3x)) == -25.2972972972973

# ╔═╡ cbb75891-ad6a-4acf-8dd7-c90cd3f0a5d0


# ╔═╡ cd224621-7da3-444a-8c82-514326246959
(3 + x)^2 * -(8x+2) /(4+x*(2+3x))

# ╔═╡ 8f4daf19-4942-4ae1-a382-f6e6e661e1c0
@variables y, t

# ╔═╡ b9261ce0-8da2-49b4-aa3e-34c20ec0e50a
@test y^2 + (3y+4t)^2/(2y + 3)

# ╔═╡ 16371f15-0cc2-433b-9e84-b13dfd118b4b
@test Symbolics.simplify(y^2 + (3y+4)^2/(2y + 3 + x))

# ╔═╡ 444ab34c-6309-4d9f-af25-236b5dd0af95
Symbolics.term(y^2 + (3y+4)^2/(2y + 3 + x))

# ╔═╡ f6cd56e4-188a-4ecf-9cc8-9c6d9b0fd15c
Symbolics.simplify(y^2 + (3y+4)^2/(2y + 3 + x),  expand=true)

# ╔═╡ 5cb4683d-21ef-4d4c-9794-0bb9e81a021f
y^2 + (3y+4)^2/(2y + 3 + x)

# ╔═╡ 49f3b955-0389-434f-bbe8-994726c46a2c
@test Symbolics.simplify((3y+t)*(4-y) + (t*y + 1), expand = true)

# ╔═╡ 5e9ad0ed-1872-4494-bd6e-0a0991e8518f
SymbolicUtils.@syms a b 

# ╔═╡ 4a91ed45-f574-4306-8e9b-1b528a910d08
@test SymbolicUtils.expand((3a + 4b) * (4-2a*b))

# ╔═╡ Cell order:
# ╟─ec27106b-574e-4f76-a701-afe08165d984
# ╟─8883936b-cda0-42a9-b514-b80b140d466e
# ╟─f7e39d29-4391-4f68-9d6e-bab9c815e87b
# ╟─538a435b-12a8-413e-82ac-792e1805bfc1
# ╟─73bc4715-f9fd-4d79-bbe8-0bf77302eba4
# ╟─ce7a1670-b149-11ed-28d4-a1fc1ed88df8
# ╠═09a37561-fd16-4d4c-8963-82d7de82cccb
# ╠═f1683762-9f2d-44e2-a0b9-7f0458fcdb3e
# ╠═4e53ab3a-2d58-4337-9709-ff14cf64fcca
# ╠═9188b13a-7f3a-4091-baa6-e37cedd65e64
# ╠═6bf0389f-1570-436f-84d2-ef7e13b1ff77
# ╠═a9374295-1653-49b5-9125-bb5735f40e15
# ╠═d01377fa-46c7-4360-8a3b-8e5eed74d778
# ╠═29c3c90a-8018-4c20-a8b2-6405a42aa9d4
# ╠═ea32ed15-e68d-45d6-a78a-860235d8cd98
# ╠═c327c42d-a27d-43ef-b844-e92128db56f9
# ╠═0a295743-1e5d-42a6-8987-102d02f896f5
# ╠═24fb240d-e070-4743-9dd5-101d4b6e6f15
# ╠═887e671e-ba63-4225-9261-2131ae5d8666
# ╠═1dd7e413-0106-40ee-a3a7-c701bf4b643e
# ╠═5e101611-2618-478d-b164-c7afa1e87bac
# ╠═1422565e-82e5-4e02-91e6-903c4e16406e
# ╠═ca3058da-4ec9-462b-bb00-cae29a05c730
# ╠═887c9c1d-4ff3-4277-9742-d5f51112027c
# ╠═e7f51c4a-2555-45a3-bd67-3a4bcf3c6745
# ╠═4d50da4a-cd6d-4e03-be97-ec57903997da
# ╠═a2590e99-68b3-4f3d-9f0b-87ba89f981f0
# ╠═f120355b-c356-4938-a3a7-21cebe572071
# ╠═b9d2d437-1e35-4abd-ac5a-23129b9399c2
# ╠═66c9b974-95a9-430c-b490-728a150ac7fb
# ╠═3fa025db-f9b1-4f56-a6b0-b47f2bb88af6
# ╟─80ea3abd-7b4c-4344-89dc-aa322cbe6733
# ╟─c3ab0ec0-fbc4-49e9-aa8e-7c34691b9c97
# ╠═77c88fa7-9ca7-45fb-8cb4-0560b5da3c65
# ╠═e195238f-fdf0-434a-a932-6d63771bbe35
# ╠═cbb75891-ad6a-4acf-8dd7-c90cd3f0a5d0
# ╠═cd224621-7da3-444a-8c82-514326246959
# ╠═8f4daf19-4942-4ae1-a382-f6e6e661e1c0
# ╠═b9261ce0-8da2-49b4-aa3e-34c20ec0e50a
# ╠═16371f15-0cc2-433b-9e84-b13dfd118b4b
# ╠═444ab34c-6309-4d9f-af25-236b5dd0af95
# ╠═f6cd56e4-188a-4ecf-9cc8-9c6d9b0fd15c
# ╠═5cb4683d-21ef-4d4c-9794-0bb9e81a021f
# ╠═49f3b955-0389-434f-bbe8-994726c46a2c
# ╠═5e9ad0ed-1872-4494-bd6e-0a0991e8518f
# ╠═4a91ed45-f574-4306-8e9b-1b528a910d08
