### A Pluto.jl notebook ###
# v0.14.7

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

# ╔═╡ 39b06b5b-c218-4aae-88d1-0e641d7303a8
begin
	try
		using PlutoUI
		using Plots
		using Plots.PlotMeasures
		using LaTeXStrings
		using Markdown
		using Images
		using Plots.PlotMeasures
		#using Polynomials
		
		#using LinearAlgebra
		#using SparseArrays
		#using SpecialFunctions
		#using StatsBase
		#using Random
		#using Distributions
		md""" 
		### Packages
		
		All needed Packages available :) """
	catch
		using Pkg;
		Pkg.activate(mktempdir())
		Pkg.add("PlutoUI")
		Pkg.add("Plots")
		Pkg.add("LaTeXStrings")
		Pkg.add("Markdown")
		Pkg.add("Images")
		#Pkg.add("LinearAlgebra")
		#Pkg.add("SparseArrays")
		#Pkg.add("SpecialFunctions")
		#Pkg.add("StatsBase")
		#Pkg.add("Distributions")
		using PlutoUI, Plots, LaTeXStrings, Markdown, Images, Plots.PlotMeasures
		#using LinearAlgebra
		#using SparseArrays
		#using StatsBase
		#using Random
		md""" 
		### Packages
		
		Some Package sources not added, this will take approx. 3 minutes"""
	end
	
end

# ╔═╡ 9d959eb7-6b01-41fc-a8c1-62ce5c42e2dd
md"""
## Where to draw the line? or a curve?

We will now use the techniques learned in lesson 7 to find a solution to this problem and solve this classification problem.

So given are the data points of fish observations $(latexstring("(x_\\nu|y_\\nu)")) Bernoulli collected with the classifier $(latexstring("C_\\nu \\in [-1,1]")) to identify whether he spotted a frogfish (1) or a normal fish (-1).

To see all data points click here 👉 $(@bind show_data CheckBox()) (show data)

Our aim will be not only to find **a** solution but the probability density for all kinds of possible solutions.

But let's do this step by step. Here are the steps we will perform:

- **Define a model function** $(latexstring("f(x,y) = 0")) that will define a possible boundary. When inserting coordinates of a fish spot that do not lie on the boundary the function will either be positive or negative marking the side on which the fish spot is located. We will use that in order to "count" the correct and wrong fish counts.

We will use a linear model of the following form $(latexstring("f(x,y) = 1+ a_1 \\cdot x + a_2 \\cdot y = 0")) and rewrite it in a matrix form $(latexstring("M(\\boldsymbol x, \\boldsymbol{y}) = [1 \\quad\\boldsymbol{x} \\quad\\boldsymbol{y}]")) with the parameter vector $(latexstring("\\vec a = \\begin{pmatrix} 1 \\\\ a_1 \\\\ a_2 \\end{pmatrix}")). So the model function can be evaluated by the matrix multiplication 
$(latexstring("f(x,y) = M(x,y) \\cdot \\vec{a}"))

$(latexstring(" f(1,2) = [1 \\quad 1 \\quad 2] \\cdot \\begin{pmatrix} 1 \\\\ a_1 \\\\ a_2 \\end{pmatrix} = 1 + a_1 + 2\\cdot a_2"))


- **Define a Likelihood function** that evaluates the probability for a given parameter set to reproduce Bernoulli's data. The Likelihood function will be such, that if a fish species is on the right side of the boundary it will be assigned a high constant probability and a low one if it is on the wrong side. This is because the data given is such, that the sets are not completly separable in a linear way. No matter how we draw a line, there will always be fish on the wrong side. We allow for these "outliers"

To do so we will use the so-called **logistic function** that basically turns a positive value into a one and a negative value into a zero and add a hinge constant $(latexstring("\\varepsilon")) to allow for outliers. Normalization has to be done in the end.
$(latexstring("p(\\boldsymbol{x} \\mid \\vec{a}, M) = \\frac{1}{Z} \\prod_{\\nu=1}^{\\mathcal{N}} (\\dfrac{1}{\\exp(\\beta C_\\nu \\,M(\\boldsymbol{x}_\\nu) \\cdot \\vec{a}) +1} + \\varepsilon)")). 
$(latexstring("\\beta")) defines how fast the logistic function drops from one to zero. One can interprete it as a temperature in the context of the Fermifunction.
The higher $(latexstring("\\beta")) the more the Likelihood function resembles a step function.

### Bayes theorem

The set of parameters




"""

# ╔═╡ 7d431428-0418-45fa-8ba6-3ec6837019f5
begin
	image_url = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Fishground_map_points.png"
	image_url_small = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Fishground_map_points_marked.png"
	image_local = download(image_url_small)
	IMA = load(image_local)
	frogfish = RGBA{N0f8}(0,1,0,1.)
	fish = RGBA{N0f8}(1,0,0,1.)
	empty = IMA[1]
	reduced_picture = IMA
	index_frogfish = findall(reduced_picture .== frogfish)
	index_fish = findall(reduced_picture .== fish)
	
	y_frogfish = [size(reduced_picture,1) .+ 1 .- index_frogfish[i][1] for i = 1:length(index_frogfish)]
	x_frogfish = [index_frogfish[i][2] for i = 1:length(index_frogfish)]
	
	y_fish = [size(reduced_picture,1) .+ 1 .- index_fish[i][1] for i = 1:length(index_fish)]
	x_fish = [index_fish[i][2] for i = 1:length(index_fish)]
	md""" Get data from image"""
end

# ╔═╡ 6df77838-6816-4af8-978d-83bb79de947a
reduced_picture

# ╔═╡ a83984f9-7375-40be-a0a2-03b71ffa2fea
begin
	
	function likelihood(data, param, epsil)
		beta = 1
#aram = [0.02,0.02]		
		dist = data[:,3] .* (param[1]*data[:,1] + param[2]*data[:,2] .+ 1)
		
	
	p_norm = (1 ./(exp.(dist*beta) .+1) .+ epsil) + (1 ./(exp.(-dist*beta) .+1) .+ epsil)
	
	p =(1 ./(exp.(dist*beta ) .+1) .+ epsil)./p_norm
		log_p = sum(log.(p))
		return p, log_p
	
end	
	
	function scan_parms(data,parm,eps_outlier)

    log_like_max =  -1.e30
    M_ln_p       = zeros(parm.N_pivot[1],parm.N_pivot[2],parm.N_pivot[3])

    for (ia,a) in enumerate(parm.L_pivot[1])
        for (ib,b) in enumerate(parm.L_pivot[2])
            for (ic,c) in enumerate(parm.L_pivot[3])
                va = [a,b,c]
                d1, log_like = likelihood(data, va, eps_outlier)
                M_ln_p[ia,ib,ic] = log_like
            end
        end
    end

    Ind    = argmax(M_ln_p)
    va_MAP =  [parm.L_pivot[i][Ind[i]] for i = 1: 3]

    p2, log_like_max = likelihood(data, va_MAP, eps_outlier)

    #  mean and covariance
    max_ln_p = maximum(M_ln_p)
    M_ln_p   = M_ln_p .- max_ln_p
    M_p      = exp.(M_ln_p)
    aux      = sum(M_p)
    ln_Z     = max_ln_p + log(aux)
    M_p      = M_p ./ aux

    L_I_pair = [2 3; 1 3; 1 2]

    L_p = [reshape(sum(M_p,dims=L_I_pair[j,:]),parm.N_pivot[j],1) for j = 1: 3]

    va_mean = [sum(L_p[j].*collect(parm.L_pivot[j])) for j = 1: 3]

    Cov = zeros(3,3)
    for k = 1: 3
        i = L_I_pair[k,1]
        j = L_I_pair[k,2]
        Cov[i,j] = collect(parm.L_pivot[i])' * reshape(sum(M_p,dims=k),parm.N_pivot[i],parm.N_pivot[j]) * collect(parm.L_pivot[j])
        Cov[j,i] = Cov[i,j]
    end

    for k = 1: 3
        Cov[k,k] = sum(L_p[k].* (collect(parm.L_pivot[k]).^2))
    end

    Cov_a = Cov - va_mean * va_mean'


    return log_like_max, va_MAP, va_mean, Cov_a, ln_Z, L_p, M_p
end
	
	
end

# ╔═╡ bedfbe0a-feec-4b1a-86af-a6327adb0804
begin
struct Parm
    ranges::Array{Float64,2}
    N_pivot::Array{Int64,1}
    #d_pivot::Array{Float64,1}
    L_pivot:: Vector{Any}
    N_all::Int64
    function Parm(ranges::Array{Float64,2},N_pivot::Array{Int64,1})
       	#d_pivot = [N_pivot[i] > 1 ? (ranges[i,2]-ranges[i,1])/(N_pivot[i]-1) : 1.0 + (ranges[i,2]-ranges[i,1])  for i = 1: 3]
        L_pivot = [range(ranges[i,1],stop=ranges[i,2],length=N_pivot[i])  for i = 1: 3]
        N_all = prod(N_pivot)
        new(ranges,N_pivot,L_pivot,N_all,)
    end
end

md""" definition of struct parm"""
	
end

# ╔═╡ f4b80850-0f0c-4a05-bcd5-70392d98c658
begin
	
	
x0 = [x_fish;x_frogfish]
y0 = [y_fish;y_frogfish]
C0 = [1*ones(length(x_fish),1);-ones(length(x_frogfish),1)]
	
	

	
data = [x0 y0 C0]
	#data = data[[1;;3;5;6;8;9; 11:17; 27:end-5], :]
	#data = data[1:end-2, :]
	#likelihood(Lxy, va, epsil, Lcls)


	
M = 1
if M == 1
    ranges = 20 .* [-0.01111 0.001; -0.001 0.01; 0 0]
    N_pivot = [400; 500; 1]
else
    ranges = [6.0 10.0; -2.0  0.0;  -1.0 1.0]
    N_pivot = [50; 50; 50]
end
	parm = Parm(ranges,N_pivot)
	
	
	
	eps_outlier = 0.3
	log_like_max, va_MAP, va_mean, Cov_a, ln_Z, L_p, M_p=  scan_parms(data,parm,eps_outlier)
	
	
end

# ╔═╡ 5d46bf84-f89a-4190-9d8a-822dcc8418c9
begin
	epsil = 0.1
	beta = 10
p_test =va_MAP#[0.15, -0.3, 0]
a,b = likelihood(data, p_test, epsil)
	dist = data[:,3] .* (p_test[1]*data[:,1] + p_test[2] .* data[:,2] .- 1)
	sum(log.(1 ./(exp.(beta*dist) .+ 1) .+ epsil))
end

# ╔═╡ b0d6f8d5-4aae-4518-a10a-82a945667622
begin 
	
	normali =  Float64(parm.L_pivot[1].step) .* Float64(parm.L_pivot[2].step)
	M_norm = M_p[:,:,1]' ./normali
	#M_norm = M_norm[end:-1:1,:]
	heatmap(parm.L_pivot[1], parm.L_pivot[2], M_norm,
		xlabel = latexstring("a_1"),
		ylabel = latexstring("a_2"),
		title = "Posterior probability density of parameters",
		size = (600,400),
		labelfontsize = 20,
		tickfontsize = 15,
		bottom_margin =5mm,
		left_margin = 5mm,
		right_margin = 11mm,
		linewidth = 3,
		label = :none,
		titlefontsize = 20,	
		#foreground_color_grid = :black,
		#foreground_color_xticks = :black,
		background_color = :transparent,
		#foreground_color_axis = :black,
		#foreground_color_text = :black,
		#foreground_color_border = :black,
		foreground_color = :black,
		fontfamily="Computer Modern")
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 7//Images//classi_joint_prob_2")
	
	
end

# ╔═╡ 7d00c4b6-2ade-44ed-821d-845e0b696b8b
begin 
	plot(data[data[:,3].== 1,1], data[data[:,3].== 1,2], line=:scatter, label = :none)
	t = 0:250
	#plot!(t, +1/p_test[2] .- p_test[1]/p_test[2].*t)
	plot!()
	#plot!(x0, y0, line=:scatter, marker=:star, markersize = 1)
	xx_range = parm.L_pivot[1]
	yy_range = parm.L_pivot[2]
	xx_az = xx_range' .+ yy_range.*0
	yy_az = xx_range'.*0 .+ yy_range
	
	
	# plot(x, azimuth, line= :scatter, label="azimuth", legend=:bottom)
	#plot(x,azimuth, line = :scatter, label = :none)
    level = 800
	if sum(M_norm[:] .> level) < 2000
	for i = 1:length(xx_az)
		if M_norm[i] >level
			plot!(t, -1. /yy_az[i] .- xx_az[i]./yy_az[i] .* t, linewidth = 2, opacity = M_norm[i]/8000, color = :red, label = :none)
		end
	end
	end
	plot!(data[data[:,3].== -1,1],data[data[:,3].== -1,2], color=:green,line=:scatter, ylim=[0,150],
		label = :none,
		title = "linear solutions for boundaries",
		xlabel = latexstring("x"), 
		ylabel = latexstring("y"),
	size = (600,400),
		labelfontsize = 20,
		tickfontsize = 15,
		bottom_margin =5mm,
		left_margin = 5mm,
		right_margin = 5mm,
		linewidth = 3,
		titlefontsize = 20,	
		#foreground_color_grid = :black,
		#foreground_color_xticks = :black,
		background_color = :transparent,
		#foreground_color_axis = :black,
		#foreground_color_text = :black,
		#foreground_color_border = :black,
		foreground_color = :black,
		fontfamily="Computer Modern")
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 7//Images//classi_boundaries_2")
	
end

# ╔═╡ 0972e9e4-7aa6-46cf-9c36-16c1b55858e9
begin
	claire = "https://raw.githubusercontent.com/Captain-Bayes/images/main/claire_100px.gif"
	makabe = "https://raw.githubusercontent.com/Captain-Bayes/images/main/makeba_100px.gif"
	bernoulli = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Bernoulli_wet.gif"
	island = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Turtle_island_with_ship.png"
	map = "https://raw.githubusercontent.com/Captain-Bayes/images/main/Fishground_map.png"
	frogfish_image = "https://raw.githubusercontent.com/Captain-Bayes/images/main/frogfish_green_full.gif"
	
	
	md"""Images"""
end

# ╔═╡ 0b775a36-64d0-4f32-a409-6c0dd859b337
begin
	md"""
# Fishgrounds
Welcome to turtle island with its two villages, the one on the right, where Claire the owner of a famous pottery store lives and Frogville village no the upper left with the environmental activist Makabe.
	
$(Resource(makabe, :width=>100))
$(Resource(island, :width=> 450))
$(Resource(claire, :width=> 100))
"""
end

# ╔═╡ 82c39e5a-e46a-4db5-9b7c-d879c415a908
md"""
Makabe and Claire have a dispute, Makabe and her village try to protect the endangered frogfish whereas Claire needs to catch fish. 

$(Resource(frogfish_image, :width=>100))
So they are looking for a boundary to split the sea between their villages in a protected area for the frogfish and an area for fishing.

Bernoulli already went out to collect some data where frogfish and normal fish can be found
$(Resource(bernoulli, :width=>100))
$(Resource(map, :width=>600))
"""


# ╔═╡ efc86030-bd6a-4820-b410-d1399b73968b
begin
	kk = 0:0.1:0.4
	k_mu = 0.16
	k_sigma = 0.03
	pkk = 1/(sqrt(2*pi*k_sigma^2)) .*exp.(-(kk .-k_mu).^2 ./(2*k_sigma^2))
	
	plot(kk,sin.(kk),line=(:scatter), mswidth = 2,ylim = [0,1.55],marker = :o,size = (660,440),
	xlabel = latexstring("x"),
	ylabel = latexstring("y(x)"),
	labelfontsize = 20,
	tickfontsize = 15,
	bottom_margin =5mm,
	left_margin = 5mm,
	linewidth = 3,
	label = :none,
	#yticks=:none,
	foreground_color = :black,
	titlefontsize = 20,	
	#foreground_color_grid = :black,
	#foreground_color_xticks = :black,
	background_color = :transparent,
	#foreground_color_axis = :black,
	#foreground_color_text = :black,
	#foreground_color_border = :black,
	fontfamily="Computer Modern"
	)
	
	
	#savefig("C://Lehre//Bayes MOOC//Lesson 6//Images//model_cubic")
	
	
end

# ╔═╡ Cell order:
# ╟─0b775a36-64d0-4f32-a409-6c0dd859b337
# ╠═82c39e5a-e46a-4db5-9b7c-d879c415a908
# ╟─9d959eb7-6b01-41fc-a8c1-62ce5c42e2dd
# ╟─7d431428-0418-45fa-8ba6-3ec6837019f5
# ╟─6df77838-6816-4af8-978d-83bb79de947a
# ╠═7d00c4b6-2ade-44ed-821d-845e0b696b8b
# ╟─5d46bf84-f89a-4190-9d8a-822dcc8418c9
# ╟─f4b80850-0f0c-4a05-bcd5-70392d98c658
# ╟─b0d6f8d5-4aae-4518-a10a-82a945667622
# ╟─a83984f9-7375-40be-a0a2-03b71ffa2fea
# ╟─bedfbe0a-feec-4b1a-86af-a6327adb0804
# ╟─0972e9e4-7aa6-46cf-9c36-16c1b55858e9
# ╠═efc86030-bd6a-4820-b410-d1399b73968b
# ╠═39b06b5b-c218-4aae-88d1-0e641d7303a8
