using PCDSampling
using Distributions
using CairoMakie
using FileIO
using Random
using LinearAlgebra

R(a) = [cos(a) sin(a); -sin(a) cos(a)]
rotate(m, a) = Symmetric(R(a) * m * R(a)')

function banana(;N=10)
    Random.seed!(42)
    C = 100
    ws = rand(C)
    ws ./= sum(ws)

    ms = [[1.7, -4.1], [0.4, -2.3], [0.0, 0.0], [0.4, 2.3], [1.7, 4.1]] ./ 2
    vs = ([[2.4 0; 0 0.75], [1.9 0; 0 1.1], [1.2 0; 0 1.4]]./2).^2
    vs_rot = [rotate(vs[1], pi/6), rotate(vs[2], pi/3), vs[3], rotate(vs[2], -pi/3), rotate(vs[1], -pi/6)]
    target = MixtureModel([MvNormal(m, v) for (m, v) in zip(ms, vs_rot)])
    
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

    ms = [[0.0, -2.0], [-4.5, 3.0], [-3, 6.0], [3, 6.0], [4.5, 3.0]] ./ 2
    vs = ([[1.5 0; 0 2], [2.3 0; 0 1.0]]./2).^2
    
    vs_rot = [vs[1], rotate(vs[2], pi/8), rotate(vs[2], pi/4), rotate(vs[2], -pi/4), rotate(vs[2], -pi/8)]

    target = MixtureModel([MvNormal(m, v) for (m, v) in zip(ms, vs_rot)], [0.4; fill((1-0.4)/4, 4) ])
    
    dirs = uniform_directions_2d(1000)
    X, _ = draw_samples(target, N, dirs, stop_cond=max_iters_and_small_delta(10000, 1e-8), N_lut=200) 
    
    with_theme(theme_latexfonts()) do
    f = Figure(width=800, height=400)
    ax = Axis(f[1, 1], aspect=DataAspect(), xlabel=L"x_1 \rightarrow", ylabel=L"x_2 \rightarrow", 
                xlabelsize=25, ylabelsize=25, xticklabelsize=20, yticklabelsize=20)
    xs = -6:0.1:6
    ys = -5:0.1:7
    zs = [Distributions.pdf(target, [x, y]) for x in xs, y in ys]
    cp = contourf!(ax,xs, ys, sqrt.(zs), colormap=:viridis)
    Colorbar(f[1, 2], cp, label = L"\text{pdf}", labelsize=20, ticklabelsize=20)
    rowsize!(f.layout, 1, 260)
    resize_to_layout!(f)
    save("./paper_plots/plots/banana.svg", f)
    
    # scatter!(ax, [m[1] for m in ms], [m[2] for m in ms], markersize=10, color=:red)
    scatter!(ax, X, markersize=10, color=:red)
    rowsize!(f.layout, 1, 260)
    resize_to_layout!(f)    
    save("./paper_plots/plots/banana_samples.svg", f)
    display(f)
    end
end

function generate_plots()
    # banana(;N=20)
    pineapple(;N=20)
end

generate_plots()