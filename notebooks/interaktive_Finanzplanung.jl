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

# ╔═╡ ae5f29fc-fff3-4bbb-81da-9fd616be93ad
md"""
# Finanzplan Konomondo
"""

# ╔═╡ 968a8caf-ad21-416c-9acd-740a53eb8ffc
begin
	#p_ein = plot(time_axis, einnahmen_pro_monat.(1:length(time_axis)), size = (600, 200), label= :none,  formatter = :plain)
	p_erg = plot(time_axis, ergebnis_pro_monat.(1:length(time_axis)) ./ 1000, size = (600, 400), label= :none, title = "monatliches Ergebnis", linewidth =5, formatter = :plain, ylabel =" Ergebnis | k€", xlabel = "Zeit")
	plot!(p_erg, time_axis, zeros(size(time_axis)), linecolor = :green, linewidth = 2, label = :none, alpha = 0.3)
#	plot(p_ein, p_erg, layout = (2,1), size = (600, 400))
end

# ╔═╡ b9c96a14-b60b-4ddc-9e7f-5f160501677f
md"""
maximaler Liquiditätsbedarf: **$(max_liqu_bedarf) k€**
"""

# ╔═╡ f1382903-a1f5-4c3e-8d44-deca5f3ba41e
md"""
- Startdatum 📆 Finanzplan: $(@bind datum PlutoUI.DateField(default = Date(2022, 11, 1)))
- Enddatum Finanzplan: $(@bind datum_end PlutoUI.DateField(default = Date(2027, 11, 1)))
---
- 👩‍💼👨‍💼 Einstellungsrate:  $(@bind months_to_new_employee Slider(1:10, default = 4, show_value = true)) (nach wie vielen Monaten kommt neueR MitarbeiterIn)
- **Produktivität**: Kampagnen pro Angestellter/m: $(slider_prod_range)
- effizientere Produktion ab Monat: $(slider_prod_twist)
---
- Mittelfristig erreichbarer Marktanteil: $(slider_marktanteil)
- Erschließen des deutschen Marktes $(@bind deutschland_markt CheckBox()) nach $(@bind eintritt_deutschland Scrubbable(1:100, default = 26, suffix = " Monate"))
"""

# ╔═╡ aae1714d-358d-4cf9-ad13-189bea325cb7
md"""
## Modellierung
- Ausgaben 🧾 = Angestellte 👩‍💼👨‍💼
- Einnahmen 💰 = Preis 💶 ⋅ Spieler 👥
- Preis 💶: abhängig von Inhalt 🎲
- Spieler 👥: abhängig von Marktkapazität, Spielqualität ✔, Marktdynamik
- Spielequalität ✔: abhängig vom Inhalt 🎲, Systemintelligenz, Lessons Learned
- Inhalt 🎲: abhängig von Angestellten 👩‍💼👨‍💼
"""

# ╔═╡ c428aa68-b457-4665-aefe-fcbd8c92136e
plot(time_axis, spieler.(1:length(time_axis)), size = (600, 200), label= :none, title = deutschland_markt ? "Spieler (mit deutschem Markt)" : "Spieler (ohne deutschen Markt)", linewidth = 3, formatter = :plain)

# ╔═╡ 97f7178d-2182-4ae8-b869-785c5a99730b
md"""
# 💰 Einnahmen
"""

# ╔═╡ dce871dc-5b78-4067-ab00-9e9b4597461d
einnahmen_pro_monat(t) = spieler(t) * preis(t)

# ╔═╡ af5f7d1c-e6b0-49bd-a8f9-921491df41de
einnahmen(t) = sum(einnahmen_pro_monat.(1:t))

# ╔═╡ f0ef9810-a0a3-47f6-8a25-667734288b53
plot(time_axis, einnahmen.(1:length(time_axis)), size = (600, 200), label= :none, title = "Einnahmen kummuliert")

# ╔═╡ fa8f41b4-15d8-4bcd-b6f1-e63771c18576
plot(time_axis, einnahmen_pro_monat.(1:length(time_axis)), size = (600, 200), label= :none, title = "Einnahmen pro Monat")

# ╔═╡ 4d867cb4-4722-495c-9559-9b640de0bc32
preis(42)

# ╔═╡ d94f3f1d-8b80-4ef1-a21d-68ddbefe248b
md"""
# 🧾 Ausgaben
"""

# ╔═╡ 879fd8fe-5654-4a0d-823e-f7d95c96436c
ausgaben(t) = sum(ausgaben_pro_monat.(1:t))

# ╔═╡ d3fdf901-3952-46fa-a78b-243c9cb27e62
ausgaben_pro_monat(t) = employees(t) * cost_per_employee

# ╔═╡ f3ebd7d3-536e-4da1-a334-4cad88855b5b
ergebnis_pro_monat(t) = einnahmen_pro_monat(t) - ausgaben_pro_monat(t)

# ╔═╡ 01c4d517-b351-4011-a3ba-11c56f16167f
ergebnis(t) = einnahmen(t) - ausgaben(t)

# ╔═╡ aad8ad1e-b3c7-44dd-9e80-0d25e28f3df1
plot(time_axis, ausgaben.(1:length(time_axis)), size = (600, 200), label= :none, title = "Einnahmen kummuliert")

# ╔═╡ f035fb9b-3729-40aa-bab1-8948cce9a868
max_liqu_bedarf =  Int(round(-minimum(ergebnis.(1:length(time_axis))) /1000))

# ╔═╡ adef630e-6ca6-48c9-afbc-977d31d5c788
md"""
# 👥 Spieler
hängt von Marktpotenzial, dem Kampagnenangebot, dem erschlossenen Markt etc. ab
"""

# ╔═╡ d63b4ef6-e0fa-42f1-a0b3-6bb61fd5fd6b
plot(time_axis, spieler.(1:length(time_axis)), size = (600, 200), label= :none, title = "Spieler")

# ╔═╡ c7377570-680d-44d5-967b-e6e8f4ea1179
spieler(t)=  potenzial_österreich * marktanteil_max_österreich * spiel_qualität(t) * markt_dynamik(t) + 
deutschland_markt * 
potenzial_deutschland * marktanteil_max_österreich * spiel_qualität(t) * markt_dynamik(t - eintritt_deutschland)

# ╔═╡ a088a5da-3113-4146-839f-6b586b5dac53
markt_dynamik(t) = f_log(t, 30, 0, 1, 0.15)

# ╔═╡ 5cfb59a8-86a0-4683-ad00-b3263ce91416
plot(markt_dynamik.(1:100))

# ╔═╡ cccaacc6-8b8d-4f8e-84d0-e60c14b37a75
md"""
### Markt Österreich
- SchülerInnen: 1 140 000
- Nachhilfe: 28%
- bezahlte Nachhilfe: 17%
- bezahlte Mathematiknachhilfe: 11%
"""

# ╔═╡ b2b7fb34-ff99-4172-8933-a68a029a5aba
students_österreich = 1140000 # students

# ╔═╡ 467803c3-dead-4d43-ac50-8a7b74141cb6
potenzial_österreich = students_österreich * 0.11

# ╔═╡ 9fb4ab30-389d-47ec-ab1e-be05472fc3d6
md"""
Mittelfristig erreichbarer Marktanteil: $(slider_marktanteil)
"""

# ╔═╡ a1b20863-cd85-481f-9939-7b8de0019670
md"""
### Markt Deutschland
- SchülerInnen: 11 000 000
- Nachhilfe: ~ 28%
- bezahlte Nachhilfe: ~17%
- bezahlte Mathematiknachhilfe: ~10%
"""

# ╔═╡ c9d2b981-938c-4f1d-b5d1-b3f4a1cf2f2c
students_deutschland = 11000000 # students

# ╔═╡ dfc5646a-0fe6-4811-b52a-f67afd74a3f6
potenzial_deutschland = students_deutschland * 0.1

# ╔═╡ b11385a1-0c93-45b4-bcac-d9f20dd07f95
md"""
# 👩‍💼👨‍💼 Angestellte
"""

# ╔═╡ 07f0fb97-48aa-442e-98b9-df7e1093d011
plot(time_axis, employees.(1:length(time_axis)), size = (600, 200), label= :none, title = "Spieler")

# ╔═╡ 464213f4-89e5-49fa-9c66-9f17b7514367
employees(t) = t ÷ months_to_new_employee + 2

# ╔═╡ f854bec3-ec05-4be0-b0a9-fb9faa04b686
employees.(1:10)

# ╔═╡ 763b7bc0-cae5-48a8-a21a-514d382b70e2
cost_per_employee = 5000

# ╔═╡ 4fb58452-3864-4c92-ba40-39ab9dfbe2fa
md"""
**Produktivität**: Kampagnen pro Angestellter/m: $(slider_prod_range)

effizientere Produktion ab Monat: $(slider_prod_twist)
"""

# ╔═╡ 42462032-736d-449b-bcd7-7bf3810629c2
producability(t) = f_log(t, prod_twist,  prod_range[1],  prod_range[end]) 

# ╔═╡ 8e21a4e8-c843-4e45-a00a-9cefb4319c30
md"""
# 🎲 Kampagnen
"""

# ╔═╡ 5e57b8ce-45ff-4df3-b69e-3917d1e9e072
content_per_month(t) = employees(t) * producability(t)

# ╔═╡ 0f743f62-dc24-4a37-a4a3-5077747bb1eb
content(t) = sum(content_per_month.(1:t))

# ╔═╡ f78da556-2a09-4d7f-986e-00517fed59ef
begin
	p1 = plot(time_axis, content.(1:length(time_axis)), label = :none, title = "kreierte Kampagnen")
	p2 = plot(time_axis, preis.(1:length(time_axis)), label = :none, title = "Preis pro Spiel / Monat")
	plot(p1,p2, layout = (2,1))
end

# ╔═╡ adf59a08-ab44-4bc4-a31f-132fa7924de6
md"""
# 💶 Preis pro Spiel
Diskrete Funktion beginnend bei 1€ bis hin zu 20€ pro Monat
"""

# ╔═╡ 78fdbb88-0237-4208-bab4-f584587b43a0
preis(t) = min(ceil(content(t)/max_content * 20 ), 20)

# ╔═╡ e073c48a-f763-463c-8b3c-67497147e22c
max_content = 720

# ╔═╡ 7bfcd6ac-0d85-4b56-994c-73179a547b6a
md"""
# ✔ Qualität
"""

# ╔═╡ 095dd17b-fbe6-4ab4-9815-d78fe14e0491
md"""
#### Erfolgsfaktoren für Produktqualität:
Das Versprechen, dass das Spiel funktioniert und den SchülerInnen hilft, hängt von folgenden Faktoren ab:
- Systemintelligenz: $(@bind p_system_intelligence Scrubbable(0:0.01:1, default = 0.40, format = "0.0%"))
- Inhalte: $(@bind p_content Scrubbable(0:0.01:1, default = 0.30, format = "0.0%"))
- Lessons learned: *Rest*
"""
#$(@bind p_lessons_learned Scrubbable(0:0.01:1, default = 0.40, format = "0.0%")

# ╔═╡ 2c7d0165-5f0b-4cf1-8d77-825ac1ce5519
begin
	p_lessons_learned = 1- p_system_intelligence - p_content
	p_pie = pie(["Systemintelligenz: " * string(Int(round(p_system_intelligence * 100))) *"%", "Inhalte: "* string(Int(round(p_content * 100))) *"%", "Lessons Learned: "* string(Int(round(p_lessons_learned * 100))) *"%"], [p_system_intelligence, p_content, p_lessons_learned], 
	
	#series_annotation = [p_system_intelligence, p_content, p_lessons_learned],
	size = (600, 200),
	legend = :outertopright)
end

# ╔═╡ 7310d3e0-7aa3-4af8-b6d3-989398d7e560
spiel_qualität(t) = p_content * min(1, content(t) / max_content) + p_system_intelligence * sys_intelligence(t) + p_lessons_learned * lessons_learned(t)

# ╔═╡ f16922cf-58cb-445f-9fe9-1886e14d2b12
plot(time_axis, spiel_qualität.(1:length(time_axis)), size = (600, 200), label= :none, title = "Spiel Qualität")

# ╔═╡ cb06c3d8-fdaf-4076-b88f-0886a989576f
md"""
### System intelligence
- Recommender system
- Cleveres Buddy / Bot System
Halbzeit Implementierung: $(@bind half_time_sys_intelligence Scrubbable(1:100, default = 24, suffix = " Monate")); Entwicklungsgeschwindigkeit: $(@bind dev_speed_sys_intelligence Scrubbable(0.01:0.01:2, default = 0.05, format = ".2f", suffix = " "))
"""

# ╔═╡ 7fbb99cd-5ec5-4852-a017-e7748b7b5ceb
sys_intelligence(t) = f_log(t, half_time_sys_intelligence, 0, 1, dev_speed_sys_intelligence)

# ╔═╡ f1abc127-4e1c-48aa-ad54-d8115327c451
plot(time_axis, sys_intelligence.(1:length(time_axis)), size = (600, 200), label= :none, title = "System Intelligenz")

# ╔═╡ 5a4a8976-e2e9-4815-a840-0df78cd7201e
md"""
### Lessons learned
- Erkenntnisse aus Nachhilfe im ersten Jahr
- Feedback gesteuert
Halbzeit Lessons learned: $(@bind half_time_lessons_learned Scrubbable(1:100, default = 6, suffix = " Monate")); Entwicklungsgeschwindigkeit: $(@bind dev_speed_lessons_learned Scrubbable(0.01:0.01:2, default = 0.85, format = ".2f", suffix = " "))
"""

# ╔═╡ 37ffea46-d636-4d0a-a579-5349a920d925
lessons_learned(t) = f_log(t, half_time_lessons_learned, 0, 1, dev_speed_lessons_learned)

# ╔═╡ 71d513b4-3bf1-4b2f-943a-8868bf99cde2
plot(time_axis, lessons_learned.(1:length(time_axis)), size = (600, 200), label= :none, title = "Lessons learned")

# ╔═╡ 34826510-9602-4a49-8dfd-c34368cc8e7d
f_log(t, tip = 10, start_val = 1, end_val = 2, slope = 1) = (end_val - start_val) * (atan(slope * (t-tip)) + pi/2)/pi + start_val

# ╔═╡ 4d7bb9c4-b32f-4697-80b3-bc252c530f74
f_l(t, tip = 10, start_val = 1, end_val = 2, slope = 1) = start_val + (end_val - start_val) ./(1 + exp(- slope * (t - tip)))

# ╔═╡ 33b50157-2f64-498e-a972-fc3d63156a89
time_axis = Date(datum) : Month(1):Date(datum_end)

# ╔═╡ 40966def-ae1f-4ee8-b331-70c544901cbc
begin
	plot(f_l.(1:100))
	plot!(f_log.(1:100) )
end

# ╔═╡ 97a29d85-33d1-4368-822a-5737a4566b07
TableOfContents()

# ╔═╡ 8133a630-c47b-11ec-2b78-571c076a8c9a
begin
	using PlutoUI, Plots, Dates, DataFrames
end

# ╔═╡ 568d711f-40c1-465e-b927-3c6f2ac3dd24
begin
slider_marktanteil = @bind marktanteil_max_österreich Scrubbable(0.00:0.001:0.1, default = 0.05, format = "0.1%")
slider_prod_range = @bind prod_range PlutoUI.RangeSlider(0.5:0.1:3, default = 1:0.1:2)
slider_prod_twist = @bind prod_twist Scrubbable(1:30, default = 10)
end

# ╔═╡ 83bd5e96-a222-42cf-b516-7776f7c9226e
slider_marktanteil

# ╔═╡ 89f3fbf6-dae7-4a91-a368-54c47aede5b5
html"""
<style>
	body, main, pluto-notebook, nav.plutoui-toc.aside.indent {
		background-color: white
	}
</style>
"""

# ╔═╡ 9b31d8d3-9a7e-4bdf-8c11-efe059fc00fe
md"""
# Abrechnung


## GuV (Gewinn- und Verlustrechnung)
- Betriebsleistung
  - Umsatzerlöse
  - Bestandsveränderung
  - Aktivierte Eigenleistung
  - sonstige betrieblichen Erträge (Förderungen)

- 


## Bilanz
nach außen

- Aktiva


- Passiva

# Planung
## Struktur für Finanzplan
Monatsbasis, Jahresbasis
- Einzahlungen
  - Umsatzerlöse
    - B2C Digital
    - B2C Nachhilfe vor Ort
  - Förderungen
- Auszahlungen
  - Gehälter / Löhne
  - Software Lizenzen
  - Rechts- und Beratungsaufwand
  - Drittdienstleister
  - Infrastruktur
  - PR und Marketing
  - Sonstige Ausgaben
  - Bürokosten
  - Computerinfrastruktur

## Liquiditätsplanung (Finanzplanung)
- Ausgaben
  - Fixkosten
  - Variable Kosten
  - Investitionen
  - Lohnnebenkosten
- Einnahemen
  - Umsatz (Stück * Preis)
  
## Umsatzplanung


"""

# ╔═╡ Cell order:
# ╟─ae5f29fc-fff3-4bbb-81da-9fd616be93ad
# ╟─968a8caf-ad21-416c-9acd-740a53eb8ffc
# ╟─b9c96a14-b60b-4ddc-9e7f-5f160501677f
# ╟─f1382903-a1f5-4c3e-8d44-deca5f3ba41e
# ╟─aae1714d-358d-4cf9-ad13-189bea325cb7
# ╟─c428aa68-b457-4665-aefe-fcbd8c92136e
# ╟─97f7178d-2182-4ae8-b869-785c5a99730b
# ╠═dce871dc-5b78-4067-ab00-9e9b4597461d
# ╠═af5f7d1c-e6b0-49bd-a8f9-921491df41de
# ╠═f0ef9810-a0a3-47f6-8a25-667734288b53
# ╠═fa8f41b4-15d8-4bcd-b6f1-e63771c18576
# ╠═4d867cb4-4722-495c-9559-9b640de0bc32
# ╟─d94f3f1d-8b80-4ef1-a21d-68ddbefe248b
# ╠═879fd8fe-5654-4a0d-823e-f7d95c96436c
# ╠═d3fdf901-3952-46fa-a78b-243c9cb27e62
# ╠═f3ebd7d3-536e-4da1-a334-4cad88855b5b
# ╠═01c4d517-b351-4011-a3ba-11c56f16167f
# ╠═aad8ad1e-b3c7-44dd-9e80-0d25e28f3df1
# ╠═f035fb9b-3729-40aa-bab1-8948cce9a868
# ╟─adef630e-6ca6-48c9-afbc-977d31d5c788
# ╠═d63b4ef6-e0fa-42f1-a0b3-6bb61fd5fd6b
# ╠═c7377570-680d-44d5-967b-e6e8f4ea1179
# ╠═a088a5da-3113-4146-839f-6b586b5dac53
# ╠═5cfb59a8-86a0-4683-ad00-b3263ce91416
# ╟─cccaacc6-8b8d-4f8e-84d0-e60c14b37a75
# ╠═b2b7fb34-ff99-4172-8933-a68a029a5aba
# ╠═467803c3-dead-4d43-ac50-8a7b74141cb6
# ╟─9fb4ab30-389d-47ec-ab1e-be05472fc3d6
# ╟─a1b20863-cd85-481f-9939-7b8de0019670
# ╠═c9d2b981-938c-4f1d-b5d1-b3f4a1cf2f2c
# ╠═dfc5646a-0fe6-4811-b52a-f67afd74a3f6
# ╟─b11385a1-0c93-45b4-bcac-d9f20dd07f95
# ╠═07f0fb97-48aa-442e-98b9-df7e1093d011
# ╠═464213f4-89e5-49fa-9c66-9f17b7514367
# ╠═f854bec3-ec05-4be0-b0a9-fb9faa04b686
# ╠═763b7bc0-cae5-48a8-a21a-514d382b70e2
# ╟─4fb58452-3864-4c92-ba40-39ab9dfbe2fa
# ╠═42462032-736d-449b-bcd7-7bf3810629c2
# ╟─8e21a4e8-c843-4e45-a00a-9cefb4319c30
# ╠═5e57b8ce-45ff-4df3-b69e-3917d1e9e072
# ╠═0f743f62-dc24-4a37-a4a3-5077747bb1eb
# ╟─f78da556-2a09-4d7f-986e-00517fed59ef
# ╟─adf59a08-ab44-4bc4-a31f-132fa7924de6
# ╠═78fdbb88-0237-4208-bab4-f584587b43a0
# ╠═e073c48a-f763-463c-8b3c-67497147e22c
# ╟─7bfcd6ac-0d85-4b56-994c-73179a547b6a
# ╟─095dd17b-fbe6-4ab4-9815-d78fe14e0491
# ╟─2c7d0165-5f0b-4cf1-8d77-825ac1ce5519
# ╟─7310d3e0-7aa3-4af8-b6d3-989398d7e560
# ╟─f16922cf-58cb-445f-9fe9-1886e14d2b12
# ╟─cb06c3d8-fdaf-4076-b88f-0886a989576f
# ╟─7fbb99cd-5ec5-4852-a017-e7748b7b5ceb
# ╟─f1abc127-4e1c-48aa-ad54-d8115327c451
# ╟─5a4a8976-e2e9-4815-a840-0df78cd7201e
# ╟─37ffea46-d636-4d0a-a579-5349a920d925
# ╟─71d513b4-3bf1-4b2f-943a-8868bf99cde2
# ╠═34826510-9602-4a49-8dfd-c34368cc8e7d
# ╠═4d7bb9c4-b32f-4697-80b3-bc252c530f74
# ╠═33b50157-2f64-498e-a972-fc3d63156a89
# ╠═40966def-ae1f-4ee8-b331-70c544901cbc
# ╠═97a29d85-33d1-4368-822a-5737a4566b07
# ╠═8133a630-c47b-11ec-2b78-571c076a8c9a
# ╠═568d711f-40c1-465e-b927-3c6f2ac3dd24
# ╠═83bd5e96-a222-42cf-b516-7776f7c9226e
# ╠═89f3fbf6-dae7-4a91-a368-54c47aede5b5
# ╟─9b31d8d3-9a7e-4bdf-8c11-efe059fc00fe
