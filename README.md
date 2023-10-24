# Pico.jl
A convenience meta-package for quantum optimal control using the Pade Integrator COllocation (PICO) method.

## Description

### JuliCon 2033 Talk
To see an overview of the PICO method and a demo of how to use this package, check out our recorded talk at JuliaCon 2023 [here](https://www.youtube.com/watch?v=NBdck6UX0Tc).

### Direct Collocation for Quantum Optimal Control
To see a detailed description of the PICO method, check out our paper [here](https://arxiv.org/abs/2305.03261).  It won 2nd best paper in the QTEM category at IEEE QCE 2023! 


## Usage

Just run
```julia
using Pico
```

and this package reexports the following packages

- [QuantumCollocation.jl](https://github.com/aarontrowbridge/QuantumCollocation.jl)
- [NamedTrajectories.jl](https://github.com/aarontrowbridge/NamedTrajectories.jl)
- [TrajectoryIndexingUtils.jl](https://github.com/aarontrowbridge/TrajectoryIndexingUtils.jl)

## Installation
This package is registered! To install just run 
```julia
] add Pico
```
in the REPL

## Local Development

To develop locally, clone this repo and then instantiate the environment in the REPL by running first
```julia
] activate .
```
And then, 
```julia
] instantiate 
```
Both commands should be run in pkg mode, which is activated by typing `]` in the REPL.

To start julia with the current environment, run
```bash
julia --project=.
```
from the Pico.jl directory.

To run the scripts use, e.g.,
```bash
julia -t <num_threads> --project=. examples/three_qubit_swap/swap.jl
```
where `<num_threads>` is the number of threads you want to use as QuantumCollocation.jl takes advantage of multithreading.  The `--project=.` flag is necessary to make sure the correct environment is loaded.

