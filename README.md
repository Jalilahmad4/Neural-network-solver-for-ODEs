# Neural Network Solver for Ordinary Differential Equations (ODEs)

This repository contains MATLAB code that demonstrates a neural network-based approach to solve ordinary differential equations (ODEs). The approach uses a feed-forward neural network and Particle Swarm Optimization (PSO) to minimize a cost function. The provided example demonstrates the solution of a first-order ODE and compares the results with traditional numerical methods like Euler's method and MATLAB's ode45.

## Installation and Setup

To run this code, you'll need MATLAB installed on your system. The code uses basic MATLAB functionality along with the Global Optimization Toolbox for Particle Swarm Optimization.

## Running the Example

The provided example solves a first-order ordinary differential equation (ODE) and compares the solution obtained via a neural network with those from traditional numerical methods like Euler's method and MATLAB's `ode45`. The differential equation to be solved is:

```math
\begin{cases}
y'(t) = e^{-t} - y, \quad 0 \leq t \leq 10,\\
y(0) = 1,
\end{cases}
```
This is a simple linear ODE with an exponential decay term. The exact solution for this problem is:

```math
y(t) = \frac{1 + t}{e^t}.
```
This code can be modified for any first-order ODE by modifying `f.m` and `main.m` files. 
