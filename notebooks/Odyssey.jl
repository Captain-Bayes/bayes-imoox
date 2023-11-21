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

# ╔═╡ f36826be-93cd-11eb-3cd4-278a16171c91
	TableOfContents(aside = true)

# ╔═╡ 24d68cf0-7ed0-11eb-004b-7b2702a5de1a
md"
# Odyssey across the ocean ⛵	
"
# CC-BY-4.0 (IMOOX, TU Graz, Institute of Theoretical and Computational Physics)
# Authors: Johanna Moser, Gerhard Dorn, Wolfgang von der Linden

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

# ╔═╡ 4d6c28d0-70a9-11eb-0a98-5583ef673517
md"Now you found an old log book 📘 of a previous random walk noted by Bernoulli. Just choose the number of 👉 **$(days_slider) days** to see the path of the odyssey of our crew on the ocean.

The darker a green circle 🟢 the more often it has been visited.
"


#@bind days_clock Clock(0.3, true) 

# ╔═╡ ce4ef0c2-81d1-11eb-05fe-e590b8cf2191
md" You can also examine another random walk/odyssey by taking another logbook 📕📗📙 out of the shelf in the captain's cabin. The seed  👉 $(seed_slider) is like the ID of the book"

# ╔═╡ 5b711a00-6d8c-11eb-00ac-4dd20bc3dcc6
begin
	max_x_1_run = maximum(abs.(pos_first_run[1:days,1]))
	max_y_1_run = maximum(abs.(pos_first_run[1:days,2]))
	plot(
			[pos_first_run[1:days,1]], [pos_first_run[1:days,2]], linecolor   = :green,
			linealpha = 0.2,
			linewidth = 2, aspect_ratio =:equal,
			marker = :dot ,
			markersize = 5, 
			markeralpha = 0.2,
			markercolor = :green,
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

# ╔═╡ 89c46920-7ed0-11eb-3c5f-574d525a9f1f
md" Here again you can see our compass 🧭! Now you can change the probabilities by increasing the number next to the directions ⬅⬆➡⬇ and thus simulate wind or currents. Let's see how this might affect our journey!
"

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

# ╔═╡ 815094e0-93ce-11eb-3878-3be919148949
begin
	angles = [0.0, pi/2, pi, 3*pi/2, 0.0]
	plot(angles, [weights;weights[1]], proj=:polar, m=2, label = "weights")
	#warum so wahnsinnig langsam?
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

# ╔═╡ 66966ea0-96d4-11eb-1c5c-2b06dfd9313b
begin
	hint(text, headline=md"Law of large numbers") = Markdown.MD(Markdown.Admonition("hint", string(headline), [text]));
	
	hint(md"You might have noticed that the more days our crew is sailing, the more similar the simulation is to the theoretical values. This is called the **law of large numbers**, and it tells us, that for an infinite number of days, the results of the experiment will perfectly coincide with the theoretical distribution.")
end

# ╔═╡ 9d9726dd-3456-4988-ae96-c25129092c39
md"""
That's cool! But how will we know where we'll (most likely) end up?

$(Resource(bernoulli, :width => 200))

Click here to find out! 👉 $(@bind see_distribution CheckBox())
"""

# ╔═╡ 81cfef50-93d4-11eb-3448-975c908bd1a2
begin
if see_distribution == false
		hide_everything_below
	end
end

# ╔═╡ 702cce30-8047-11eb-015b-c5fb0509a38f
begin
	if see_distribution == false
	md" ## Probability distribution (hidden)"
	else
		md" ## Probability distribution"
	end
end

# ╔═╡ a3a332d0-6d8d-11eb-2157-61140f731b59
md"""**Where do we end?** By repeating our odyssee again and again we can find a probability distribution about where the ship will end up after a certain number of days. The starting point will always be [0,0] and we'll mark the endpoint after each journey. See how the distribution changes depending on the number of **repetitions** 👉 $(@bind nr_reps Slider(100:100:n_reps_max, show_value = true, default = 100)) times, 

and the number of **days** 👉 $days_slider_2 days spent travelling!

Does it look similar to the spilled **ink stain** or rather a **chessboard pattern** ♟? 
Since on even and odd days we can just reach half of the possitions you can chosse the option to average two consecutive days 👉 $(@bind averaged_final CheckBox()).

You can also simulate wind or currents by changing the probabilities on the compass 🧭."""

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

# ╔═╡ 299d527e-96e7-11eb-32c5-05fdf76bb79f
md"$(Resource(ernesto_completed, ))

Congrats on completing this section! You really deserve a pause! 🍍🍎🥕🥛🍵

When you're ready again, click here 👉 $(@bind see_turtle_island CheckBox())! 
"

# ╔═╡ e527cc7e-96e5-11eb-029c-277bfb1730dc
begin
if see_turtle_island == false
	hide_everything_below
	end
end

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

# ╔═╡ 2ea667f0-6f26-11eb-02fb-1335862dc98e
md" Where do you spot turtle island?

x coordinate = $(@bind x_island NumberField(0:6, default=5))

y coordinate = $(@bind y_island NumberField(0:6, default=0))"

# ╔═╡ 6cbe3250-805d-11eb-0f34-43f4c1669537
md"$(Resource(bernoulli, :width=>180)) The simulation is finished, Captain! Here's the histogram. Taking the median as a measure of average, it looks like we'll arrive in about $(median_island) days...

"

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

# ╔═╡ f16d2de5-2473-432d-9b8e-c0482fa74031
md" $(Resource(desparate_bernoulli, :width=>100)) Oh that's sooo long 😰. But if the wind and the currents were different, we could get there a lot faster! Oh dear reader, will you tinker once again with the probabilities of our compass, so I can get my lemonade faster? Don't tell the Captain though!🤫
"


# ╔═╡ 4ae39013-0e68-44a2-a124-402dc1f76557
md"**Question:** But before you manipulate the compass 🧭, what do you think, how do we have to change the compass probabilities to randomly reach turtle islans 🐢 (which lies 5 days in east direction) probably sooner?

👉 Increase the weight in East direction? $(@bind answer_1 CheckBox())

👉 Decrease the weights in North and South direction? $(@bind answer_2 CheckBox()) 

👉 Set West, North and South to zero? $(@bind answer_3 CheckBox()) 

👉 Increase West to the maximum? $(@bind answer_4 CheckBox()) 

"

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

# ╔═╡ 10b945c9-4946-49bf-9e16-62b27b3766d7
md"""If you are still not happy with the expected time to reach turtle island, you could say our simulation was just bad luck, we only use **$(max_runs) runs** and **$(overfl) days** for each run to get the average return statistic, so maybe the true value is different 🤔."""

# ╔═╡ 9d704724-4ddc-4ef2-a8f2-ce58af8f2339
md"""So if you wish you can change the seed 👉 $(seed_slider_2) and check what median arrival time ⏱ another random sample yields"""

# ╔═╡ 5e7487fb-cab0-4bae-ae33-7537469d530e
md" $(Resource(bayes_large, :width=>180)) **Bernoulli, there must be a more accurate solution!**

A friend of mine - Markov - has some brilliant ideas - let's see if we can apply them.
The probabilities for the next day should depend on those of the previous. If we just multiply this vector with this transfer matrix... 
    
 >$\vec{P}^{(t+1)} = M \cdot \vec{P}^{(t)}$

Bernoulli, just have a look 😀

"

# ╔═╡ 4e52d0f9-c2fd-4de4-b0c8-05a6b332c9bd
md"""Click here if you want to see the analytic solution using a Markov process 👉 $(@bind plot_exact CheckBox())"""

# ╔═╡ 0446b6c1-1a7b-4ac0-b50e-6bc7e3b60c72
begin
if plot_exact == false
		hide_everything_below
	end
end

# ╔═╡ e4bbb3f0-e6f2-44a4-aa63-3bad12d14dc0
begin
	if plot_exact  == false
md" ## An exact solution for Turtle island!🐢 (hidden)"
	else md" ## An exact solution for Turtle island!🐢"
	end
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

# ╔═╡ 454efd23-d99a-4d99-b348-1336dfe294a5
md"$(Resource(bernoulli, :width=>180)) Brilliant, so it seams the highest probability to reach turtle is on **the $(day_max_prob_return) day** with a **probability of $(round(max_prob_return; digits=4))**...

Puh, that's not much! Oh, I what may be the chances that I get there within a year?

Can you show me the cummulative probabilities and where we might be after one year?
"

# ╔═╡ ad8dfe0a-1184-4831-b33b-fcc42eb6e0c4
md"""Just click in the box to show Bernoulli 

the cummulative probability distribution of first return to turtle island🐢 👉$(@bind cummulative_probability CheckBox())

and the probability for the position after one year 👉$(@bind prob_dist_one_year CheckBox())"""

# ╔═╡ 979bab1b-8463-4ca0-a506-d97ed2c29871
if cummulative_probability
	plot(1:steps, time_prob, line = (1, 1.0, :path), label=:none, xlabel="t | days", ylabel="probability of first arrival after t days", title="Cummulative probability")
	
	
end

# ╔═╡ d69ab95f-bd5c-4507-b24d-f12fbde4cae8
if prob_dist_one_year
heatmap(-49:50, -49:50, permutedims(distri_markov,[2,1]), clim= (0,0.0019), c = :dense, title="probability distribution after one year")
end

# ╔═╡ 65aa74e7-c4ff-49fe-a478-2f296c7b0088
md"""
# About the creators

This notebook was created by **[Gerhard Dorn](https://github.com/dorn-gerhard)** in the context of the course **Bayesian probability theory**.

The course is a free massive open online course (MOOC) available on the platform [`IMOOX`](https://imoox.at/mooc/local/landingpage/course.php?shortname=bayes22&lang=en)

$(Resource("https://raw.githubusercontent.com/Captain-Bayes/images/main/adventure_map.gif"))
"""

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

# ╔═╡ 1037cc23-e6ad-42ed-ba8b-93d7cfcc8df3
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

# ╔═╡ 254669e2-764f-4b77-a7eb-37dea55bed2f
begin #calculate changes to probability:
direct = [East, North, West, South]
weights = direct./sum(direct)
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
HypertextLiteral = "~0.9.5"
Plots = "~1.38.9"
PlutoUI = "~0.7.50"
StatsBase = "~0.34.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "c45f78bd6e372ba69d98f1b727bd7349cd6f4507"

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
git-tree-sha1 = "9f8675a55b37a70aa23177ec110f6e3f4dd68466"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.17"

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
# ╟─65aa74e7-c4ff-49fe-a478-2f296c7b0088
# ╟─59a47ad8-ed45-4765-a8e2-28cd49ae0ab2
# ╟─b34109a1-5762-46ac-b95c-5c103b1552bc
# ╟─bdc92620-ab48-4587-a333-1578ce8a4e17
# ╟─1037cc23-e6ad-42ed-ba8b-93d7cfcc8df3
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
# ╟─4c428e38-cf2f-430e-a44e-6c1d2ffa6f13
# ╟─8e804243-9123-497d-a4b2-552f04c1d9d5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
