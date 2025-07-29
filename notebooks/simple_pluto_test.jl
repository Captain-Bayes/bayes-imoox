### A Pluto.jl notebook ###
# v0.20.13

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

# ╔═╡ fc79aa90-6c54-11f0-3302-e3adcb79d6a7
begin
	using Pkg
	Pkg.activate(joinpath(DEPOT_PATH[1], "environments/v1.11"))

	using PlutoUI
	using Plots
end


# ╔═╡ 27b07641-8748-4389-8e55-a535d97d363f
@bind x Slider(1:10)

# ╔═╡ 136c134a-47c7-48d4-a668-daacc5f31a9b
md"""
# Hello World
In this notebook you can combine LaTeX $x = 3$ and interpolation x: $(x)
"""

# ╔═╡ Cell order:
# ╠═fc79aa90-6c54-11f0-3302-e3adcb79d6a7
# ╠═136c134a-47c7-48d4-a668-daacc5f31a9b
# ╠═27b07641-8748-4389-8e55-a535d97d363f
