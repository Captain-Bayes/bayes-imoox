### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 743ebc88-841e-11eb-0e1d-5f7984b0f276
begin
try
	using Random
	using Plots
    using PlutoUI
	using LaTeXStrings
	using Statistics
	using StatsBase
	using HypertextLiteral
#	using InteractiveUtils
catch
using Pkg
Pkg.activate(mktempdir())
Pkg.add("Plots")
Pkg.add("Random")
Pkg.add("StatsBase")
Pkg.add("PlutoUI")
Pkg.add("Statistics")
Pkg.add("LaTeXStrings")
Pkg.add("HypertextLiteral")
	using Random
	using Plots
    using PlutoUI
	using LaTeXStrings
	using Statistics
	using StatsBase
	using HypertextLiteral

	
end
	md""" ## imported packages """
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

md""" Please choose your Player: $(@bind player Select(["Captain Bayes 👩‍🦰", "Captain Venn 🧔"]))"""
end

# ╔═╡ 548170ab-6e70-4dbe-80ef-b6639ddeec19
begin

	md"""If you choose to **start another random game**, please actualize this cell by pressing the $(@bind new_rand Button("New random game")) button.
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
    marker = (:circle, 50, 1), color = [:red], label = :none, legend = :right)
plot!(["Bayes", "Venn"], [n/(n+m), m/(n+m)],
		line = (0., 0, :path),
    normalize = false,
    bins = 10,
	bar_width = 0.2,
    marker = (7, 1., :o),
    markerstrokewidth = 1,
    color = [:red],
    fill = 1.,
    orientation = :v,
	ylabel = "Relative frequency of wins",
	label = "theory")
end

# ╔═╡ 6da5deec-8426-11eb-31f3-6b0db5369c5e
md""" Let's compare the results:
- simulation   <t> =      $(round(avg,digits=2)) ±  $(round(delta,digits=2)) 

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

# ╔═╡ e17b3b1f-d481-41f8-8771-77f52847258e
begin
	n_max = 1000
	slider_sample_size = @bind n_sample_size Slider(1:1: n_max ,default = 10,show_value=true)
	
md""" 
### some parameters and sliders
"""
end

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

# ╔═╡ e9a4142f-844e-40fd-ac74-1ecdbcc7db00
begin
	new_rand
	steps = rand(rng2,[1, -1], 300)
	
	click_counter = @bind first_coins_counter ClickCounterWithReset("Toss!", "Start over!")
	
	md"""
	### Create new random variable"""
end

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
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));

almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));

hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));
	
correct(text=md"Great! You got the right answer! Let's move on to the next section.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));
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
	if player == "Captain Bayes 👩‍🦰"
		notplayer = "Captain Venn 🧔"
		md"""$(Resource(bayes_small)) Let's do this! """
	elseif player == "Captain Venn 🧔"
		notplayer = "Captain Bayes 👩‍🦰"
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

# ╔═╡ ce3d3d5e-d244-4960-bc08-e366154af9a7
md"""
enter seed:  $(@bind seed Slider(1:100,default=5,show_value=true)) 

steps  : $(slider_sample_size)

initial coins $player: $(@bind a0 Slider(1 :1: 20,default = 10,show_value=true))

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
	


	plot(Lt,Lx,marker = :cross,label = "path of $player")

	plot!([0,tmax],[0,0],color = :red,linewidth = 2,label = false)
	plot!([0,tmax],[NN,NN],color = :red,linewidth = 2,label = false)
	if rt > 0
		txt = "Gamblers ruin (a single run)\ntime to the end of game = $(rt) steps"	
	else
		txt = "Gamblers ruin (a single run)"
	end
	
	plot!(xlim=(0,tmax),ylim=(-1,NN+1),xlabel = "time", ylabel = "Coins of $player",title = txt,legend = :right)



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
# ╟─24e84aa6-d0da-4232-b309-43b41fb187b8
# ╟─e17b3b1f-d481-41f8-8771-77f52847258e
# ╟─a0d87c4e-ff2c-4454-ab01-c07031ccc727
# ╟─52009176-20b6-4afd-b9dd-71df43b873c8
# ╟─69ee3ead-c1c8-4671-b9bd-b23fa56396d9
# ╟─36da5e49-ac59-4eee-b4bf-7a6dbca6a397
# ╟─13a0ad55-acff-4a7f-9aed-c5f4a3dfa9d1
# ╟─20ab96cf-ce70-434e-926a-ce81ae607a17
