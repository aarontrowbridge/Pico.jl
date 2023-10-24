using Pico

# fetching the free-time solution

data_path = "results/T_240_init_duration_100.0_max_iter_250_00000.jld2"

# mintime objective term weight
D = 1.0e4

# final fidelity constraint
final_fidelity = 0.999

max_iter = 200

experiment = join(split(basename(data_path), ".")[1:end-1], ".") * "_final_fidelity_$(final_fidelity)"

plot_dir = joinpath(@__DIR__, "plots_mintime")

save_dir = joinpath(@__DIR__, "results_mintime")

plot_path = generate_file_path("png", experiment, plot_dir)

save_path = generate_file_path("jld2", experiment, save_dir)

prob = UnitaryMinimumTimeProblem(joinpath(@__DIR__, data_path); D=D, final_fidelity=final_fidelity)

println()
println("initial fidelity: ", unitary_fidelity(prob))
println("initial duration: ", times(prob.trajectory)[end])
println()

plot(plot_path, prob.trajectory, [:Ũ⃗, :a]; ignored_labels=[:Ũ⃗])

solve!(prob; max_iter=max_iter)

plot(plot_path, prob.trajectory, [:Ũ⃗, :a]; ignored_labels=[:Ũ⃗])

# calculating unitary fidelity
fid = unitary_fidelity(prob)
dur = times(prob.trajectory)[end]
println("final fidelity: ", fid)
println("final duration: ", dur)
println()

println("saving results...")
info = Dict(
    "fidelity" => fid,
    "duration" => dur,
)

save_problem(save_path, prob, info)
