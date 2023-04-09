### A Pluto.jl notebook ###
# v0.19.23

using Markdown
using InteractiveUtils

# ╔═╡ 744c848b-15ac-415d-aef6-5244be5ed981
md"""
$(Resource(gihan, :width => 500))
## Ich bin Gihan, ich bin Grafikerin 🖌 und liebe Pixel Art 🎨

"""

# ╔═╡ 4f94136c-6dd3-4bb8-8a20-4a5a8162a74b
hide_everything_below

# ╔═╡ 7ccc9cae-60eb-4675-8cef-36467159917c
gihan = "https://github.com/dorn-gerhard/workAdventure/raw/master/Characters/Gihan.jpg"

# ╔═╡ 846d334a-e5ab-484a-832f-731c1290356f
begin
	using PlutoUI
end

# ╔═╡ cd4d9216-5fc5-4bb3-a3f8-a0852a576866
begin
hide_everything_below =
	html"""
	<style>
	pluto-cell.hide_everything_below ~ pluto-cell {
		display: none;
	}
	</style>
	
	<script>
	const cell = currentScript.closest("pluto-cell")
	
	const setclass = () => {
		console.log("change!")
		cell.classList.toggle("hide_everything_below", true)
	}
	setclass()
	const observer = new MutationObserver(setclass)
	
	observer.observe(cell, {
		subtree: false,
		attributeFilter: ["class"],
	})
	
	invalidation.then(() => {
		observer.disconnect()
		cell.classList.toggle("hide_everything_below", false)
	})
	
	</script>
	""";
	
md"definition hide everything below"
end

# ╔═╡ 3d2991b0-f64a-11ec-20c7-912cad47a057


html"""
<style>
	body, main, pluto-notebook, nav.plutoui-toc.aside.indent {
		background-color: white
	}
</style>
"""

# ╔═╡ Cell order:
# ╟─744c848b-15ac-415d-aef6-5244be5ed981
# ╟─4f94136c-6dd3-4bb8-8a20-4a5a8162a74b
# ╠═7ccc9cae-60eb-4675-8cef-36467159917c
# ╠═846d334a-e5ab-484a-832f-731c1290356f
# ╠═cd4d9216-5fc5-4bb3-a3f8-a0852a576866
# ╠═3d2991b0-f64a-11ec-20c7-912cad47a057
