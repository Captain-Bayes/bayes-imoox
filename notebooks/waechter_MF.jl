### A Pluto.jl notebook ###
# v0.19.9

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

# ╔═╡ 9d404ed6-a347-4166-8007-2843abefca6b
using PlutoUI

# ╔═╡ 6fb87691-58c1-498a-9563-6b92ee59b119
using Random

# ╔═╡ 44e1a3da-f563-11ec-2063-59169b0d3f06
md"# Der Wächter der Gründungsgarage taucht auf und spricht:"

# ╔═╡ 57057a91-685b-4ec8-ab6c-761a282579ea
md"
### **Wächter:** _Bist du für die Fragen bereit?_
"

# ╔═╡ a22fa1ee-0d08-4fea-985f-16f6826bc7ac
md"""
---
"""

# ╔═╡ f54cc3bd-f1e9-4191-8cd1-653dee77fc5b
waechter = "https://github.com/dorn-gerhard/workAdventure/raw/master/Characters/W%C3%A4chter/ritter_waechter_gif_large.gif"

# ╔═╡ 6e5c011b-89ae-4aff-aceb-d2ee253ab0a9
md"
$(Resource(waechter))
### **Wächter:** _Halt, so einfach wirst du da draußen in der Geschäftswelt nicht zurecht kommen. Ich helfe dir, wenn du mir zwei Fragen beantwortest..._"

# ╔═╡ b69c4db2-12ac-4ce0-ac02-ab44aa030359
md"
$(Resource(waechter, :width => 80)) 
### **Wächter:** _Über 10 Millionen € geben ÖsterreicherInnen pro Jahr für Nachhilfe aus. Kennst du auf diesem Markt deine Konkurrenz?_
"

# ╔═╡ 61c88bd8-5f87-4fc7-80c2-6f0206591641
md"""
$(Resource(waechter, :width => 80)) 
### **Wächter:** *Wow so viel Konkurrenz! So sagt mir, was macht euren Ansatz einzigartig?* 🦄
"""

# ╔═╡ fd4e7e37-fd2c-4566-a0df-2945f705a8f7
md"""
$(Resource(waechter))
### **Wächter:** *Du scheinst einen genialen Businessplan zu haben. Geh jetzt durch das Loch in der Wand* 👈 _und sieh in die **Kristallkugel**_  🔍
"""

# ╔═╡ 48fd8063-abba-472b-9bbe-ab801166fdb1


# ╔═╡ d029e415-ef80-437b-91c2-131065bbe923


# ╔═╡ f7387aeb-3968-4a81-85ab-19fbe29960cb


# ╔═╡ 6c5a176a-5ac2-463d-ab55-8c30c7a0f87e
begin
	nachhilfe_institut = "Go Student, Schülerhilfe, Lernquadrat"
	lernspiel = "Duolingo, Anton, SimpleClub"
	kursplattform = "EdX, Udemy, Brilliant"
	answers_2 = [nachhilfe_institut, kursplattform, lernspiel]
end

# ╔═╡ d08ef0b0-721e-4c2a-9223-de01269e86de
begin
keep_working(text=md"The answer is not quite right.", title="Keep working on it!") = Markdown.MD(Markdown.Admonition("danger", title, [text]));

almost(text, title="Almost there!") = Markdown.MD(Markdown.Admonition("warning", title, [text]));

hint(text, title ="Hint") = Markdown.MD(Markdown.Admonition("hint", title, [text]));
	
correct(text=md"Great! You got the right answer! Let's move on to the next section.", title="Got it!") = Markdown.MD(Markdown.Admonition("correct", title, [text]));
md" Definition of Boxes"
end

# ╔═╡ 13195864-0787-4a0a-8149-85967708fa57
reset_button = @bind res Button("Reset")

# ╔═╡ b227bc7a-2c6b-47e2-8091-ff41ce2e86c7
md"""
Wird eigentlich nicht angezeigt, wenn die Antwort richtig ist: $(reset_button)
"""

# ╔═╡ e228acb1-290b-45a3-9081-7de130818b11
reset_button2 = @bind res2 Button("Reset")

# ╔═╡ 0004f7fa-673c-4b4d-aecc-17c0d8eb6327
reset_button3 = @bind res3 Button("Reset")

# ╔═╡ a11fde72-5deb-440f-96c8-dcef5de4f6ab
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

# ╔═╡ 0e750e27-4d31-4777-97e8-afaf0894f23f
if true
	
	hide_everything_below
end

# ╔═╡ e07dd248-3f53-401c-9b42-a370193c94fa
html"""
<style>
	body, main, pluto-notebook, nav.plutoui-toc.aside.indent {
		background-color: white
	}
</style>
"""

# ╔═╡ f83abf5e-a2d4-41df-afce-2b5be908e1c7
reset_all = @bind res_all Button("Reset all")

# ╔═╡ 94f85833-07a9-44a3-9f17-5554d46d5e01
reset_all

# ╔═╡ 14e293a1-9e56-42ea-95bf-f31711c493a9
begin
	res_all, res2
	select_a = @bind sel_1 Select(["Wähle 👇"; answers_2[randperm(3)]])
	select_b = @bind sel_2 Select(["Wähle 👇"; answers_2[randperm(3)]])
	select_c = @bind sel_3 Select(["Wähle 👇"; answers_2[randperm(3)]])
end

# ╔═╡ 8d4aef88-7f44-428b-8f91-7bacce6258c3
begin
	res_all
	annehmen_button = @bind annehmen CounterButton("Ich bin bereit! 💪")
end

# ╔═╡ f42b12a9-c98a-4b80-8c8c-377bc67710aa
begin
	annehmen_button
end

# ╔═╡ 5c584f4e-684d-4220-8e9f-fce2ef18d82f
if annehmen == 0
	hide_everything_below
end

# ╔═╡ 1e07760a-8da0-4377-9f54-416eccb76d6f
begin
	res, res_all
	radio_1 = @bind answer_1 Radio(["100 k€", "1 Mio €", "10 Mio €"])
end

# ╔═╡ e3b04b90-ca36-4c85-9d24-e90cb93b1222
begin
	res
	res_all
	checkbox_a = @bind a CheckBox()
	checkbox_b = @bind b CheckBox()
	checkbox_c = @bind c CheckBox()
	checkbox_d = @bind d CheckBox()
	


end

# ╔═╡ f9302f25-890a-42ed-9fe4-7c3305d1572c
begin
res
	res_all
		lösung_button = @bind Lösung CounterButton("Überprüfen")

end

# ╔═╡ 73392c04-4ce6-4bbc-859d-18b29219376c
begin
res2
	res_all
		lösung_button2 = @bind Lösung2 CounterButton("Überprüfen")

end

# ╔═╡ cdaceef8-f222-4b79-98c9-ae7314213782
if Lösung2 == 0
md"""
- Nachhilfeinstitute:  $(select_a)
- Lernspiele:  $(select_b)
- Kursplattformen:  $(select_c)
"""
else
md"""
Deine Wahl:
- Nachhilfeinstitute:  **$(sel_1)**
- Lernspiele:  **$(sel_2)**
- Kursplattformen:  **$(sel_3)**
"""
end

# ╔═╡ 3ec9d0f5-d09a-4ef2-82d3-2c075789274a
begin
	antwort_2 = false
	if Lösung2 == 0
		md"Wähle die richtige Antwort aus und klicke auf **Lösung**"
	elseif((sel_1 ==  nachhilfe_institut) & 
			(sel_2 == lernspiel) &
			(sel_3 == kursplattform))
		antwort_2 = true
		correct(md"**Richtig** 🎉, Zu Belohnung erhältst du ein 🦄!", "Korrekt!")
	else
		almost(md"Versuche es noch einmal", "Noch nicht ganz...")
	end
end

# ╔═╡ cc5c99ba-8760-4dfa-bab3-f7a3b0eaabab
if !antwort_2
	hide_everything_below
end

# ╔═╡ 0ae9d071-013c-4df5-9882-20318e5de1f6
begin
	if Lösung2 == 0
		lösung_button2
	elseif (Lösung2 > 0) & (!antwort_2)
		reset_button2
	end
end

# ╔═╡ f1011ea7-d8fb-49f7-87ad-d7476e346463
begin
res3
	res_all
		lösung_button3 = @bind Lösung3 CounterButton("Überprüfen")

end

# ╔═╡ 485bec09-b32f-4c88-845f-8bf7f71c41e5
if (Lösung3 == 0)
md"""
- `Gamification: ` $(checkbox_a)
- `Story basiertes Lernen: ` $(checkbox_b)
- `Multiplayer Modus: ` $(checkbox_c)
- `individualisiertes Lernen: ` $(checkbox_d)
"""
else
md"""
Deine Wahl:
- `Gamification: ` $(a ? "✔" : "❌") 
- `Story basiertes Lernen: ` $(b ? "✔" : "❌")
- `Multiplayer Modus: ` $(c ? "✔" : "❌")
- `individualisiertes Lernen: ` $(d ? "✔" : "❌")
"""
end

# ╔═╡ 1e463b74-ae8b-4f1a-8e03-47f76cff4269
begin
	antwort3 = false
	if Lösung3 == 0
		md"Wähle eine oder mehrere Antworten und klicke auf **Lösung**"
	elseif(a && b && c && d)
		antwort3 = true
		correct(md"**Richtig** 🎉 Jetzt bist du bereit für die Welt da draußen 🌍", "Geschafft!")
	else
		almost(md"Versuche es noch einmal", "Noch nicht ganz...")
	end
end

# ╔═╡ 87dd5a0e-c048-49a6-a533-3840af16b417
if !antwort3
	hide_everything_below
end

# ╔═╡ e9a2626a-a10e-455f-8961-253454f63f54
begin
	if Lösung3 == 0
		lösung_button3
	elseif (Lösung3 > 0) & (!antwort3)
		reset_button3
	end
end

# ╔═╡ 7c524072-f80a-498b-be92-50b97c877a15
begin
	test_ref = [0]
	@bind test PlutoUI.CounterButton("Lösung")

end

# ╔═╡ c2ff01a5-a346-4722-a3ff-f7af5e9a2c2e
begin
	set_ref = [0]

	@bind set CounterButton("Reset")
end

# ╔═╡ cd7817d9-7495-406e-b990-55938153189c
h = [1]

# ╔═╡ 687598c0-3096-4f66-b594-18c1220722c4
if set > set_ref[1]
	h[1] = 3
	set_ref[1] += 1
end

# ╔═╡ c250a595-016b-4036-a9cc-6eb8acfbdf94
if test > test_ref[1]
	h[1] = 1
	test_ref[1] += 1
end

# ╔═╡ 1993bbe6-f791-45c4-8a3f-ad36fb2e1ade
h[1] = 2

# ╔═╡ 2673b9c3-444e-47b5-959c-a4134b556d02
h[1] = 1

# ╔═╡ 784f068b-8b25-4dae-82ba-e44511a59c17
begin
	set, test
if h[1] == 3
	md"#asdf"
elseif h[1] == 1
	md"yes"
end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

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

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═94f85833-07a9-44a3-9f17-5554d46d5e01
# ╟─44e1a3da-f563-11ec-2063-59169b0d3f06
# ╟─6e5c011b-89ae-4aff-aceb-d2ee253ab0a9
# ╟─57057a91-685b-4ec8-ab6c-761a282579ea
# ╟─a22fa1ee-0d08-4fea-985f-16f6826bc7ac
# ╟─f42b12a9-c98a-4b80-8c8c-377bc67710aa
# ╟─5c584f4e-684d-4220-8e9f-fce2ef18d82f
# ╟─b69c4db2-12ac-4ce0-ac02-ab44aa030359
# ╟─cdaceef8-f222-4b79-98c9-ae7314213782
# ╟─3ec9d0f5-d09a-4ef2-82d3-2c075789274a
# ╟─0ae9d071-013c-4df5-9882-20318e5de1f6
# ╟─cc5c99ba-8760-4dfa-bab3-f7a3b0eaabab
# ╟─61c88bd8-5f87-4fc7-80c2-6f0206591641
# ╟─485bec09-b32f-4c88-845f-8bf7f71c41e5
# ╟─1e463b74-ae8b-4f1a-8e03-47f76cff4269
# ╟─e9a2626a-a10e-455f-8961-253454f63f54
# ╟─87dd5a0e-c048-49a6-a533-3840af16b417
# ╟─fd4e7e37-fd2c-4566-a0df-2945f705a8f7
# ╟─0e750e27-4d31-4777-97e8-afaf0894f23f
# ╟─f54cc3bd-f1e9-4191-8cd1-653dee77fc5b
# ╠═48fd8063-abba-472b-9bbe-ab801166fdb1
# ╠═d029e415-ef80-437b-91c2-131065bbe923
# ╠═f7387aeb-3968-4a81-85ab-19fbe29960cb
# ╠═14e293a1-9e56-42ea-95bf-f31711c493a9
# ╠═6c5a176a-5ac2-463d-ab55-8c30c7a0f87e
# ╟─b227bc7a-2c6b-47e2-8091-ff41ce2e86c7
# ╟─d08ef0b0-721e-4c2a-9223-de01269e86de
# ╠═8d4aef88-7f44-428b-8f91-7bacce6258c3
# ╠═1e07760a-8da0-4377-9f54-416eccb76d6f
# ╠═e3b04b90-ca36-4c85-9d24-e90cb93b1222
# ╠═13195864-0787-4a0a-8149-85967708fa57
# ╠═e228acb1-290b-45a3-9081-7de130818b11
# ╠═0004f7fa-673c-4b4d-aecc-17c0d8eb6327
# ╠═f9302f25-890a-42ed-9fe4-7c3305d1572c
# ╠═73392c04-4ce6-4bbc-859d-18b29219376c
# ╠═f1011ea7-d8fb-49f7-87ad-d7476e346463
# ╠═9d404ed6-a347-4166-8007-2843abefca6b
# ╠═a11fde72-5deb-440f-96c8-dcef5de4f6ab
# ╠═e07dd248-3f53-401c-9b42-a370193c94fa
# ╠═6fb87691-58c1-498a-9563-6b92ee59b119
# ╠═f83abf5e-a2d4-41df-afce-2b5be908e1c7
# ╠═687598c0-3096-4f66-b594-18c1220722c4
# ╠═c250a595-016b-4036-a9cc-6eb8acfbdf94
# ╠═7c524072-f80a-498b-be92-50b97c877a15
# ╠═c2ff01a5-a346-4722-a3ff-f7af5e9a2c2e
# ╠═cd7817d9-7495-406e-b990-55938153189c
# ╠═1993bbe6-f791-45c4-8a3f-ad36fb2e1ade
# ╠═2673b9c3-444e-47b5-959c-a4134b556d02
# ╠═784f068b-8b25-4dae-82ba-e44511a59c17
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
