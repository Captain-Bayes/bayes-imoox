### A Pluto.jl notebook ###
# v0.19.27

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

# ╔═╡ 296494d0-22fa-11ee-248c-3be6c0b8d5c2
begin
	using PlutoUI
	using PlutoExtras
	using MarkdownLiteral: @mdx
	using HypertextLiteral
	#using HypertextLiteral: @htl
end

# ╔═╡ ae4850e7-13a5-4e86-8adf-7b1d90697d74
TableOfContents()

# ╔═╡ 09082528-2796-4623-9077-0a2178a86fee
md"""
# How to write a supercool Sample notebook 🎈
- Use emojis 🎠 [^1]
- Make it interactive and fun 🎉
- Make it reuseable ♻
- Make it digestable like a tappa 🌮 (not too long)

[^1]: on Windows try the key combination: `Windows` + `.`\
	on Linux there are cool packages to install
"""

# ╔═╡ f4c3b3d0-95a1-4e1b-a954-0c4a4b534137
md"""
## ❓ Open Questions: 
- Which Packages should you use by default to make a cool Sample notebook (for the descriptive part)
"""

# ╔═╡ 4500295c-4bcb-4a2f-8234-d7c94d9f24fd
md"""
# Markdown in Pluto
"""

# ╔═╡ c0312ce7-813c-4fae-aa5e-df8bd9614aae
md"""
## Latex within Markdown
You can:
- use dollar signs 💲💲💲:  $x+2$
- use backticks \` :  ``x + 2``
Dollar signs are also used for interpolation to get variables inside markdown: $x \
Best practise is to use backticks to include latex in Markdown
"""

# ╔═╡ 02cf38ef-f4c6-4098-8f73-f9d9135ce99c
md"""
bad usage of dollar signs for latex:
- spaces between dollar signs and latex code: $ x + 2 $
- `$x + 2 $` will also break as `$x` is interpreted as interpolation
"""

# ╔═╡ 52f73ca8-0d4a-4e79-ba0e-42eef137d306
x = 4.324908

# ╔═╡ 555a3e5c-81ca-4390-940a-7b72c3c015dc
md"""

"""

# ╔═╡ b6c31b8c-7f09-4fba-9292-804a4222e93b
md"""
### Adding Latex to Plots (Plots, Makie, Plotly)
"""

# ╔═╡ 1243ec14-1db2-47ca-8c22-c698e094f24e
md"""
- $x + 3 $ 

instead of $x+3$
"""

# ╔═╡ bd41ede5-facd-4826-9707-f27fcf0a2bbb
md"""
## Interpolation within Markdown
or how to integrate calculated values or objects (Slider) within Markdown
"""

# ╔═╡ 93d92e1c-3274-4454-a4bc-7c93b93d24dd
md"""
## Simple interpolation
"""

# ╔═╡ 73c3cdaf-0227-4adf-ab06-e28e777aad9f
md"""
### Interpolating of variables within LaTeX
The issue: The combination ``x = `` $(x) doesn't look good
"""

# ╔═╡ 128cf322-c5ad-452d-8b02-d2c8860b72aa
md"""
Interpolation of variables into LaTex does not work out of the box: \
``x = $(x)``\
(Note: within normal Markdown you don't have to escape backslashes)
"""

# ╔═╡ eeda2a5d-9cf3-4c9a-a097-e38c553c31d0
Markdown.parse("""
You can either use Markdown parse: \\
``x = $(x)``\\
(Note: you have to escape backslashes)
""")

# ╔═╡ 139b45ab-5dbd-4989-805d-868b32ce2366
@mdx("""
Or use the Package MarkdownLiteral with the makro @mdx: \\
``x = $(x)`` \\
(Note: you have to escape backslashes)
""")

# ╔═╡ fd6bbdb6-566a-4d81-81bf-aa226b47c684
md"""
The thing with the backslash is annoying, 
👉 maybe you can change this
"""

# ╔═╡ 82dea67f-e31e-4429-b447-58d733e6500e
md"""
## Different spacings and headings in Markdown
"""

# ╔═╡ 097abf3e-dad5-4330-a47d-6954ff58fc5d
md"""
### Spacings
To write a paragraph just leave a blank line

If you start your next paragraph you will have a spacing between the two texts.\
If you just want to start your next sentence\
in the next line use a backslash `\` at the end of the line

> A highlighted paragraph

``` julia
# some julia code
function text()
	return "asdf"
end
```

A formula (use backticks):
``` math
\int_0^\infty \frac{1}{x^2} dx
```
You could also use dollar signs but avoid it:

$\int_0^\infty \frac{1}{x^2} dx$
"""

# ╔═╡ 36a41a5c-a164-4fe9-91bf-81a33e1e4747
html"""
<style>
    pluto-output p, pluto-output br {
        line-height: 1.45em;
    }
    pluto-output br {
        margin-block-end: 0;
    }
</style>
"""

# ╔═╡ e3ca6351-ba63-438b-a270-07f0db7b9d8a
md"""
asdf

asdf \
asdfasdf
"""

# ╔═╡ 6a07d446-a58f-453e-aa29-462f28bb84ce
md"""
# Binds
"""

# ╔═╡ 7788b1c0-a100-4e12-8172-3611e1787612
"""
Like `@bind` in Pluto, but it also displays the name of the variable.
"""
macro bindname(name::Symbol, ex::Expr)
    quote
        HypertextLiteral.@htl("""
        <div style='display: flex;  flex-wrap: wrap; align-items: baseline;'>
        <code style='font-weight: bold'>$($(String(name))):</code>&nbsp$(@bind $(name) $(esc(ex)))
        </div>
        """)
    end
end

# ╔═╡ de967daf-7b5b-46fc-9d1f-d45fabec8557
@bindname t Slider(1:10, show_value = true, show_name = true)

# ╔═╡ 9007adf6-ad39-4618-bd03-4f408f71956c
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
MarkdownLiteral = "736d6165-7244-6769-4267-6b50796e6954"
PlutoExtras = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
MarkdownLiteral = "~0.1.1"
PlutoExtras = "~0.7.5"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "6c1807a6331b78d1c91a000bc1eed080b0a815ef"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "PrecompileTools", "URIs"]
git-tree-sha1 = "532c4185d3c9037c0237546d817858b23cf9e071"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.12"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MarkdownLiteral]]
deps = ["CommonMark", "HypertextLiteral"]
git-tree-sha1 = "0d3fa2dd374934b62ee16a4721fe68c418b92899"
uuid = "736d6165-7244-6769-4267-6b50796e6954"
version = "0.1.1"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Pkg", "Random", "TOML"]
git-tree-sha1 = "44b59480bdd690eb31b32f4ba3418e0731145cea"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.5.5"

[[deps.PlutoExtras]]
deps = ["AbstractPlutoDingetjes", "HypertextLiteral", "InteractiveUtils", "Markdown", "OrderedCollections", "PlutoDevMacros", "PlutoUI", "REPL"]
git-tree-sha1 = "4df3a485d53900720b052b3dc30225ed5ab4204b"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.7.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═296494d0-22fa-11ee-248c-3be6c0b8d5c2
# ╠═ae4850e7-13a5-4e86-8adf-7b1d90697d74
# ╟─09082528-2796-4623-9077-0a2178a86fee
# ╟─f4c3b3d0-95a1-4e1b-a954-0c4a4b534137
# ╟─4500295c-4bcb-4a2f-8234-d7c94d9f24fd
# ╟─c0312ce7-813c-4fae-aa5e-df8bd9614aae
# ╠═02cf38ef-f4c6-4098-8f73-f9d9135ce99c
# ╠═52f73ca8-0d4a-4e79-ba0e-42eef137d306
# ╠═555a3e5c-81ca-4390-940a-7b72c3c015dc
# ╟─b6c31b8c-7f09-4fba-9292-804a4222e93b
# ╠═1243ec14-1db2-47ca-8c22-c698e094f24e
# ╟─bd41ede5-facd-4826-9707-f27fcf0a2bbb
# ╠═93d92e1c-3274-4454-a4bc-7c93b93d24dd
# ╠═73c3cdaf-0227-4adf-ab06-e28e777aad9f
# ╠═128cf322-c5ad-452d-8b02-d2c8860b72aa
# ╠═eeda2a5d-9cf3-4c9a-a097-e38c553c31d0
# ╠═139b45ab-5dbd-4989-805d-868b32ce2366
# ╠═fd6bbdb6-566a-4d81-81bf-aa226b47c684
# ╟─82dea67f-e31e-4429-b447-58d733e6500e
# ╠═097abf3e-dad5-4330-a47d-6954ff58fc5d
# ╠═36a41a5c-a164-4fe9-91bf-81a33e1e4747
# ╠═e3ca6351-ba63-438b-a270-07f0db7b9d8a
# ╠═6a07d446-a58f-453e-aa29-462f28bb84ce
# ╠═7788b1c0-a100-4e12-8172-3611e1787612
# ╠═de967daf-7b5b-46fc-9d1f-d45fabec8557
# ╠═9007adf6-ad39-4618-bd03-4f408f71956c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
