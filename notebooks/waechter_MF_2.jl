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

# ╔═╡ 44e1a3da-f563-11ec-2063-59169b0d3f06
md"# Der Wächter der Gründungsgarage taucht auf und spricht:"

# ╔═╡ 6e5c011b-89ae-4aff-aceb-d2ee253ab0a9
md"
$(Resource(waechter))
### **Wächter:** _Halt, so einfach wirst du da draußen in der Geschäftswelt nicht zurecht kommen. Ich helfe dir, wenn du mir zwei Fragen beantwortest..._"

# ╔═╡ 57057a91-685b-4ec8-ab6c-761a282579ea
md"
### **Wächter:** _Bist du für die Fragen bereit?_
"

# ╔═╡ a22fa1ee-0d08-4fea-985f-16f6826bc7ac
md"""
---
"""

# ╔═╡ f42b12a9-c98a-4b80-8c8c-377bc67710aa
begin
	annehmen_button
end

# ╔═╡ 5c584f4e-684d-4220-8e9f-fce2ef18d82f
if annehmen == 0
	hide_everything_below
end

# ╔═╡ b69c4db2-12ac-4ce0-ac02-ab44aa030359
md"
$(Resource(waechter, :width => 80)) 
### **Wächter:** _Über 10 Millionen € geben ÖsterreicherInnen pro Jahr für Nachhilfe aus. Kennst du auf diesem Markt deine Konkurrenz?_
"

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
	if qu2_answered[1] == false
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

# ╔═╡ e3ea38ae-3898-4652-85ac-573ff15e8117
test, test_ref2, set, set_ref2, qu2_answered[1]

# ╔═╡ 64098720-fb58-427e-8307-d9f2a1f32b72
res_button2, lsg_button2, antwort_2

# ╔═╡ 0ae9d071-013c-4df5-9882-20318e5de1f6
begin
	
	if qu2_answered[1] == false
		lsg_button2
	elseif (qu2_answered[1]) & (!antwort_2)
		res_button2
	end
end

# ╔═╡ cc5c99ba-8760-4dfa-bab3-f7a3b0eaabab
if  false#!antwort_2
	hide_everything_below
end

# ╔═╡ 61c88bd8-5f87-4fc7-80c2-6f0206591641
md"""
$(Resource(waechter, :width => 80)) 
### **Wächter:** *Wow so viel Konkurrenz! So sagt mir, was macht euren Ansatz einzigartig?* 🦄
"""

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

# ╔═╡ e9a2626a-a10e-455f-8961-253454f63f54
begin
	if Lösung3 == 0
		lösung_button3
	end
end

# ╔═╡ 48e123db-c154-4e3f-b698-cda7d212c41e
if (Lösung3 > 0) & (!antwort3)
		reset_button3
end

# ╔═╡ 87dd5a0e-c048-49a6-a533-3840af16b417
if false #!antwort3
	hide_everything_below
end

# ╔═╡ fd4e7e37-fd2c-4566-a0df-2945f705a8f7
md"""
$(Resource(waechter))
### **Wächter:** *Du scheinst einen genialen Businessplan zu haben. Geh jetzt durch das Loch in der Wand* 👈 _und sieh in die **Kristallkugel**_  🔍
"""

# ╔═╡ 0e750e27-4d31-4777-97e8-afaf0894f23f
if false
	
	hide_everything_below
end

# ╔═╡ f54cc3bd-f1e9-4191-8cd1-653dee77fc5b
waechter = "https://github.com/dorn-gerhard/workAdventure/raw/master/Characters/W%C3%A4chter/ritter_waechter_gif_large.gif"

# ╔═╡ 48fd8063-abba-472b-9bbe-ab801166fdb1


# ╔═╡ d029e415-ef80-437b-91c2-131065bbe923


# ╔═╡ f7387aeb-3968-4a81-85ab-19fbe29960cb


# ╔═╡ 14e293a1-9e56-42ea-95bf-f31711c493a9
begin
	res_all, res2
	select_a = @bind sel_1 Select(["Wähle 👇"; answers_2[randperm(3)]])
	select_b = @bind sel_2 Select(["Wähle 👇"; answers_2[randperm(3)]])
	select_c = @bind sel_3 Select(["Wähle 👇"; answers_2[randperm(3)]])
end

# ╔═╡ 6c5a176a-5ac2-463d-ab55-8c30c7a0f87e
begin
	nachhilfe_institut = "Go Student, Schülerhilfe, Lernquadrat"
	lernspiel = "Duolingo, Anton, SimpleClub"
	kursplattform = "EdX, Udemy, Brilliant"
	answers_2 = [nachhilfe_institut, kursplattform, lernspiel]
end

# ╔═╡ b227bc7a-2c6b-47e2-8091-ff41ce2e86c7
md"""
Wird eigentlich nicht angezeigt, wenn die Antwort richtig ist: $(reset_button)
"""

# ╔═╡ d08ef0b0-721e-4c2a-9223-de01269e86de
begin
keep_working(text=md"The answer is not quite right.", title="Keep working on it!") = Markdown.MD(Markdown.Admonition("danger", title, [text]));

almost(text, title="Almost there!") = Markdown.MD(Markdown.Admonition("warning", title, [text]));

hint(text, title ="Hint") = Markdown.MD(Markdown.Admonition("hint", title, [text]));
	
correct(text=md"Great! You got the right answer! Let's move on to the next section.", title="Got it!") = Markdown.MD(Markdown.Admonition("correct", title, [text]));
md" Definition of Boxes"
end

# ╔═╡ 8d4aef88-7f44-428b-8f91-7bacce6258c3
begin
	res_all
	annehmen_button = @bind annehmen CounterButton("Ich bin bereit! 💪")
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

# ╔═╡ 13195864-0787-4a0a-8149-85967708fa57
reset_button = @bind res Button("Reset")

# ╔═╡ e228acb1-290b-45a3-9081-7de130818b11
reset_button2 = @bind res2 Button("Reset")

# ╔═╡ 0004f7fa-673c-4b4d-aecc-17c0d8eb6327
reset_button3 = @bind res3 Button("Reset")

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

# ╔═╡ f1011ea7-d8fb-49f7-87ad-d7476e346463
begin
res3
	res_all
		lösung_button3 = @bind Lösung3 CounterButton("Überprüfen")

end

# ╔═╡ 445acd08-6c5d-48a4-8791-ab0743b52b80

if set > set_ref2[1]
	qu2_answered[1] = false
	set_ref2[1] += 1
end

# ╔═╡ 6357c149-4454-4bdd-958b-96b87e3b6d95
qu2_answered = [false]

# ╔═╡ fa5ab3c0-f33e-41cf-a61e-112a33e9fafe
qu2_answered

# ╔═╡ 08b7388e-3ec1-49af-978d-d259c72c214d
if test > test_ref2[1]
	qu2_answered[1] = true
	test_ref2[1] += 1
end


# ╔═╡ 77f9bfc2-bb66-4a31-b1dd-54208cb406b1
test, test_ref2, set, set_ref2, qu2_answered[1]

# ╔═╡ 24b49644-bf61-4c6d-b841-0bedc6ded76e
begin
	test_ref2 = [0]
	lsg_button2 = @bind test PlutoUI.CounterButton("Lösung")

end

# ╔═╡ e5a4ba65-531e-4b88-b921-35850cad9dcb
begin
	set_ref2 = [0]

	res_button2 = @bind set CounterButton("Reset")
end

# ╔═╡ 9d404ed6-a347-4166-8007-2843abefca6b
using PlutoUI

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

# ╔═╡ e07dd248-3f53-401c-9b42-a370193c94fa
html"""
<style>
	body, main, pluto-notebook, nav.plutoui-toc.aside.indent {
		background-color: white
	}
</style>
"""

# ╔═╡ 6fb87691-58c1-498a-9563-6b92ee59b119
using Random

# ╔═╡ f83abf5e-a2d4-41df-afce-2b5be908e1c7
reset_all = @bind res_all Button("Reset all")

# ╔═╡ Cell order:
# ╟─44e1a3da-f563-11ec-2063-59169b0d3f06
# ╟─6e5c011b-89ae-4aff-aceb-d2ee253ab0a9
# ╟─57057a91-685b-4ec8-ab6c-761a282579ea
# ╟─a22fa1ee-0d08-4fea-985f-16f6826bc7ac
# ╟─f42b12a9-c98a-4b80-8c8c-377bc67710aa
# ╟─5c584f4e-684d-4220-8e9f-fce2ef18d82f
# ╟─b69c4db2-12ac-4ce0-ac02-ab44aa030359
# ╠═cdaceef8-f222-4b79-98c9-ae7314213782
# ╠═3ec9d0f5-d09a-4ef2-82d3-2c075789274a
# ╠═e3ea38ae-3898-4652-85ac-573ff15e8117
# ╠═64098720-fb58-427e-8307-d9f2a1f32b72
# ╠═0ae9d071-013c-4df5-9882-20318e5de1f6
# ╠═cc5c99ba-8760-4dfa-bab3-f7a3b0eaabab
# ╟─61c88bd8-5f87-4fc7-80c2-6f0206591641
# ╟─485bec09-b32f-4c88-845f-8bf7f71c41e5
# ╟─1e463b74-ae8b-4f1a-8e03-47f76cff4269
# ╠═e9a2626a-a10e-455f-8961-253454f63f54
# ╠═48e123db-c154-4e3f-b698-cda7d212c41e
# ╠═87dd5a0e-c048-49a6-a533-3840af16b417
# ╟─fd4e7e37-fd2c-4566-a0df-2945f705a8f7
# ╠═0e750e27-4d31-4777-97e8-afaf0894f23f
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
# ╠═445acd08-6c5d-48a4-8791-ab0743b52b80
# ╠═6357c149-4454-4bdd-958b-96b87e3b6d95
# ╠═fa5ab3c0-f33e-41cf-a61e-112a33e9fafe
# ╠═08b7388e-3ec1-49af-978d-d259c72c214d
# ╠═77f9bfc2-bb66-4a31-b1dd-54208cb406b1
# ╠═24b49644-bf61-4c6d-b841-0bedc6ded76e
# ╠═e5a4ba65-531e-4b88-b921-35850cad9dcb
# ╠═9d404ed6-a347-4166-8007-2843abefca6b
# ╠═a11fde72-5deb-440f-96c8-dcef5de4f6ab
# ╠═e07dd248-3f53-401c-9b42-a370193c94fa
# ╠═6fb87691-58c1-498a-9563-6b92ee59b119
# ╠═f83abf5e-a2d4-41df-afce-2b5be908e1c7
