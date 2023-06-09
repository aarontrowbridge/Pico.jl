# Piccolo.jl
A convenience meta-package for quantum optimal control using the Pade Integrator COllocation (PICO) method.


## Usage

Just run
```julia
using Piccolo
```

and this package reexports the following packages

- [QuantumCollocation.jl](https://github.com/aarontrowbridge/QuantumCollocation.jl)
- [NamedTrajectories.jl](https://github.com/aarontrowbridge/NamedTrajectories.jl)
- [TrajectoryIndexingUtils.jl](https://github.com/aarontrowbridge/TrajectoryIndexingUtils.jl)
- [IterativeLearningControl.jl](https://github.com/aarontrowbridge/IterativeLearningControl.jl)

## Installation
This package is not yet registered so install with
```julia
using Pkg
Pkg.add(url="https://github.com/aarontrowbridge/Piccolo.jl.git", rev="main")
```
