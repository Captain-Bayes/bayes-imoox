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
### **Wächter:** _Halt, so einfach wirst du da draußen in der Geschäftswelt nicht zurecht kommen. Ich werde dich mit folgenden Fragen auf deine Zukunft vorbereiten..._"

# ╔═╡ 57057a91-685b-4ec8-ab6c-761a282579ea
md"
### **Wächter:** _Bist du für die Fragen bereit?_
"

# ╔═╡ f42b12a9-c98a-4b80-8c8c-377bc67710aa
begin
	annehmen_button
end

# ╔═╡ 1cdd0dff-cb89-48b7-8d59-0e55b15bb875
if annehmen == 0
	md"Trau dich!"
	
elseif (annehmen > 0) && (Lösung == 0)
md"""
**Wie groß ist euer Markt? Wie viel geben ÖsterreicherInnen für Nachhilfe aus?**

$(radio_1)
"""
else
md"""
Deine Antwort:
- $(answer_1) 
"""
end

# ╔═╡ 59cc0812-44cd-44d8-ab1f-4c6582212fef
begin
	antwort_1 = false
	if annehmen > 0
		if Lösung == 0
			md"Wähle die richtige Antwort aus und klicke auf **Lösung**"
		elseif(answer_1 == "10 Mio €")
			antwort_1 = true
			correct(md"**Richtig** 🎉, du bist auf einem guten Weg 👍. Nimm dieses Einhorn 🦄!", "Gut geraten!")
		else
			almost(md"Versuche es noch einmal", "Noch nicht ganz...")
		end
	end
end

# ╔═╡ a97d3a43-4f3b-4be4-8fd8-ec91eed6f896
begin
	if annehmen > 0 && Lösung == 0
		lösung_button
	elseif (Lösung > 0) & (!antwort_1)
		reset_button
	end
end

# ╔═╡ d32c08a4-ce3b-4f8e-a97c-1f750bb926b0
md"""
---
"""

# ╔═╡ 02b69024-172b-4214-91d3-4fe9dc28890f
if !antwort_1
	hide_everything_below
end

# ╔═╡ aa2b6a0b-e4bc-409e-aa7c-31fddccf1e84
md"""
$(Resource(waechter, :width => 80))

### **Wächter:** *Nächste Aufgabe! Kennst du deine Konkurrenz?* 🕵️‍♂️ 
-> **Ordne richtig zu!**
"""

# ╔═╡ cdaceef8-f222-4b79-98c9-ae7314213782
if (Lösung2 == 0)
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
	if annehmen > 0
		if Lösung2 == 0
			md"Wähle die richtige Antwort aus und klicke auf **Lösung**"
		elseif((sel_1 ==  nachhilfe_institut) & 
			   (sel_2 == lernspiel) &
			   (sel_3 == kursplattform))
			antwort_2 = true
			correct(md"**Richtig** 🎉, Du bekommst dein zweites 🦄🦄!", "Korrekt!")
		else
			almost(md"Versuche es noch einmal", "Noch nicht ganz...")
		end
	end
end

# ╔═╡ 0ae9d071-013c-4df5-9882-20318e5de1f6
begin
	if annehmen > 0 && Lösung2 == 0
		lösung_button2
	elseif (Lösung2 > 0) & (!antwort_2)
		reset_button2
	end
end

# ╔═╡ a22fa1ee-0d08-4fea-985f-16f6826bc7ac
md"""
---
"""

# ╔═╡ cc5c99ba-8760-4dfa-bab3-f7a3b0eaabab
if !antwort_2
	hide_everything_below
end

# ╔═╡ 61c88bd8-5f87-4fc7-80c2-6f0206591641
md"""
$(Resource(waechter, :width => 80))
### **Wächter:** *Wow so viel Konkurrenz! Um euch zu behaupten müsst ihr wissen: Was macht euch einzigartig?* 🦄
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
- `Gamification: ` $(a ? "✔" : "❌") - `Story basiertes Lernen: ` $(b ? "✔" : "❌")
- `Multiplayer Modus: ` $(c ? "✔" : "❌")
- `individualisiertes Lernen: ` $(d ? "✔" : "❌")
"""
end

# ╔═╡ 1e463b74-ae8b-4f1a-8e03-47f76cff4269
begin
	antwort3 = false
	if annehmen > 0
		if Lösung3 == 0
			md"Wähle eine oder mehrere Antworten und klicke auf **Lösung**"
		elseif(a && b && c && d)
			antwort3 = true
			correct(md"**Richtig** 🎉, du hast das dritte 🦄🦄🦄 erhalten! Jetzt bist du bereit für die Welt da draußen 🌍", "Geschafft!")
		else
			almost(md"Versuche es noch einmal", "Noch nicht ganz...")
		end
	end
end

# ╔═╡ e9a2626a-a10e-455f-8961-253454f63f54
begin
	if annehmen > 0 && Lösung3 == 0
		lösung_button3
	elseif (Lösung3 > 0) & (!antwort3)
		reset_button3
	end
end

# ╔═╡ 87dd5a0e-c048-49a6-a533-3840af16b417
if !antwort3
	hide_everything_below
end

# ╔═╡ fd4e7e37-fd2c-4566-a0df-2945f705a8f7
md"""
$(Resource(waechter))
### **Wächter:** *Du scheinst einen genialen Businessplan zu haben. Geh jetzt durch das Loch in der Wand* 👈 _und sieh in die **Kristallkugel**_  🔍
"""

# ╔═╡ 0e750e27-4d31-4777-97e8-afaf0894f23f
if true
	
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
# ╟─f42b12a9-c98a-4b80-8c8c-377bc67710aa
# ╟─1cdd0dff-cb89-48b7-8d59-0e55b15bb875
# ╟─59cc0812-44cd-44d8-ab1f-4c6582212fef
# ╟─a97d3a43-4f3b-4be4-8fd8-ec91eed6f896
# ╟─d32c08a4-ce3b-4f8e-a97c-1f750bb926b0
# ╟─02b69024-172b-4214-91d3-4fe9dc28890f
# ╟─aa2b6a0b-e4bc-409e-aa7c-31fddccf1e84
# ╟─cdaceef8-f222-4b79-98c9-ae7314213782
# ╟─3ec9d0f5-d09a-4ef2-82d3-2c075789274a
# ╟─0ae9d071-013c-4df5-9882-20318e5de1f6
# ╟─a22fa1ee-0d08-4fea-985f-16f6826bc7ac
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
