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
# Markov processes and the rat onboard
	
Unfortunately this notebook is not realized yet. 
For encouraged students there is the possibility to join the creation process of such an interactive Pluto Notebook - just contact  _gerhard.dorn@tugraz.at_
	
"""
	
end

# ╔═╡ 251d3b57-61b0-4089-af68-8d3b0c4e47d3
#check if work with Binder
using Plots

# ╔═╡ 6ccb0a01-0735-4fcd-a388-b113fb4a8174
using PlutoUI

# ╔═╡ 9cee5c51-8de1-4a1a-82c3-2f7c6fb10ccc
@bind a Slider(2:10)

# ╔═╡ 9e61066c-3d0a-47e4-bb35-fba18649ae0b
a

# ╔═╡ 63d20373-940b-4bef-bd36-b1931a71b79e
plot(rand(3))


# ╔═╡ Cell order:
# ╟─08f70290-9dfb-11eb-31da-8d381c54dd70
# ╠═251d3b57-61b0-4089-af68-8d3b0c4e47d3
# ╠═6ccb0a01-0735-4fcd-a388-b113fb4a8174
# ╠═9cee5c51-8de1-4a1a-82c3-2f7c6fb10ccc
# ╠═9e61066c-3d0a-47e4-bb35-fba18649ae0b
# ╠═63d20373-940b-4bef-bd36-b1931a71b79e
