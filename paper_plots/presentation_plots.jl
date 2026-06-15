using PCDSampling
using Distributions
using CairoMakie
using FileIO
using Random

function banana(;N=10)
    Random.seed!(42)
    C = 100
    ws = rand(C)
    ws ./= sum(ws)

    ms = [[0.0, 0.0], [-1.5, -1.0], [1.5, -1.0]]
    vs = [[1 0; 0 0.3], [0.4 0.1; 0.1 0.8], [0.4 -0.1; -0.1 0.8]]
    target = MixtureModel([MvNormal(m, v) for (m, v) in zip(ms, vs)])
    
    dirs = uniform_directions_2d(1000)
    X, _ = draw_samples(target, N, dirs, stop_cond=max_iters_and_small_delta(10000, 1e-8), N_lut=200) 
    
    with_theme(theme_latexfonts()) do
    f = Figure(width=800, height=400)
    ax = Axis(f[1, 1], aspect=DataAspect(), xlabel=L"x_1 \rightarrow", ylabel=L"x_2 \rightarrow", 
                xlabelsize=25, ylabelsize=25, xticklabelsize=20, yticklabelsize=20)
    xs = -5:0.1:5
    ys = -5:0.1:5
    zs = [Distributions.pdf(target, [x, y]) for x in xs, y in ys]
    cp = contourf!(ax,xs, ys, sqrt.(zs), colormap=:viridis)
    Colorbar(f[1, 2], cp, label = L"\text{pdf}", labelsize=20, ticklabelsize=20)
    rowsize!(f.layout, 1, 260)
    resize_to_layout!(f)
    save("./paper_plots/plots/banana.svg", f)
    
    scatter!(ax, X, markersize=10, color=:red)
    rowsize!(f.layout, 1, 260)
    resize_to_layout!(f)    
    save("./paper_plots/plots/banana_samples.svg", f)
    display(f)
    end
end

function pineapple(;N=10)
    Random.seed!(42)
    C = 100
    ws = rand(C)
    ws ./= sum(ws)

    ms = [[0.0, 0.0], [-1.5, -1.0], [1.5, -1.0], [0.0, -3.0]]
    vs = [[1 0; 0 0.3], [0.4 0.1; 0.1 0.8], [0.4 -0.1; -0.1 0.8], [2.0 0; 0 3.0]]
    target = MixtureModel([MvNormal(m, v) for (m, v) in zip(ms, vs)], [0.1, 0.1, 0.1, 0.7])
    
    dirs = uniform_directions_2d(1000)
    X, _ = draw_samples(target, N, dirs, stop_cond=max_iters_and_small_delta(10000, 1e-8), N_lut=200) 
    
    with_theme(theme_latexfonts()) do
    f = Figure(width=800, height=400)
    ax = Axis(f[1, 1], aspect=DataAspect(), xlabel=L"x_1 \rightarrow", ylabel=L"x_2 \rightarrow", 
                xlabelsize=25, ylabelsize=25, xticklabelsize=20, yticklabelsize=20)
    xs = -5:0.1:5
    ys = -5:0.1:5
    zs = [Distributions.pdf(target, [x, y]) for x in xs, y in ys]
    cp = contourf!(ax,xs, ys, sqrt.(zs), colormap=:viridis)
    Colorbar(f[1, 2], cp, label = L"\text{pdf}", labelsize=20, ticklabelsize=20)
    rowsize!(f.layout, 1, 260)
    resize_to_layout!(f)
    save("./paper_plots/plots/banana.svg", f)
    
    scatter!(ax, X, markersize=10, color=:red)
    rowsize!(f.layout, 1, 260)
    resize_to_layout!(f)    
    save("./paper_plots/plots/banana_samples.svg", f)
    display(f)
    end
end

function generate_plots()
    banana(;N=10)
    pineapple(;N=10)
end

generate_plots()