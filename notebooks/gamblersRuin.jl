### A Pluto.jl notebook ###
# v0.17.2

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

# ╔═╡ 743ebc88-841e-11eb-0e1d-5f7984b0f276
begin
#try
	using Random
	using Plots
    using PlutoUI
	using LaTeXStrings
	using Statistics
	using StatsBase
	using HypertextLiteral
#	using InteractiveUtils
#=catch
using Pkg
Pkg.activate(mktempdir())
Pkg.add("HypertextLiteral")
Pkg.add("Plots")
Pkg.add("Random")
Pkg.add("StatsBase")
Pkg.add("PlutoUI")
Pkg.add("Statistics")
Pkg.add("LaTeXStrings")
	using HypertextLiteral
	using Random
	using Plots
    using PlutoUI
	using LaTeXStrings
	using Statistics
	using StatsBase
	

	
end
	md""" ## imported packages """
=#
end

# ╔═╡ 10135c18-8429-11eb-35b8-a1f4412a99de
md"""
# Gambler's Ruin 🎰
"""

# ╔═╡ 7faeadda-6749-4fa9-b10e-4b7abcca197d
TableOfContents(aside=true)

# ╔═╡ 3782d921-a1a6-4277-9108-106b4281b211
md" ## Welcome to Gauß Island!"

# ╔═╡ b634c37d-ad76-4ee2-83f2-50ec1382da84
begin

md""" Please choose your Player: $(@bind player Select(["Captain Bayes 👩", "Captain Venn 🧔"]))"""
end

# ╔═╡ 548170ab-6e70-4dbe-80ef-b6639ddeec19
begin

	md"""If you choose to **start another random game**, please actualize this cell by pressing the $(@bind new_rand Button("New random game")) button and press "Start over" before tossing again.
		"""
#=	html"""<p>If you choose to start another game, please actualize this cell by pressing the 
	
	<img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.0.0/src/svg/caret-forward-circle-outline.svg" style="width: 1em; height: 1em; margin-bottom: -.2em;"> in the lower-right corner!</p>"""
	=#
end

# ╔═╡ 5e652821-67ed-4f28-b377-e11bfec2c7d5
md""" Good job! So let's speed it up a bit, shall we? You can see the outcome for different games if you change the seed!"""

# ╔═╡ 3568e317-bd51-46f7-abd0-7a583b6fbfa7
md"""
## Simulation of a single game

"""

# ╔═╡ c236b829-cf6e-4819-9a35-78421728ca58
md"""
initial coins $player: $(@bind a0 Slider(1 :1: 20,default = 10,show_value=true))
"""

# ╔═╡ aa6c0d3d-fd08-4a68-9a5d-9b4b57726981
md""" The next interesting question would be to calculate the average time of such a game; to calculate it, let's choose 10 and 15 coins again!


What is the average time for a game where one player has 10 coins and the other one has 15?

<t> = $(@bind t_average Select(["10", "50", "150", "500", "1000"]))"""

# ╔═╡ 275fdf1d-f6ef-43fd-a75d-13ba121b9cbd
md""" Choose the parameters for our experiments:

How many coins does Captain Bayes get in the beginning? $(@bind n NumberField(1:100, default = 10))

How many coins does Captain Venn get in the beginning? $(@bind m NumberField(1:100, default = 10))

How often do they play? $(@bind Nrep NumberField(100:100:3000, default = 300))"""

# ╔═╡ 8138c730-841e-11eb-362a-eff54174a0c3
begin 

	#n = 5
	#m = 3
	N = n + m
	#Nrep = 100000
	L_res = zeros(Nrep)
	N_a   = 0
	for j in 1: Nrep
		global N_a
		x = n
		step = 0
		flag_continue = true
		while flag_continue
			step += 1
			x += rand([-1,+1])
			if x == 0
			  L_res[j] = step
			  flag_continue = false		
			elseif x == N
			  L_res[j] = step
			  N_a += 1				
			  flag_continue = false					
			end
		end
	end
	hist_data = countmap(L_res)
	avg   = mean(L_res)
	delta = sqrt(var(L_res)/Nrep)
	rel_frq_A   = N_a / Nrep
	md""" ## repeated experiments
	- mean and sandard deviation of gambling time 
	- comparison with eaxct results
	"""
	
t = 0
s = 0
for k in keys(eval(hist_data))
		global t += k * hist_data[k]
		global s += hist_data[k]
end
	#histogram(hist_data, bins = 50, label = :none)
t_av = t/s
	histogram(L_res, bins = 20, label = :none)
	
plot!([t_av],[maximum(values(hist_data))*10], line = (1, 2.0, :bar), linecolor = "red", label = string("Average = ", avg) , legend=:top)
	 
	
plot!([n*m],[maximum(values(hist_data))*10], line = (1, 1.0, :bar), linecolor = "green", label = string("Theoretical average time =",n*m), legend=:top) 

end


# ╔═╡ f454f7b4-e4fb-4ce0-b2fe-a25d86ffe35e
begin
plot(["Bayes", "Venn"],[N_a/Nrep, (Nrep-N_a)/Nrep], line = (1., 1., :bar), label = "Simulation")
plot!(["Bayes", "Venn"], [n/(n+m), m/(n+m)], line = (1.0, 0.0, :bar), bar_width = 0.02,
    marker = (:circle, 50, 1), color = :red, label = :none, legend = :right)
plot!(["Bayes", "Venn"], [n/(n+m), m/(n+m)],
		line = (0., 0, :path),
    normalize = false,
    bins = 10,
	bar_width = 0.2,
    marker = (7, 1., :o),
    markerstrokewidth = 1,
    color = :red,
    fill = 1.,
    orientation = :v,
	ylabel = "Relative frequency of wins",
	label = "theory")
end

# ╔═╡ 6da5deec-8426-11eb-31f3-6b0db5369c5e
md""" Let's compare the results:
- simulation   ``\langle t \rangle = ``     $(round(avg,digits=2)) ±  $(round(delta,digits=2)) 

- exact mean  =  $(round(n*m,digits=2)),


-   rel. frequency af victories of Bayes  =      $(round(rel_frq_A,digits=2))
-   exact probability  =  $(round(n/N,digits=2))
"""

# ╔═╡ a97886eb-4762-4db7-ae13-6cbb0fb7abb0
md""" **Bayes**: Well, Captain Venn, as always, our results do not differ for very big numbers - but my way was certainly faster!

**Venn**: That might be true, but my way was the more fun way ;-) Want to play another round?

**Bayes**: Maybe later! Now I am eager to show our interested readers how I calculated the probability, average time, and variance!

Show derivation? 👉 $(@bind derivation CheckBox())"""

# ╔═╡ c771b1b3-9d8e-45f3-8f0d-486e454e950e
Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/Ernesto_completed.gif")

# ╔═╡ 2458af49-f528-4b30-ae08-82db5361555f
md""" ## Derivation of the theoretical values"""

# ╔═╡ 6e56622a-3065-4517-aa4c-3545e1ad07fd
md"""
#### Rephrasing the game
First we summarize the game again. We have two players, player ``A`` and player ``B`` who start with a number of coins ``N_A`` and ``N_B``. Since the number of coins of player ``B`` can be derived by those of the other player and the total number of coins ``N = N_A + N_B``, we will formulate the game from the perspective of player ``A``.

The possible states ``X_t`` of the game at a certain time ``t`` are given by the number of coins ``K`` player ``A`` possesses at that certain moment ``t`` of the game. The range of possible states is given by ``K\in [0,1,\dots, N]``. 

The game ends if we reach either ``K=0`` or ``K = N``. This is mathematically realized by saying in the next time step we have a certain probability to remain in one of these **stop states** ``P(X_{t+1} = N \mid X_{t} = N) = 1`` or ``P(X_{t+1} = 0 \mid X_{t} = 0) = 1``.
We call this a **stopped Markov process** which is similar to reaching Turtle island.
This time we have two stopping criteria but a one-dimensional problem.

When starting from an intermediate state ``0 < K < N`` at time ``t``, the probabilities to reach a neighboring state ``K+1`` or ``K-1`` in the next time step ``t+1`` are given by a probability of one half, since we use a fair coin.

$P(X_{t+1} = K+1 \mid X_{t} = K) = 0.5$

#### Description of the Markov process as matrix
The probability ``P(X_t)`` of each state after ``t`` steps of a Markov process can be described by a Markov matrix ``M``. 
Assume we have the probability distribution of the states ``X_t`` at time ``t`` written down as **vector** 

$\pi_t = \big(P(X_t = 0), P(X_t = 1), \dots, P(X_t = K), \dots, P(X_t = N)\big)$

and the **matrix** with the transition probabilities ``\frac{1}{2}`` for neighboring states ``K\in [1,\dots, N-1]`` or ``1`` for the stop states ``K \in [0,N]``

$M = \begin{pmatrix} 1 & 0 & 0 & 0 & 0 &\cdots \\ 0.5 & 0 & 0.5 & 0 & 0 & \cdots \\ 0 & 0.5 & 0 & 0.5 & 0 & \cdots \\ 0 & 0 & \ddots & \ddots & \ddots & 0 \\
0 & 0 & 0 & 0.5 & 0 & 0.5 \\
0 & 0 &  \cdots & 0 & 0 & 1\end{pmatrix}$

Then the **probability distribution for the next state** is given by the matrix multiplication:

$\pi_{t+1} = \pi_t \cdot M$

Note, that ``\pi`` is a row vector which is a common convention for matrix processes. One can also also use column vector by transposing the equation.

A simple example for $N = 4$ and starting with two coins yields
$\pi_0 = (0, 0, 1, 0 , 0)$

$M = \begin{pmatrix} 1 & 0 & 0 & 0 & 0 \\ 0.5 & 0 & 0.5 & 0 & 0 \\ 0 & 0.5 & 0 & 0.5 & 0\\ 0 & 0 & 0.5 & 0 & 0.5 \\ 0 & 0 & 0 & 0 & 1 \end{pmatrix}$

The probability distribution for the next step yields a probability of one half for 1 or 3 coins.

#### Derivation of the probability to win the game
We are searching for the probability ``P_I(N)``, that player ``A`` reaches state ``X = N`` when starting with an initial amount of ``I`` coins. 
Note that we can use the Markov property so that the time or time steps are irrelevant for the description of the state which only depends on the current amount of coins.

The probability to win with currently ``I`` coins is equal to the probability to win a coin times the probability to win the whole game with ``I+1`` coins plus the probability for the opposite,  that we loose a coin but still win the game with ``I-1`` coins.

$P_I(N) = Q \cdot P_{I+1}(N) + (1-Q) \cdot P_{I-1}(N)$
with the probability ``Q`` to win a coin. In our example ``Q = \frac{1}{2}`` but for the purpose of generality we will keep ``Q`` arbitrary.

From now on we omit the argument ``(N)`` since we will always talk about the probability to win.
We add the factor ``Q + (1-Q)`` to the term on the left side and rearrange the equation to

$P_{I+1}- P_I = \frac{1-Q}{Q} (P_I - P_{I-1})$
That way we have obtained a recurrsion for the differences ``P_{I+1} - P_{I}``

Since the probability to win is zero when starting with zero coins we obtain for the first recursion term:

$P_2 - P_1 = \frac{1-Q}{Q} P_1$
The next one yields:

$P_3 - P_2 = \frac{1-Q}{Q}(P_2 - P_1) = \left(\frac{1-Q}{Q}\right)^2 P_1$
and so on:

$P_I - P_{I-1} = \left(\frac{1-Q}{Q}\right)^{I-1} P_1$
To get rid of $P_1$ we sum over all such terms having a telescope sum where the terms in between cancel out:

$P_I - P_0 = \sum_{K = 1}^{I} (P_K - P_{K-1}) = \sum_{K = 1}^I \left(\frac{1-Q}{Q}\right)^{K-1} P_1$

In our case (``Q = \frac{1}{2}``) this simplifies to 

$P_I = I\cdot P_1, \quad Q = 0.5$
For all other cases we use an index shift ``K \rightarrow K-1`` and applying the geometric sum rule leads to 

$P_I = \frac{1-\left(\frac{1-Q}{Q}\right)^I}{1-\frac{1-Q}{Q}} P_1, \quad Q \neq 0.5$

Now the last step is to insert the upper limit ``I = N`` for which the probability has to be one. We obtain:

$1 = P_N = N\cdot P_1\quad \Rightarrow P_1 = \frac{1}{N}, \quad Q = 0.5$
and

$1 = P_N = \frac{1-\left(\frac{1-Q}{Q}\right)^N}{1-\frac{1-Q}{Q}} P_1,\quad \Rightarrow P_1 = \frac{1-\frac{1-Q}{Q}}{1-\left(\frac{1-Q}{Q}\right)^N} \quad Q \neq 0.5$

Thus the probability to win when starting with $I$ coins and having an opponent with $N-I$ coins is

$P_I(N) = \begin{cases} \dfrac{I}{N} & Q = 0.5 \\ I\cdot \dfrac{1-\frac{1-Q}{Q}}{1-\left(\frac{1-Q}{Q}\right)^N} & Q \neq 0.5 \end{cases}$


[`More detailed proof by Karl Sigman`](http://www.columbia.edu/~ks20/stochastic-I/stochastic-I-GRP.pdf)



"""

# ╔═╡ fcc9ac0d-b79e-4f6c-a19f-481560747bca
md"""

#### Derivation of the mean duration of a game
We are interested in the mean time

$\langle t_{\text{end}}  \rangle = \langle t_{X = 0 \lor X = N} \rangle = \sum_t t \cdot  P_I(N \lor 0,t)$
it takes a game to end, with the probability ``P_I(N\lor 0,t)`` that a game ended after $t$ time steps with an initial amount of $I$ resp. $N-I$ coins.

Therefore we have to derive the probability to end a game after $t$ steps first. In principle there are three ways to do this:
- We could use the **Markov chain matrix** to compute the probability distributions after $t$ steps. The increase of the probability masses for state zero and state $N$ in time step $t$ corresponds to the searched probability.
- Combinatorial reasoning applying the **principle of indifference** can lead us to an expression for the probability which might be difficult to evaluate
- Using **generating functions** will be the final trick to evaluate the probabilities.

Let's start with counting the **arbitrary paths** $A$ from the initial point $I$ to both of the end points $N$ and $0$ in exactly $t$ time steps. This is given by the binomial coefficient where one needs to win $N-I ={} \uparrow - \downarrow$ more games than loosing with a total of $t ={}  \uparrow + \downarrow$ games in the first case:

$A(I\rightarrow N,t) = A_t(N-I)= \binom{t}{\frac{t+N-I}{2}}$
$A(I\rightarrow 0,t) = A_t(-I) = \binom{t}{\frac{t-I}{2}}$

Since some of these possible tracks might hit the boundaries before, so we have to subtract all those boundary hitting possibilities to get the **favourable paths** $F$.

$F_t(N-I) = A_t(N-I) - \sum_{k = N-I}^{t-2} F_k(N-I) \cdot A_{t-k}(0) - \sum_{k = I}^{t-N} F_k(-I) \cdot A_{t-k}(N)$
$F_t(-I) = A_t(-I) - \sum_{k = N-I}^{t-N} F_k(N-I) \cdot A_{t-k}(-N) - \sum_{k = I}^{t-2} F_k(-I) \cdot A_{t-k}(0)$

Rewriting and using $A_0(0) = 1$ leads to

$A_t(N-I) = \sum_{k=N-I}^{t} F_k(N-I) \cdot A_{t-k}(0) + \sum_{k=I}^{t-N} F_k(-I) \cdot A_{t-k}(N)$
$A_t(-I) = \sum_{k = N-I}^{t-N} F_k(N-I) \cdot A_{t-k}(-N) - \sum_{k = I}^{t} F_k(-I) \cdot A_{t-k}(0)$

$A_t(b) = \sum_{k=b}^{t} F_k(b) \cdot A_{t-k}(0) + \sum_{k=a}^{t-N} F_k(-a) \cdot A_{t-k}(a+b)$

The **possible paths** are simply given by $2^t$.


"""

# ╔═╡ 9b359471-5be9-4fb3-9a50-6c9d45a3d79f
md"""
## About the creators

This notebook was created by **Prof Wolfgang von der Linden**, **Johanna Moser** and **Gerhard Dorn** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ 24e84aa6-d0da-4232-b309-43b41fb187b8
begin
rng2 = MersenneTwister(1)
md"""
### initialize second random numbers
"""
end

# ╔═╡ e9a4142f-844e-40fd-ac74-1ecdbcc7db00
begin
	new_rand
	steps = rand(rng2,[1, -1], 300)
	
	#click_counter = @bind first_coins_counter ClickCounterWithReset("Toss!", "Start over!")
	
	md"""
	### Create new random variable"""
end

# ╔═╡ e17b3b1f-d481-41f8-8771-77f52847258e
begin
	n_max = 1000
	slider_sample_size = @bind n_sample_size Slider(1:1: n_max ,default = 10,show_value=true)
	
md""" 
### some parameters and sliders
"""
end

# ╔═╡ ce3d3d5e-d244-4960-bc08-e366154af9a7
md"""
enter seed:  $(@bind seed Slider(1:100,default=5,show_value=true)) 

steps  : $(slider_sample_size)


"""

# ╔═╡ a0d87c4e-ff2c-4454-ab01-c07031ccc727
ClickCounterWithReset(text="Click", reset_text="Reset") = HTML("""
<div>
<button>$(text)</button>&nbsp;&nbsp;&nbsp;&nbsp;
<a id="reset" href="#">$(reset_text)</a>
</div>
<script id="blabla">
// Select elements relative to `currentScript`
const div = currentScript.previousElementSibling
const button = div.querySelector("button")
const reset = div.querySelector("#reset")
// we wrapped the button in a `div` to hide its default behaviour from Pluto
let count = 0
button.addEventListener("click", (e) => {
	count += 1
	
	div.value = count
	div.dispatchEvent(new CustomEvent("input"))
	e.stopPropagation()
})
	reset.addEventListener("click", (e) => {
	count = 0
	
	div.value = count
	div.dispatchEvent(new CustomEvent("input"))
	e.stopPropagation()
	e.preventDefault()
})
// Set the initial value
div.value = count
</script>
""")

# ╔═╡ 5235f397-50df-4b02-9a6d-0c00a10c8e61
click_counter = @bind first_coins_counter ClickCounterWithReset("Toss!", "Start over!")

# ╔═╡ 3ec4d098-6b7a-41aa-b875-34ff83065a94
begin
	#if coins_a > 0 && coins_b > 0
		md"""$(click_counter) So let's  play! Click here to toss a coin!"""
	#else
		
	#end
	
end


# ╔═╡ 52009176-20b6-4afd-b9dd-71df43b873c8
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

# ╔═╡ 918b2535-79f0-4593-b13b-4f3f39237566
if first_coins_counter < 5
	hide_everything_below
end

# ╔═╡ 29e61cbb-be3c-43d4-8864-6d9272270561
if derivation == false
	hide_everything_below
end

# ╔═╡ 69ee3ead-c1c8-4671-b9bd-b23fa56396d9
begin
keep_working(text=md"The answer is not quite right.", title="Keep working on it!") = Markdown.MD(Markdown.Admonition("danger", title, [text]));

almost(text, title="Almost there!") = Markdown.MD(Markdown.Admonition("warning", title, [text]));

hint(text, title ="Hint") = Markdown.MD(Markdown.Admonition("hint", title, [text]));
	
correct(text=md"Great! You got the right answer! Let's move on to the next section.", title="Got it!") = Markdown.MD(Markdown.Admonition("correct", title, [text]));
md" Definition of Boxes"
end

# ╔═╡ 7e838398-4eab-4def-9bd5-003c5223436d
#if t richtig box korrekt man berechnets mit a0b0 btw variance is delta t... if not not quite there yet, hint: ...
if t_average == "150"
	correct(md"Great! For $a_0$ and $b_0$ coins, you can calculate the average time of a game with $<t> = a_0b_0$.    
By the way: The variance of the time can be calculated with $<(\Delta t)> = \frac{a_0 b_0}{3}\big(a_0^2 + b_0^2 -2\big)$")
else  
	keep_working(md" You might want to scroll further down to see the results of more simulations, maybe you'll find the answer there!") #maybe hint?
end


# ╔═╡ 528d9788-cf10-4079-b210-760ea79b6d66
hint(md" If you need help, or are interested in a full derivation of there formulae, you can scoll down to the bottom of this notebook!")

# ╔═╡ 36da5e49-ac59-4eee-b4bf-7a6dbca6a397
begin
		venn_speaking = "https://raw.githubusercontent.com/Captain-Bayes/images/main/venn_100px.gif"
	bayes_speaking = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bayes_100px.gif"
	venn_small = "https://raw.githubusercontent.com/Captain-Bayes/images/main/venn_50px1.gif" 
	bayes_small = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bayes_50px.gif" 

	
heads = repeat([""],5,1)
tails = repeat([""],5,1)
	coin = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin.gif"
heads[1] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_heads_1.gif"
heads[2] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_heads_2.gif"
heads[3] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_heads_3.gif"
heads[4] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_heads_4.gif"
heads[5] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_heads_5.gif"
	
tails[1] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_tails_1.gif"
tails[2] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_tails_2.gif"
tails[3] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_tails_3.gif"
tails[4] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_tails_4.gif"
tails[5] = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Coin_tails_5.gif"
bayes_winning = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bayes_100px_winning.gif"
venn_winning = "https://raw.githubusercontent.com/Captain-Bayes/images/main/venn_100px_winning.gif"
	
	md"""Images"""
end

# ╔═╡ 3b8c2f10-4852-4f47-bc16-b07ace186847
begin
	#show gifs
	if player == "Captain Bayes 👩"
		notplayer = "Captain Venn 🧔"
		md"""$(Resource(bayes_small)) Let's do this! """
	elseif player == "Captain Venn 🧔"
		notplayer = "Captain Bayes 👩"
		md"""$(Resource(venn_small)) Let's do this! """
	end
	
end

# ╔═╡ 7585c3d4-dff2-4851-a385-b34a9d32caff
md"""

The **rules of the game** are very simple. 
- you are **two players**, Captain Bayes 👩‍🦰 and Captain Venn 🧔
- initially you have **``a_0`` coins** and $(notplayer) ``b_0`` **coins**
- at each step a **coin is flipped**. If it shows **head you win** one coin from $notplayer. In the other case the opposite happens
- so the number of coins  ``a_t`` that you have at time ``t`` follows a random walk. In each step it can increase or decrease by one with equal probability.

- **THE END** of the game is reached if one person has **lost all his/her money**.
- So the game is over if, ``a_t = 0``  (you lost)  or  ``a_t = a_0 + b_0`` (you won)

"""

# ╔═╡ 3fab65ba-da18-46d2-95e9-f41540dbfb32
md"""
initial coins $notplayer: $(@bind b0 Slider(1 :1: 20,default = 10,show_value=true))
"""

# ╔═╡ 59eefc76-8432-11eb-398a-15c5a7294116
begin
	rng = MersenneTwister(seed)
	steps_2 = rand(rng, [-1,1], 1,n_max+1)

	NN = a0 + b0
	tmax = maximum([a0 * b0, n_sample_size])
	xx = a0
	Lt = [1:n_sample_size+1;]
    Lx = zeros(n_sample_size+1)
	rt = 0

	for i in 1: n_sample_size+1
		Lx[i] = xx		
        if xx == 0 || xx == NN
			Lt = Lt[1:i]
			Lx = Lx[1:i]		
			rt = i
			#add random gif of winner
			break
		else
			if player == "Captain Venn 🧔"
				xx -= steps_2[i]
			else
				xx +=steps_2[i]
			end
		end
	end
	


	plot(Lt,Lx,marker = :cross,label = "path of $(player[1:13])")

	plot!([0,tmax],[0,0],color = :red,linewidth = 2,label = false)
	plot!([0,tmax],[NN,NN],color = :red,linewidth = 2,label = false)
	if rt > 0
		txt = "Gamblers ruin (a single run)\ntime to the end of game = $(rt) steps"	
	else
		txt = "Gamblers ruin (a single run)"
	end
	
	plot!(xlim=(0,tmax),ylim=(-1,NN+1),xlabel = "time", ylabel = "Coins of $(player[1:13])",title = txt,legend = :right)



end

# ╔═╡ abcbfc9e-5d8f-444e-acc3-737d67f85394
md""" $(Resource(bayes_speaking, :width => 200))Hmm... I wonder how likely it is for me to win, if I start with, let's say 10 coins and Captain Venn starts with 15 coins for example... Can you help me calculate the probability?


What is the probability for Captain Bayes to win if she has 10 coins and Captain Venn has 15? 

P = $(@bind P NumberField(0:0.1:1))"""

# ╔═╡ 46d93fe0-5dc6-42b1-8caf-2987cb907e64
if P == 0.4
	correct(md"Great! For $a_0$ and $b_0$ coins, you can calculate the probability that player A wins with  $P_\text{A} = \frac{a_0}{a_0+b_0}$")
else  
	keep_working(md" You might want to scroll further down to see the results of more simulations, maybe you'll find the answer there!") #maybe hint?
end

# ╔═╡ 65c66c12-3faa-4545-8173-bf2d6990c65e

md""" $(Resource(venn_speaking, :width => 200)) Oh Captain Bayes, you and your calculations! Everyone knows, the only way to truly determine probabilities is through a lot of thorough experiments!  Are you up for another round (or maybe a few 100 or 1000 just to be sure) to *really* find out how many games you'd win, as well as their average time?""" 

# ╔═╡ 13a0ad55-acff-4a7f-9aed-c5f4a3dfa9d1
html"""
	<style>
	.compasstable td {
		font-size: 50px;
		text-align: center;
	}
	
	</style>
"""

# ╔═╡ 20ab96cf-ce70-434e-926a-ce81ae607a17
function pretty(M::Matrix{T} where T<:String)
    max_length = maximum(length.(M))
    dv="<div style='display:flex;flex-direction:row'>"
    HTML(dv*join([join("<div style='width:40px; text-align:center'>".*M[i,:].*"</div>", " ") for i in 1:size(M,1)]
            , "</div>$dv")*"</div>")
end

# ╔═╡ 91919d89-2a78-4d50-b2f9-b4fdfa948ba1
begin
	#find out how to get nr of coins, random? 
	coin_nr = 5
	coin_nr_b =  coin_nr
	
	md""" Very well, **$player** ! You and your opponent will recieve an initial treasure of $coin_nr coins!
	
	$(repeat(["💰"], 1,coin_nr) |> pretty)""" 
end

# ╔═╡ 1e4436d6-c508-43a0-9422-798f9229207a
begin
	#coin gif 
	coin_gif_1 =  rand(heads)
	coin_gif_2 =  rand(tails)
	first_coins_counter
	
	steps_to_end_game = findall(abs.(cumsum(steps)) .== coin_nr)[1]
	
	#coins_a = coin_nr
	#coins_b = coin_nr
	# middle of the game
	if first_coins_counter > 0 && first_coins_counter <= steps_to_end_game 
		coins_a = coin_nr + sum(steps[1:first_coins_counter])
		coins_b = coin_nr - sum(steps[1:first_coins_counter])
	elseif first_coins_counter == 0 #game start
		coins_a = coin_nr
		coins_b = coin_nr
	else #game ended
		coins_a = coin_nr + sum(steps[1:steps_to_end_game])
		coins_b = coin_nr - sum(steps[1:steps_to_end_game])
	end
	#for i in 1:first_coins_counter
	#	global coins_a += steps[i]
	#	global coins_b -= steps[i]
	#end
	if first_coins_counter != 0 && first_coins_counter <= steps_to_end_game
		if steps[first_coins_counter] == 1
			md"""Head! You won! $(Resource(coin_gif_1, :width => 200))"""
		elseif steps[first_coins_counter] == -1
			md"""Tails! You lost... $(Resource(coin_gif_2, :width => 200))"""
		end
	end
	
end

# ╔═╡ 7d57740b-6902-4521-8d7a-353d1c664abe
begin
#bayes und venn gleich hoch?
#a_won und b_won umändern zu bayes und venn, die sich freuen gewonnen zu haben
if player == "Captain Venn 🧔"
	a_won = venn_winning
	b_won = bayes_winning
	image_a = venn_small
	image_b = bayes_small
else
	a_won = bayes_winning
	b_won = venn_winning
	image_a = bayes_small
	image_b = venn_small
end
	
if coins_a == coins_a+coins_b
		Resource(a_won)
	elseif coins_b == coins_a + coins_b
		Resource(b_won)
	else @htl("""
<table class="compasstable">
	
    <tbody>
        
        <tr>
            <td> $(coins_a)</td>
            <td><img src=$(image_a) width=100><img src=$(image_b) width=100></td>
            <td>$(coins_b)</td>
        </tr>
       
    </tbody>
</table>
""")
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
HypertextLiteral = "~0.9.3"
LaTeXStrings = "~1.3.0"
Plots = "~1.24.0"
PlutoUI = "~0.7.20"
StatsBase = "~0.33.13"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0bc60e3006ad95b4bb7497698dd7c6d649b9bc06"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.1"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f885e7e7c124f8c92650d61b9477b9ac2ee607dd"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.1"

[[ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "9a1d594397670492219635b35a3d830b04730d62"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.1"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "30f2b340c2fff8410d89bfcdc9c0a6dd661ac5f7"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.62.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fd75fa3a2080109a2c0ec9864a6e14c60cca3866"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.62.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "8a954fed8ac097d5be04921d595f741115c1b2ad"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+0"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun"]
git-tree-sha1 = "02a083caba3f73e42decb810b2e0740783022978"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.24.0"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "1e0cb51e0ccef0afc01aab41dc51a3e7f781e8cb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.20"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─10135c18-8429-11eb-35b8-a1f4412a99de
# ╟─7faeadda-6749-4fa9-b10e-4b7abcca197d
# ╟─3782d921-a1a6-4277-9108-106b4281b211
# ╟─b634c37d-ad76-4ee2-83f2-50ec1382da84
# ╟─3b8c2f10-4852-4f47-bc16-b07ace186847
# ╟─91919d89-2a78-4d50-b2f9-b4fdfa948ba1
# ╟─7585c3d4-dff2-4851-a385-b34a9d32caff
# ╟─3ec4d098-6b7a-41aa-b875-34ff83065a94
# ╟─1e4436d6-c508-43a0-9422-798f9229207a
# ╟─7d57740b-6902-4521-8d7a-353d1c664abe
# ╟─548170ab-6e70-4dbe-80ef-b6639ddeec19
# ╟─918b2535-79f0-4593-b13b-4f3f39237566
# ╟─5e652821-67ed-4f28-b377-e11bfec2c7d5
# ╟─3568e317-bd51-46f7-abd0-7a583b6fbfa7
# ╟─ce3d3d5e-d244-4960-bc08-e366154af9a7
# ╟─c236b829-cf6e-4819-9a35-78421728ca58
# ╟─3fab65ba-da18-46d2-95e9-f41540dbfb32
# ╟─59eefc76-8432-11eb-398a-15c5a7294116
# ╟─abcbfc9e-5d8f-444e-acc3-737d67f85394
# ╟─46d93fe0-5dc6-42b1-8caf-2987cb907e64
# ╟─aa6c0d3d-fd08-4a68-9a5d-9b4b57726981
# ╟─7e838398-4eab-4def-9bd5-003c5223436d
# ╟─528d9788-cf10-4079-b210-760ea79b6d66
# ╟─65c66c12-3faa-4545-8173-bf2d6990c65e
# ╟─275fdf1d-f6ef-43fd-a75d-13ba121b9cbd
# ╟─f454f7b4-e4fb-4ce0-b2fe-a25d86ffe35e
# ╟─8138c730-841e-11eb-362a-eff54174a0c3
# ╟─6da5deec-8426-11eb-31f3-6b0db5369c5e
# ╟─a97886eb-4762-4db7-ae13-6cbb0fb7abb0
# ╟─c771b1b3-9d8e-45f3-8f0d-486e454e950e
# ╟─29e61cbb-be3c-43d4-8864-6d9272270561
# ╟─2458af49-f528-4b30-ae08-82db5361555f
# ╟─6e56622a-3065-4517-aa4c-3545e1ad07fd
# ╟─fcc9ac0d-b79e-4f6c-a19f-481560747bca
# ╟─9b359471-5be9-4fb3-9a50-6c9d45a3d79f
# ╟─743ebc88-841e-11eb-0e1d-5f7984b0f276
# ╟─e9a4142f-844e-40fd-ac74-1ecdbcc7db00
# ╟─5235f397-50df-4b02-9a6d-0c00a10c8e61
# ╟─24e84aa6-d0da-4232-b309-43b41fb187b8
# ╟─e17b3b1f-d481-41f8-8771-77f52847258e
# ╟─a0d87c4e-ff2c-4454-ab01-c07031ccc727
# ╟─52009176-20b6-4afd-b9dd-71df43b873c8
# ╟─69ee3ead-c1c8-4671-b9bd-b23fa56396d9
# ╟─36da5e49-ac59-4eee-b4bf-7a6dbca6a397
# ╟─13a0ad55-acff-4a7f-9aed-c5f4a3dfa9d1
# ╟─20ab96cf-ce70-434e-926a-ce81ae607a17
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
