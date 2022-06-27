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

# ╔═╡ 438caa30-66e8-11eb-31e9-917e458e4d33
#add packages
begin
	#try
using HypertextLiteral
using Plots
using Random
using StatsBase
using PlutoUI
using LinearAlgebra
using SparseArrays
using Markdown
using InteractiveUtils
#=
catch 
using Pkg
Pkg.activate(mktempdir())
Pkg.add("Plots")
Pkg.add("Random")
Pkg.add("StatsBase")
Pkg.add("PlutoUI")
Pkg.add("SparseArrays")
Pkg.add("Markdown")
Pkg.add("InteractiveUtils")
Pkg.add("LinearAlgebra")
Pkg.add("HypertextLiteral")
using Plots
using Random
using StatsBase
using PlutoUI
using LinearAlgebra
using SparseArrays
using HypertextLiteral
using Markdown
using InteractiveUtils
#plotly()
	end
	md"Packages"
=#
end

# ╔═╡ f36826be-93cd-11eb-3cd4-278a16171c91
	TableOfContents(aside = true)

# ╔═╡ 24d68cf0-7ed0-11eb-004b-7b2702a5de1a
md"
# Odyssey across the ocean ⛵	
"
# CC-BY-4.0 (IMOOX, TU Graz, Institute of Theoretical and Computational Physics)
# Authors: Johanna Moser, Gerhard Dorn, Wolfgang von der Linden

# ╔═╡ 89c46920-7ed0-11eb-3c5f-574d525a9f1f
md" Here again you can see our compass 🧭! Now you can change the probabilities by increasing the number next to the directions ⬅⬆➡⬇ and thus simulate wind or currents. Let's see how this might affect our journey!
"

# ╔═╡ 66966ea0-96d4-11eb-1c5c-2b06dfd9313b
begin
	hint(text, headline=md"Law of large numbers") = Markdown.MD(Markdown.Admonition("hint", string(headline), [text]));
	
	hint(md"You might have noticed that the more days our crew is sailing, the more similar the simulation is to the theoretical values. This is called the **law of large numbers**, and it tells us, that for an infinite number of days, the results of the experiment will perfectly coincide with the theoretical distribution.")
end

# ╔═╡ 2ea667f0-6f26-11eb-02fb-1335862dc98e
md" Where do you spot turtle island?

x coordinate = $(@bind x_island NumberField(0:6, default=5))

y coordinate = $(@bind y_island NumberField(0:6, default=0))"

# ╔═╡ 4ae39013-0e68-44a2-a124-402dc1f76557
md"**Question:** But before you manipulate the compass 🧭, what do you think, how do we have to change the compass probabilities to randomly reach turtle islans 🐢 (which lies 5 days in east direction) probably sooner?

👉 Increase the weight in East direction? $(@bind answer_1 CheckBox())

👉 Decrease the weights in North and South direction? $(@bind answer_2 CheckBox()) 

👉 Set West, North and South to zero? $(@bind answer_3 CheckBox()) 

👉 Increase West to the maximum? $(@bind answer_4 CheckBox()) 

"

# ╔═╡ 4e52d0f9-c2fd-4de4-b0c8-05a6b332c9bd
md"""Click here if you want to see the analytic solution using a Markov process 👉 $(@bind plot_exact CheckBox())"""

# ╔═╡ e4bbb3f0-e6f2-44a4-aa63-3bad12d14dc0
begin
	if plot_exact  == false
md" ## An exact solution for Turtle island!🐢 (hidden)"
	else md" ## An exact solution for Turtle island!🐢"
	end
end

# ╔═╡ ad8dfe0a-1184-4831-b33b-fcc42eb6e0c4
md"""Just click in the box to show Bernoulli 

the cummulative probability distribution of first return to turtle island🐢 👉$(@bind cummulative_probability CheckBox())

and the probability for the position after one year 👉$(@bind prob_dist_one_year CheckBox())"""

# ╔═╡ 59a47ad8-ed45-4765-a8e2-28cd49ae0ab2
md"## Program code"

# ╔═╡ b34109a1-5762-46ac-b95c-5c103b1552bc
function sub2ind(siz, ix,iy)
	
	return siz[1]*(iy-1) + ix
end


# ╔═╡ bdc92620-ab48-4587-a333-1578ce8a4e17
begin
	
	
	
	q_left = 0.25
	q_right = 0.25
	q_up = 0.25
	q_down = 0.25
local N = 100
diag_up = [repeat([ones(N-1)*q_up;0],(N-1));ones(N-1)*q_up]
diag_down = [repeat([ones(N-1)*q_down;0],(N-1));ones(N-1)*q_down]
	
local C = spdiagm( 1=>diag_up, -1=>diag_down, N=> ones(N^2-N)*q_right, -N => ones(N^2-N)*q_left)

	#index of turtle island:
d = CartesianIndex(N÷2 + 5, N÷2)
	
local turtle_island = sub2ind([N,N], (N+1)÷2 + 5, (N+1)÷2)
origin = sub2ind([N,N], (N+1)÷2 , (N+1)÷2)
	# make turtle island a stop position:
	C[turtle_island, :] .= 0
	C[turtle_island, turtle_island] = 1
	
	
	# lost probability weights could be sent to a special state but this is not necessary, the border / edge is given by 1-sum(pi)
	steps = 365
	time_prob = zeros(steps,1)
	out_of_simulation = zeros(steps,1)
	
	let
		pi_vec= zeros(1,N^2)
		pi_vec[origin] = 1

		
		
		
		local C10 = C^10
		for t = 1:steps
			pi_vec = pi_vec * C

			time_prob[t] = pi_vec[turtle_island]
			out_of_simulation[t] = 1-sum(pi_vec) 
		end
		global distri_markov = reshape(pi_vec, N,N)
	end
	
	
	#=end
	
	
	pdf = diff(time_prob,dims=1)
	md"theoretical values turtle island"
	
	=#
	
	md"Theoretical values turtle island Markov Chain"
	
end

# ╔═╡ 0838840f-c652-48ec-8a7c-5f01c6aaded5
if plot_exact == true
	pdf_return = diff(time_prob; dims=1)
	days_of_pos_return = [2:steps;]
	day_max_prob_return = days_of_pos_return[pdf_return[:] .== maximum(pdf_return)][1]
	max_prob_return = maximum(pdf_return)
	
	plot((2:1:steps) , pdf_return , line = (1.2, 0, :bar), xlim = [0,30], title="Reaching turtle island", xlabel="days", ylabel="probability of first arrival", label=:none)
	
		#plot!((1:1:steps) , out_of_simulation)
	end

# ╔═╡ 979bab1b-8463-4ca0-a506-d97ed2c29871
if cummulative_probability
	plot(1:steps, time_prob, line = (1, 1.0, :path), label=:none, xlabel="t | days", ylabel="probability of first arrival after t days", title="Cummulative probability")
	
	
end

# ╔═╡ d69ab95f-bd5c-4507-b24d-f12fbde4cae8
if prob_dist_one_year
heatmap(-49:50, -49:50, permutedims(distri_markov,[2,1]), clim= (0,0.0019), c = :dense, title="probability distribution after one year")
end

# ╔═╡ 264b06d9-6fea-4260-9b42-66feca66a654
begin
	# define images
bayes = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bayes_50px.gif"
	ernesto_short = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Ernesto_animated.gif"
	ernesto_completed = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Ernesto_completed.gif"
	bernoulli = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bernoulli_100px.gif"
	turtle_island = "https://github.com/Captain-Bayes/images/blob/main/island_in_sight.gif?raw=true"
	bottle = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Flaschenpost_schwimmend.gif"
	desparate_bernoulli = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Bernoulli_desperate.png"
	
	bayes_large = "https://raw.githubusercontent.com/Captain-Bayes/images/main/bayes_100px.gif"
	
	md"""Images"""
	
	
	#compass = Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_empty.png") 
end

# ╔═╡ 1aa40340-9382-11eb-1031-5fa5b0f133ee
begin
local	rng1 = MersenneTwister(32) #seperate rng so that it won't actualize again when you're further down
	dir_index = 5 .-sum(rand(rng1, 1, 8).<=cumsum([0.25, 0.25, 0.25, 0.25]), dims = 1)
local	K_start = [sum(dir_index[1:j] .== i) for i in 1:4, j in 1:8]
	pos_start = [0 0; K_start[1,:] - K_start[3,:] K_start[2,:] - K_start[4,:]]
	
	
	
	md" ## Welcome 
to this random journey! Each day we choose the sailing direction randomly. Hmm, let us try to use my famous random compass for this navigation! 


Can you help me with to dial? Click the button below, and see what happens! 
		
$(Resource(bayes, :width => 200))"
	#Can you help me with the dial process? Just switch to the next days by clicking the up button 🔼, and see what happens!
end

# ╔═╡ 9d9726dd-3456-4988-ae96-c25129092c39
md"""
That's cool! But how will we know where we'll (most likely) end up?

$(Resource(bernoulli, :width => 200))

Click here to find out! 👉 $(@bind see_distribution CheckBox())
"""

# ╔═╡ 702cce30-8047-11eb-015b-c5fb0509a38f
begin
	if see_distribution == false
	md" ## Probability distribution (hidden)"
	else
		md" ## Probability distribution"
	end
end

# ╔═╡ 299d527e-96e7-11eb-32c5-05fdf76bb79f
md"$(Resource(ernesto_completed, ))

Congrats on completing this section! You really deserve a pause! 🍍🍎🥕🥛🍵

When you're ready again, click here 👉 $(@bind see_turtle_island CheckBox())! 
"

# ╔═╡ 9579e880-8047-11eb-25cc-1710d87cbd23
begin
	if see_turtle_island  == false
md" ## Let's go to Turtle island!🐢 (hidden)"
	else md" ## Let's go to Turtle island!🐢"
	end
end


# ╔═╡ 11336f00-96e6-11eb-2434-8bac971b9849
md" $(Resource(turtle_island, :width => 700))

 **Bernoulli:** Look, there is a giant turtle over there! 


**Bayes:** This must be turtle island! I  hear they have the most delicious fresh lemonade there!


**Bernoulli:** Oh how wonderful, I really long for some fresh lemonade! Let's just go there!


**Bayes:** Wait ... we are currently  analyzing our journey with the random compass 🧭, and I don't want to stop this experiment early. And sooner or later we will reach the island for sure. Bernoulli, why don't you try to figure out how long it will take to reach that island 🐢🏝 on average?
Just perform **random walks** 🤪🌀 on your ship map and count how often we hit the island.
You could then produce a histogram showing us the statistical likelihood of reaching the island within a certain amount of time. The median of the arrival times of your simulated journeys should be an appropriate benchmark." #formulierung

# ╔═╡ f16d2de5-2473-432d-9b8e-c0482fa74031
md" $(Resource(desparate_bernoulli, :width=>100)) Oh that's sooo long 😰. But if the wind and the currents were different, we could get there a lot faster! Oh dear reader, will you tinker once again with the probabilities of our compass, so I can get my lemonade faster? Don't tell the Captain though!🤫
"


# ╔═╡ 5e7487fb-cab0-4bae-ae33-7537469d530e
md" $(Resource(bayes_large, :width=>180)) **Bernoulli, there must be a more accurate solution!**

A friend of mine - Markov - has some brilliant ideas - let's see if we can apply them.
The probabilities for the next day should depend on those of the previous. If we just multiply this vector with this transfer matrix... 
    
 >$\vec{P}^{(t+1)} = M \cdot \vec{P}^{(t)}$

Bernoulli, just have a look 😀

"

# ╔═╡ 454efd23-d99a-4d99-b348-1336dfe294a5
md"$(Resource(bernoulli, :width=>180)) Brilliant, so it seams the highest probability to reach turtle is on **the $(day_max_prob_return) day** with a **probability of $(round(max_prob_return; digits=4))**...

Puh, that's not much! Oh, I what may be the chances that I get there within a year?

Can you show me the cummulative probabilities and where we might be after one year?
"

# ╔═╡ 55e65cf6-7f5c-4faa-b271-cb78761300aa
begin
#define variables

first_steps_x = [0]
first_steps_y = [0]
	
	x0 = [0,0]

	
compass_dict = Dict("N"=> 1, "E" => 2, "S" => 3, "W" => 4)
	
	
	
compass = ["E", "N", "W", "S"] #possible directions
compass_numbers = [1, 2, 3, 4]
times_compass = [0, 0, 0, 0] #counts times every direction NESW is chosen
actual_directions = [[1, 0], [0, 1], [-1, 0],  [0, -1] ]

	md"variables"
end

# ╔═╡ e130ac04-e3eb-4be5-ae6c-c87eaf7064a5
begin
	days_max_first_journey = 200
	days_max = 200
	n_reps_max = 2000
	days_slider = @bind days Slider(1:1:days_max_first_journey, show_value = true, default = 100)
	days_slider_2 = @bind days_2 Slider(1:3:200, show_value = true, default = 100)
	seed_slider = @bind seed NumberField(1:100, default = 20)
	seed_slider_2 = @bind seed_2 NumberField(1:100, default = 20)
	
	md"define sliders"
end

# ╔═╡ 4d6c28d0-70a9-11eb-0a98-5583ef673517
md"Now you found an old log book 📘 of a previous random walk noted by Bernoulli. Just choose the number of 👉 **$(days_slider) days** to see the path of the odyssey of our crew on the ocean.

The darker a green circle 🟢 the more often it has been visited.
"


#@bind days_clock Clock(0.3, true) 

# ╔═╡ ce4ef0c2-81d1-11eb-05fe-e590b8cf2191
md" You can also examine another random walk/odyssey by taking another logbook 📕📗📙 out of the shelf in the captain's cabin. The seed  👉 $(seed_slider) is like the ID of the book"

# ╔═╡ a3a332d0-6d8d-11eb-2157-61140f731b59
md"""**Where do we end?** By repeating our odyssee again and again we can find a probability distribution about where the ship will end up after a certain number of days. The starting point will always be [0,0] and we'll mark the endpoint after each journey. See how the distribution changes depending on the number of **repetitions** 👉 $(@bind nr_reps Slider(100:100:n_reps_max, show_value = true, default = 100)) times, 

and the number of **days** 👉 $days_slider_2 days spent travelling!

Does it look similar to the spilled **ink stain** or rather a **chessboard pattern** ♟? 
Since on even and odd days we can just reach half of the possitions you can chosse the option to average two consecutive days 👉 $(@bind averaged_final CheckBox()).

You can also simulate wind or currents by changing the probabilities on the compass 🧭."""

# ╔═╡ 9d704724-4ddc-4ef2-a8f2-ce58af8f2339
md"""So if you wish you can change the seed 👉 $(seed_slider_2) and check what median arrival time ⏱ another random sample yields"""

# ╔═╡ ae845910-8109-11eb-39a8-0182f17e791e
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

# ╔═╡ 81cfef50-93d4-11eb-3448-975c908bd1a2
begin
if see_distribution == false
		hide_everything_below
	end
end

# ╔═╡ e527cc7e-96e5-11eb-029c-277bfb1730dc
begin
if see_turtle_island == false
	hide_everything_below
	end
end

# ╔═╡ 0446b6c1-1a7b-4ac0-b50e-6bc7e3b60c72
begin
if plot_exact == false
		hide_everything_below
	end
end

# ╔═╡ 49b1e2ad-2129-4562-911f-a81976a6bd55
html"""
	<style>
	.compasstable td {
		font-size: 30px;
		text-align: center;
	}
	
	</style>
"""

# ╔═╡ 69d1a4d0-96c6-11eb-002f-9138e617a1c2
begin
	#see_distribution 
	# used to reset the compass to make it fair again, when entering the next section
	
	W1 = @bind West Scrubbable(0:1:3, default=1)
	N1 = @bind North Scrubbable(0:1:3, default=1)
	E1 = @bind East Scrubbable(0:1:3, default=1)
	S1 = @bind South Scrubbable(0:1:3, default=1)
	
	md"direction sliders"
end

# ╔═╡ 8510bdd0-96c6-11eb-3a9a-bd311edac8f4
begin
#=md"""
$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_empty.png", :width => 200))


North: $(N1)
	
West: $(W1)
 East: $(E1)
	
South: $(S1)

	"""
	=#
	
	@htl("""
<table class="compasstable">
	
    <tbody>
        <tr>
            <td></td>
            <td style="text-align:center">	$(N1)</td>
            <td></td>
        </tr>
        <tr>
            <td>$(W1)</td>
            <td><img src="https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_empty.png" width=200></td>
            <td>$(E1)</td>
        </tr>
        <tr>
            <td></td>
            <td style="text-align:center">	$(S1)</td>
            <td></td>
        </tr>
    </tbody>
</table>
""")
end

# ╔═╡ 76380dec-000c-43d6-957f-4fb156846ff9
begin
#=md"""
$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_empty.png", :width => 200))


North: $(N1)
	
West: $(W1)
 East: $(E1)
	
South: $(S1)

	"""
=#	
	
	@htl("""
<table class="compasstable">
	
    <tbody>
        <tr>
            <td></td>
            <td style="text-align:center">	$(N1)</td>
            <td></td>
        </tr>
        <tr>
            <td>$(W1)</td>
            <td><img src="https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_empty.png" width=200></td>
            <td>$(E1)</td>
        </tr>
        <tr>
            <td></td>
            <td style="text-align:center">	$(S1)</td>
            <td></td>
        </tr>
    </tbody>
</table>
""")
end

# ╔═╡ 254669e2-764f-4b77-a7eb-37dea55bed2f
begin #calculate changes to probability:
direct = [East, North, West, South]
weights = direct./sum(direct)
end

# ╔═╡ 815094e0-93ce-11eb-3878-3be919148949
begin
	angles = [0.0, pi/2, pi, 3*pi/2, 0.0]
	plot(angles, [weights;weights[1]], proj=:polar, m=2, label = "weights")
	#warum so wahnsinnig langsam?
end

# ╔═╡ c3a505f0-66e8-11eb-3540-69ce34959d64
begin
	

	
#probabilities for the four directions
prob = weights[1:4]
# create all random variables using the seed defined above
rng = MersenneTwister(seed_2)

local sample_temp = 5 .- sum(rand(rng, 1,days_max*n_reps_max) .<= cumsum(prob), dims=1)
local sample_array = reshape(sample_temp, (days_max,:))
	
# first calculation: positions of first run -> moved to first section!
# K_first_run = [sum(sample_array[1:i,1] .== j) for j ∈ 1:4, i ∈ 1:days_max]
#pos_first_run = [0 0; K_first_run[1,:] - K_first_run[3,:]  K_first_run[2,:] - K_first_run[4,:]]

# second calculation: final positions
local K = [sum(sample_array[1:days_2,i] .== j ) for j ∈ 1:4, i ∈ 1:n_reps_max]
final_pos = [K[1,:] - K[3,:]  K[2,:] - K[4,:]]

local K2 = [sum(sample_array[1:days_2-1,i] .== j ) for j ∈ 1:4, i ∈ 1:n_reps_max]
final_pos_2 = [K2[1,:] - K2[3,:]  K2[2,:] - K2[4,:]]
	
	
	
# third calculation: return to turtle island

#flip days_max and repetitions, we only take 1000 repetitions but let the walker go 10000 days (overflow)
overfl = n_reps_max

# since approx 50% of the walker return before 10000 days we will get 2*days_max repetitions
max_runs = Integer(days_max*1.5)


local x_logic = (sample_temp.==1) - (sample_temp.==3)
local y_logic = (sample_temp.==2) - (sample_temp.==4)
	
# those vectors	will be used to display histogram
reached = zeros(max_runs)
not_reached = zeros(max_runs)
let
	ind = 0
	step = 1
	for k= 1:max_runs
		
L_reach_island = findall((cumsum(x_logic[ind .+ step .* (1:overfl)]) .== x_island) .& (cumsum(y_logic[ind .+ step .* (1:overfl)]) .== y_island))
		if isempty(L_reach_island) # not reached (overflow)
			not_reached[k] = 1
			ind = ind + overfl
		else 			# reached
			reached[k] =  minimum(L_reach_island)
			ind = Integer(ind + reached[k])
		end
		# if more than 50% of walkers for some random seed do not come back we set index to zero and take only every second value to generate a new sample set (backup to prevent error)
		if ind + overfl > length(sample_temp)
			ind = 0
			step = 2
		end
		
		
	end
end
	
	days_histogram = reached
	days_histogram[reached .== 0] .= overfl
	
	md" probability distribution and turtle island walker"
end

# ╔═╡ 8aeb5aa0-93d1-11eb-1935-9b20967fb2e3
begin 
	rng2 = MersenneTwister(seed)

local sample_array = 5 .- sum(rand(rng2, 1,days_max) .<= cumsum(prob), dims=1)
	
# first calculation: positions of first run:
 K_first_run = [sum(sample_array[1:i] .== j) for j ∈ 1:4, i ∈ 1:days_max]
pos_first_run = [0 0; K_first_run[1,:] - K_first_run[3,:]  K_first_run[2,:] - K_first_run[4,:]]
	
	
	
	
	md""" Now let's compare the directions chosen by our compass with the theoretical distribution we chose. What do you notice?"""

#how to blend in law of large numbers
end

# ╔═╡ 5b711a00-6d8c-11eb-00ac-4dd20bc3dcc6
begin
	max_x_1_run = maximum(abs.(pos_first_run[1:days,1]))
	max_y_1_run = maximum(abs.(pos_first_run[1:days,2]))
	plot(
			[pos_first_run[1:days,1]], [pos_first_run[1:days,2]], linecolor   = :green,
			linealpha = 0.2,
			linewidth = 2, aspect_ratio =:equal,
			marker = (:dot , 5, 0.2, :green),
			label=false,
			xlim = [-max_x_1_run, max_x_1_run],
			ylim = [-maximum([max_x_1_run*0.6, max_y_1_run]), maximum([max_x_1_run*0.6, max_y_1_run])]
			)
	plot!(
			[x0[1]],[x0[2]],
			marker = (:dot, 10, 1.0, :red),
			label = "initial position"
			)

	plot!(
			[pos_first_run[days,1]], [pos_first_run[days,2]],
			marker = (:circle, 10, 1.0, :green),
			label = "current position"
			)
end

# ╔═╡ 29523c50-7554-11eb-25c1-1b56caf928c5
begin
	color_green = [76,173,133]/255
	compass_green = RGB(color_green[1], color_green[2], color_green[3])
	color_red = [172,50,50]/255
	compass_red = RGB(color_red[1], color_red[2], color_red[3])
	color_yellow = [242,233,52]/255
	compass_yellow = RGB(color_yellow[1], color_yellow[2], color_yellow[3])
	color_blue = [48,96,130]/255
	compass_blue = RGB(color_blue[1], color_blue[2], color_blue[3])
plot(compass, K_first_run[:,days]/days,
		line = (1., 1., :bar), label = "simulation", title = "cardinal directions chosen")
plot!([compass], [weights], line = (1.0, 0.0, :bar), bar_width = 0.03, color = :red, label = "theory", legend = :right)
	
plot!(compass, weights,
		line = (0., 0.0, :path),
    normalize = false,
    bins = 10,
	bar_width = 0.2,
    marker = (7, 1., :o),
    markerstrokewidth = 1,
    color = [compass_yellow, compass_red, compass_blue, compass_green],
    fill = 1.,
    orientation = :v,
	ylabel = "Relative frequency",
	xlabel = "Directions",
	label = :none)
end

# ╔═╡ 9600df90-7f46-11eb-2d6f-953d8166854e
begin
	
	
	
	
	
	#shifts the position [0,0] to the middle of a matrix hist_data
	max_distance_1 = maximum(abs.([final_pos[1:nr_reps,1]; final_pos[1:nr_reps,2]]))	
	max_distance_2 = maximum(abs.([final_pos_2[1:nr_reps,1]; final_pos_2[1:nr_reps,2]]))
	max_distance = maximum([max_distance_1, max_distance_2])
	# initialize with a sparse matrix, plot with a full matrix - Array command
	hist_data = sparse(final_pos[1:nr_reps,2].+max_distance.+1, final_pos[1:nr_reps,1].+max_distance.+1, 	 	 ones(size(final_pos[1:nr_reps],1)), 2*max_distance + 1, 2*max_distance + 1)
	

	
	hist_data_2 = sparse(final_pos_2[1:nr_reps,2].+max_distance.+1, final_pos_2[1:nr_reps,1].+max_distance.+1, 	 	 ones(size(final_pos_2[1:nr_reps],1)), 2*max_distance + 1, 2*max_distance + 1)
	
	if averaged_final
	heatmap(-max_distance:1:max_distance, -max_distance:1:max_distance, Array(hist_data + hist_data_2)./2, seriestype = :bar, c=:dense) 
	else
	heatmap(-max_distance:1:max_distance, -max_distance:1:max_distance, Array(hist_data), seriestype = :bar, c=:dense) 
	end
	
	L_phi  = [0:.01:2*pi;]
	radius = sqrt(days_2) * sqrt(pi)/2
	Lc_x    = radius * cos.(L_phi) .+ days_2*(weights[2] - weights[4])
	Lc_y    = radius * sin.(L_phi) .+ days_2*(weights[1] - weights[3])
	plot!(Lc_x,Lc_y, linewidth = 2, label = "measure for mean distance")
#here are different color schemes: https://docs.juliaplots.org/latest/generated/colorschemes/
	
	#heatmap(x_array, y_array, final_position, seriestype = :bar) 
	#plot!([0],[0], marker = (:dot, 10, 1.0, :red))
end

# ╔═╡ d4a2ab30-7f4a-11eb-0a76-d50b21c3217b
begin
	median_island = StatsBase.median(days_histogram)

	plot1 = histogram(days_histogram, bins = 100, label = :none, xlabel = "days", ylabel = "occurrences")
	
	
	plot!([StatsBase.median(days_histogram)],[0], marker = "red", label = string("Median =",StatsBase.median(days_histogram)), legend=:top)
# calculate median manually:
	hist_return = [sum(days_histogram .== i) for i in 1:overfl]
	
	#med = minimum(findall(cumsum(hist_return./max_runs) .>= 0.5))
	
	#einfügen: theoretische kurve?
	
	
	
	plot1
end

# ╔═╡ 6cbe3250-805d-11eb-0f34-43f4c1669537
md"$(Resource(bernoulli, :width=>180)) The simulation is finished, Captain! Here's the histogram. Taking the median as a measure of average, it looks like we'll arrive in about $(median_island) days...

"

# ╔═╡ 10b945c9-4946-49bf-9e16-62b27b3766d7
md"""If you are still not happy with the expected time to reach turtle island, you could say our simulation was just bad luck, we only use **$(max_runs) runs** and **$(overfl) days** for each run to get the average return statistic, so maybe the true value is different 🤔."""

# ╔═╡ 073ac878-52dd-4112-9b42-ad08649fe927
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

# ╔═╡ 4c428e38-cf2f-430e-a44e-6c1d2ffa6f13
click_count = @bind dial ClickCounterWithReset("Dial!", "Start over!")

# ╔═╡ c6f9c954-54c4-48ce-8465-fc85202b79f4
begin
	
	#md"""Switch to the next 8 days 📅 by clicking the up 🔼 button: 👉 $(@bind dial NumberField(0:8; default=0))"""
	md"""$(click_count)"""
end

# ╔═╡ 38fd06d0-93cc-11eb-030e-a7888d7d7eee
begin
#dial first steps

dial_index = minimum([8,Integer(round(dial,digits=0))])
local dir = ["E", "N", "W",  "S"]
local word = [ "east", "north", "west" ,"south"]
local url = ["https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_east-export.gif", "https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_north-export.gif",  "https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_west-export.gif",  "https://raw.githubusercontent.com/Captain-Bayes/images/main/Kompass_south-export.gif"]

		
if dial_index < 8	&& dial_index > 0
	md"Well done! The compass needle landed on **$(dir[dir_index[dial_index]])**. Seems like we'll be heading **$(word[dir_index[dial_index]])wards** today! $(Resource(url[dir_index[dial_index]], :width => 200))"
elseif dial_index >= 8
		md"""
		$(Resource(ernesto_short, :width => 30))
		
		**Thank you for helping Captain Bayes dial the compass! From now on, she can handle it on her own. Scroll down further to see the whole journey of our crew. You can also change the seed to see different possible journeys!** """
	end
		
end

# ╔═╡ 5d25f3a0-93a4-11eb-3da6-c96ae54a0d70
begin
	
	if dial_index > 0 
		
	lim_start = maximum(abs.(pos_start[:]))
	plot(
			pos_start[1:dial_index+1,1], pos_start[1:dial_index+1,2], 
			linecolor   = :green,
			linealpha = 0.2,
			linewidth = 2, aspect_ratio =:equal,
			marker = (:dot , 5, 0.2, :green),
			label=false,
			xlim =[-lim_start, lim_start],
		    ylim =[-lim_start, lim_start],
			legend = :bottom
			)
	plot!(
			[0],[0],
			marker = (:dot, 10, 1.0, :red),
			label = "initial position"
			)

	plot!(
			[pos_start[dial_index+1,1]], [pos_start[dial_index+1,2]],
			marker = (:circle, 10, 1.0, :green),
			label = "current position"
			)
	
	end
end

# ╔═╡ 4f304620-93cb-11eb-1da6-739664f2a105
begin
	if dial_index < 8
			hide_everything_below
	end
end

# ╔═╡ 5cea77d0-93d1-11eb-1508-aff9495e46d8
begin

if dial_index < 8
md"""
## One journey (hidden)"""
	else
		md"""
## One journey"""
end
end

# ╔═╡ 8e804243-9123-497d-a4b2-552f04c1d9d5
begin
almost(text, headline=md"Almost there!") = Markdown.MD(Markdown.Admonition("warning", string(headline), [text]));
#brown
	
correct(text=md"Great! You got the right answer!", headline=md"Got it!") = Markdown.MD(Markdown.Admonition("correct", string(headline), [text]));
#green
	
	
keep_working(text=md"The answer is not quite right.", headline=md"Keep working on it!") = Markdown.MD(Markdown.Admonition("danger", string(headline), [text]));
#red
md"admonitions"
end

# ╔═╡ 473d0dab-ca56-4ce7-8f0e-7a8436ea5833
begin
	if answer_1
		keep_working(md"""Rethink your answer or try it out, you will see that the "ink stain" moves far to the right ➡ missing turtle island!""", md"Not really!")
	elseif answer_2
		correct( md"You surly realized that setting North and South to zero will lead to a one dimensional random walk which will highly increase the probability to reach turtle island soon 🐢", md"""Clever!""")
	elseif answer_3
		almost(md"Well, you can try it but Captain Bayes will find out, you killed all randomness. Your manipulation will directly steer the ship onto turtle island, so you definitly will reach it in 5 days, but that's no random walk anymore!.", "This is kind of cheating")
	elseif answer_4
		keep_working(md"Maybe you are like Magellan and hope to circumnavigate the globe to tackle turtle island from a direction it would not expect^^. Well played, but this definitly takes tooo long. And be careful in a pure Eucledian space setting East to zero would destroy your dream from ever drinking lemonade on turtle island beach.", md"Wrong direction!")
	end
	#almost, correct, keep_working
	
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
HypertextLiteral = "~0.9.3"
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
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

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
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

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
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

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
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
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
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

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
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
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

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

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
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

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
# ╟─f36826be-93cd-11eb-3cd4-278a16171c91
# ╟─24d68cf0-7ed0-11eb-004b-7b2702a5de1a
# ╟─1aa40340-9382-11eb-1031-5fa5b0f133ee
# ╟─c6f9c954-54c4-48ce-8465-fc85202b79f4
# ╟─38fd06d0-93cc-11eb-030e-a7888d7d7eee
# ╟─5d25f3a0-93a4-11eb-3da6-c96ae54a0d70
# ╟─4f304620-93cb-11eb-1da6-739664f2a105
# ╟─5cea77d0-93d1-11eb-1508-aff9495e46d8
# ╟─4d6c28d0-70a9-11eb-0a98-5583ef673517
# ╟─ce4ef0c2-81d1-11eb-05fe-e590b8cf2191
# ╟─5b711a00-6d8c-11eb-00ac-4dd20bc3dcc6
# ╟─89c46920-7ed0-11eb-3c5f-574d525a9f1f
# ╟─8510bdd0-96c6-11eb-3a9a-bd311edac8f4
# ╟─815094e0-93ce-11eb-3878-3be919148949
# ╟─8aeb5aa0-93d1-11eb-1935-9b20967fb2e3
# ╟─29523c50-7554-11eb-25c1-1b56caf928c5
# ╟─66966ea0-96d4-11eb-1c5c-2b06dfd9313b
# ╟─9d9726dd-3456-4988-ae96-c25129092c39
# ╟─81cfef50-93d4-11eb-3448-975c908bd1a2
# ╟─702cce30-8047-11eb-015b-c5fb0509a38f
# ╟─a3a332d0-6d8d-11eb-2157-61140f731b59
# ╟─9600df90-7f46-11eb-2d6f-953d8166854e
# ╟─299d527e-96e7-11eb-32c5-05fdf76bb79f
# ╟─e527cc7e-96e5-11eb-029c-277bfb1730dc
# ╟─9579e880-8047-11eb-25cc-1710d87cbd23
# ╟─11336f00-96e6-11eb-2434-8bac971b9849
# ╟─2ea667f0-6f26-11eb-02fb-1335862dc98e
# ╟─6cbe3250-805d-11eb-0f34-43f4c1669537
# ╟─d4a2ab30-7f4a-11eb-0a76-d50b21c3217b
# ╟─f16d2de5-2473-432d-9b8e-c0482fa74031
# ╟─4ae39013-0e68-44a2-a124-402dc1f76557
# ╟─473d0dab-ca56-4ce7-8f0e-7a8436ea5833
# ╟─76380dec-000c-43d6-957f-4fb156846ff9
# ╟─10b945c9-4946-49bf-9e16-62b27b3766d7
# ╟─9d704724-4ddc-4ef2-a8f2-ce58af8f2339
# ╟─5e7487fb-cab0-4bae-ae33-7537469d530e
# ╟─4e52d0f9-c2fd-4de4-b0c8-05a6b332c9bd
# ╟─0446b6c1-1a7b-4ac0-b50e-6bc7e3b60c72
# ╟─e4bbb3f0-e6f2-44a4-aa63-3bad12d14dc0
# ╟─0838840f-c652-48ec-8a7c-5f01c6aaded5
# ╟─454efd23-d99a-4d99-b348-1336dfe294a5
# ╟─ad8dfe0a-1184-4831-b33b-fcc42eb6e0c4
# ╟─979bab1b-8463-4ca0-a506-d97ed2c29871
# ╟─d69ab95f-bd5c-4507-b24d-f12fbde4cae8
# ╟─59a47ad8-ed45-4765-a8e2-28cd49ae0ab2
# ╟─b34109a1-5762-46ac-b95c-5c103b1552bc
# ╟─bdc92620-ab48-4587-a333-1578ce8a4e17
# ╟─264b06d9-6fea-4260-9b42-66feca66a654
# ╟─55e65cf6-7f5c-4faa-b271-cb78761300aa
# ╟─254669e2-764f-4b77-a7eb-37dea55bed2f
# ╟─e130ac04-e3eb-4be5-ae6c-c87eaf7064a5
# ╟─c3a505f0-66e8-11eb-3540-69ce34959d64
# ╠═438caa30-66e8-11eb-31e9-917e458e4d33
# ╟─ae845910-8109-11eb-39a8-0182f17e791e
# ╟─49b1e2ad-2129-4562-911f-a81976a6bd55
# ╟─69d1a4d0-96c6-11eb-002f-9138e617a1c2
# ╟─073ac878-52dd-4112-9b42-ad08649fe927
# ╠═4c428e38-cf2f-430e-a44e-6c1d2ffa6f13
# ╟─8e804243-9123-497d-a4b2-552f04c1d9d5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
