println("loading packages...")
using Pico
using LinearAlgebra

# problem parameters

max_iter = 250
R = 1e-3

Q = 200.0

a_bound = 2π * 0.04 # GHz, a guess!
dda_bound = 0.05

duration = 100.0 # ns
T = 24 * 10
Δt = duration / T
Δt_min = 0.5 * Δt
Δt_max = 2.0 * Δt

load_trajectory = false
load_path = "results/T_500_Q_200.0_Δt_0.4_a_bound_0.25132741228718347_dda_bound_0.05dt_min_0.2_dt_max_0.4_max_iter_100000_00002.jld2"

if load_trajectory
    data = load_problem(load_path; return_data=true)
    traj = data["trajectory"]
    new_bounds = merge(
        traj.bounds,
        (dda = (-fill(dda_bound, traj.dims.a), fill(dda_bound, traj.dims.a)),)
    )
    traj.bounds = new_bounds
end


println("building hamiltonian terms...")

e0 = [1, 0]
e1 = [0, 1]

Id = GATES[:I]

e00 = e0 * e0'
e11 = e1 * e1'
e01 = e0 * e1'
e10 = e1 * e0'

U_goal_analytic =
    e00 ⊗ Id ⊗ e00 +
    e10 ⊗ Id ⊗ e01 +
    e01 ⊗ Id ⊗ e10 +
    e11 ⊗ Id ⊗ e11

U_goal = Matrix{ComplexF64}(U_goal_analytic)

â_dag = create(2)
â = annihilate(2)

ωs = 2π .* [5.18, 5.12, 5.06]
ω_d = 2π * 5.12

ξs = 2π * [0.34, 0.34, 0.34]

J_12 = 2π * 5.0e-3
J_23 = 2π * 5.0e-3


H_drift = sum(
    (ωs[q] - ω_d) * lift(â_dag, q, 3) * lift(â, q, 3) -
    ξs[q] / 2 * lift(â_dag, q, 3) * lift(â_dag, q, 3) * lift(â, q, 3) * lift(â, q, 3)
        for q = 1:3
)

# dispersive coupling
H_drift +=
    J_12 * (
        lift(â_dag, 1, 3) * lift(â, 2, 3) +
        lift(â, 1, 3) * lift(â_dag, 2, 3)
    ) +
    J_23 * (
        lift(â_dag, 2, 3) * lift(â, 3, 3) +
        lift(â, 2, 3) * lift(â_dag, 3, 3)
    )

H_drives_Re = [lift(â, j, 3) + lift(â_dag, j, 3) for j = 1:3]
H_drives_Im = [1im * (lift(â, j, 3) - lift(â_dag, j, 3)) for j = 1:3]

H_drives = vcat(H_drives_Re, H_drives_Im)

println("building problem...")

prob = UnitarySmoothPulseProblem(
    H_drift,
    H_drives,
    U_goal,
    T,
    Δt;
    init_trajectory = load_trajectory ? traj : nothing,
    Q=Q,
    R=R,
    a_bound = a_bound,
    dda_bound = dda_bound,
    Δt_min = Δt_min,
    Δt_max = Δt_max,
    max_iter = max_iter,
    verbose = true,
)

experiment = "T_$(T)_init_duration_$(duration)_max_iter_$(max_iter)"

save_dir = joinpath(@__DIR__, "results")
plot_dir = joinpath(@__DIR__, "plots")

save_path = generate_file_path("jld2", experiment, save_dir)
plot_path = generate_file_path("png", experiment, plot_dir)

println("plotting initial guess...")

plot(plot_path, prob.trajectory, [:Ũ⃗, :a]; ignored_labels=[:Ũ⃗])

println("solving problem...")
solve!(prob)
println()

println("plotting final result...")
plot(plot_path, prob.trajectory, [:Ũ⃗, :a]; ignored_labels=[:Ũ⃗])

fid = unitary_fidelity(prob)

println("Final fidelity: ", fid)

info = Dict(
    "fidelity" => fid,
    "pulse duration" => times(prob.trajectory)[end],
)

println("saving results...")
save_problem(save_path, prob, info)
