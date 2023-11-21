### A Pluto.jl notebook ###
# v0.19.32

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

# ╔═╡ 91919d89-2a78-4d50-b2f9-b4fdfa948ba1
begin
	#find out how to get nr of coins, random? 
	coin_nr = 5
	coin_nr_b =  coin_nr
	
	md""" Very well, **$player** ! You and your opponent will recieve an initial treasure of $coin_nr coins!
	
	$(repeat(["💰"], 1,coin_nr) |> pretty)""" 
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

# ╔═╡ 3ec4d098-6b7a-41aa-b875-34ff83065a94
begin
	#if coins_a > 0 && coins_b > 0
		md"""$(click_counter) So let's  play! Click here to toss a coin!"""
	#else
		
	#end
	
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

# ╔═╡ 548170ab-6e70-4dbe-80ef-b6639ddeec19
begin

	md"""If you choose to **start another random game**, please actualize this cell by pressing the $(@bind new_rand Button("New random game")) button and press "Start over" before tossing again.
		"""
#=	html"""<p>If you choose to start another game, please actualize this cell by pressing the 
	
	<img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.0.0/src/svg/caret-forward-circle-outline.svg" style="width: 1em; height: 1em; margin-bottom: -.2em;"> in the lower-right corner!</p>"""
	=#
end

# ╔═╡ 918b2535-79f0-4593-b13b-4f3f39237566
if first_coins_counter < 5
	hide_everything_below
end

# ╔═╡ 5e652821-67ed-4f28-b377-e11bfec2c7d5
md""" Good job! So let's speed it up a bit, shall we? You can see the outcome for different games if you change the seed!"""

# ╔═╡ 3568e317-bd51-46f7-abd0-7a583b6fbfa7
md"""
## Simulation of a single game

"""

# ╔═╡ ce3d3d5e-d244-4960-bc08-e366154af9a7
md"""
enter seed:  $(@bind seed Slider(1:100,default=5,show_value=true)) 

steps  : $(slider_sample_size)


"""

# ╔═╡ c236b829-cf6e-4819-9a35-78421728ca58
md"""
initial coins $player: $(@bind a0 Slider(1 :1: 20,default = 10,show_value=true))
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

# ╔═╡ aa6c0d3d-fd08-4a68-9a5d-9b4b57726981
md""" The next interesting question would be to calculate the average time of such a game; to calculate it, let's choose 10 and 15 coins again!


What is the average time for a game where one player has 10 coins and the other one has 15?

<t> = $(@bind t_average Select(["10", "50", "150", "500", "1000"]))"""

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

# ╔═╡ 65c66c12-3faa-4545-8173-bf2d6990c65e

md""" $(Resource(venn_speaking, :width => 200)) Oh Captain Bayes, you and your calculations! Everyone knows, the only way to truly determine probabilities is through a lot of thorough experiments!  Are you up for another round (or maybe a few 100 or 1000 just to be sure) to *really* find out how many games you'd win, as well as their average time?""" 

# ╔═╡ 275fdf1d-f6ef-43fd-a75d-13ba121b9cbd
md""" Choose the parameters for our experiments:

How many coins does Captain Bayes get in the beginning? $(@bind n NumberField(1:100, default = 10))

How many coins does Captain Venn get in the beginning? $(@bind m NumberField(1:100, default = 10))

How often do they play? $(@bind Nrep NumberField(100:100:3000, default = 300))"""

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

# ╔═╡ 29e61cbb-be3c-43d4-8864-6d9272270561
if derivation == false
	hide_everything_below
end

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

This notebook was created by **Prof Wolfgang von der Linden**, **Johanna Moser** and by **[Gerhard Dorn](https://github.com/dorn-gerhard)** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes22&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

# ╔═╡ 743ebc88-841e-11eb-0e1d-5f7984b0f276
begin

	using Random
	using Plots
    using PlutoUI
	using LaTeXStrings
	using Statistics
	using StatsBase
	using HypertextLiteral

	md""" ## imported packages """

end

# ╔═╡ 1f0bc289-d6ad-478f-b976-d6526966a68c
begin
	
	# how to extract data from the non so csv csv file
	#=
	file_source = readdlm("data_marine_litter.csv", '\\')
		litter_count = []
		litter_mass = []
		for i in 3:986
			append!(litter_count, parse(Float64, reverse(split(file_source[i], ","))[8]))
		append!(litter_mass, parse(Float64, reverse(split(file_source[i], ","))[7]))
			end
		#a1 = convert(Array{Float64,1}, marine_numbers)
	
	writedlm("litter_beach.txt", [["count" "mass"]; [litter_count litter_mass]], "," )
	
	=#
end

# ╔═╡ e9a4142f-844e-40fd-ac74-1ecdbcc7db00
begin
	new_rand
	steps = rand(rng2,[1, -1], 300)
	
	#click_counter = @bind first_coins_counter ClickCounterWithReset("Toss!", "Start over!")
	
	md"""
	### Create new random variable"""
end

# ╔═╡ 5235f397-50df-4b02-9a6d-0c00a10c8e61
click_counter = @bind first_coins_counter ClickCounterWithReset("Toss!", "Start over!")

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

# ╔═╡ 69ee3ead-c1c8-4671-b9bd-b23fa56396d9
begin
keep_working(text=md"The answer is not quite right.", title="Keep working on it!") = Markdown.MD(Markdown.Admonition("danger", title, [text]));

almost(text, title="Almost there!") = Markdown.MD(Markdown.Admonition("warning", title, [text]));

hint(text, title ="Hint") = Markdown.MD(Markdown.Admonition("hint", title, [text]));
	
correct(text=md"Great! You got the right answer! Let's move on to the next section.", title="Got it!") = Markdown.MD(Markdown.Admonition("correct", title, [text]));
md" Definition of Boxes"
end

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
HypertextLiteral = "~0.9.5"
LaTeXStrings = "~1.3.1"
Plots = "~1.39.0"
PlutoUI = "~0.7.54"
StatsBase = "~0.34.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "7b8246fe6d31a5f299956fd530670996ebd5c3a1"

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

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "27442171f28c952804dede8ff72828a96f2bfc1f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "025d171a2847f616becc0f84c8dc62fe18f0f6dd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.10+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "9fb0b890adab1c0a4a475d4210d51f228bfc250d"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.6"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "f512dc13e64e96f703fd92ce617755ee6b5adf0f"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.8"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cc6e1927ac521b659af340e0ca45828a3ffc748f"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.12+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

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

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "242982d62ff0d1671e9029b52743062739255c7e"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.18.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "24b81b59bd35b3c42ab84fa589086e19be919916"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.11.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522b8414d40c4cbbab8dee346ac3a09f9768f25d"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.5+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "47cf33e62e138b920039e8ff9f9841aafe1b733e"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.35.1+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
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
# ╟─1f0bc289-d6ad-478f-b976-d6526966a68c
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
