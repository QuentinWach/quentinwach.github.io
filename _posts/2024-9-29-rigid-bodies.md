---
layout: post
mathjax: true
title:  "Applied Mechanics: Constrained Dynamics I"
description: "Explaining briefly (very, very briefly) what shaders are and then moving on to writing two simple ones in GLSL. The first one similar to a lava lamp and the second one a little mountain range under a blue sky with a distance fog. Turns out, shaders are like painting directly with mathematics."
date:   2025-09-28 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["physics"]
tag_search: true
image:     "/images/applied mechanics/COver_Sims_2.png"
weight:
note: 
categories: "blog"
---
Physics simulations are as abundant as in the sciences, if not more, in movies, games, and engineering. Many of the problems to be solved have rigid and soft-body physics as the primary elements and most contain such bodies at least in part as they interact with other physics such as fluids.

## Introduction
Let's build and break some stuff. Let's solve the mathematics of the trebuchet. Let's simulate the collapse of bridges and houses. Let's simulate complex pulley systems, gears and clocks, and do so correctly!

I am quite the fan of the game Teardown and its maker Dennis Gustafsson[^voxagon_blog]. I've also long been jealous of _Ange the Great_ and his custom physics engines[^ange_engine_vids] to implement complex constrained physics systems. So some time ago, I went down the rabbit hole of the physics of constrained systems and discovered that barely any of it was ever even mentioned during my undergrad physics program. Nor are there any graduate courses that talk about such things.

While Ange explains the basic ideas and some of the mathematics of how to solve such systems and even links some sources[^Witkin_constrained], which others talk about as well[^brashtop_phys_blog]. Yet, they aren't quite as detailed as I would wish for.

So this is my take on it.

I will begin laying out the general approach. Then we will discuss various common methods to solve such a system of equations. Then we will learn how to define all the possible constraints to set up any constraint rigid body system we can think of.

### Starting Point: Analytical Mechanics
Much of the mathematics below is based on an article by Zoltán Jakab[^paper_jakab]. We start with the Euler-Lagrange equation with additional  

$$
\frac{d}{dt} \frac{\partial \mathcal L}{\partial \dot r_k} - \frac{\partial \mathcal L}{\partial r_k} + \sum_i \lambda_i \frac{\partial f_i}{r_k} = 0.
$$

With that, we will:
1. Calculate the forces & constraints that effect the bodies.
2. Apply an integrator to calculate the new state.

### Our Data as Vectors and Matrices
We create a vector of all the vectors in the system, both linear and angular!

$$
\vec{v} = (v_{1x}, v_{1y}, v_{1z}, \omega_{1x}, \omega_{1y}, ...)
$$

We do the same for the positions and orientations:

$$
\vec{x} = (x_{1x}, x_{1y}, x_{1z}, \theta_{1x}, \theta_{1y}, ...).
$$

We repeat this. Let $$\vec{a}$$ be the linear and angular acceleration defined in the same fashion. And $$\vec{F}$$ the vector of all the forces and torque. The masses $$M_i$$ we define as a matrix

$$ \hat{M} = \begin{pmatrix} M_1 & 0 & \cdots & 0 \\ 0 & M_2 & \cdots & 0 \\ \vdots & \vdots & \ddots & \vdots \\ 0 & 0 & \cdots & M_n \end{pmatrix} \qquad \text{where} \quad M_n \quad \text{is} \quad M_n = \begin{pmatrix} m_n E & 0 \\ 0 & I_n \end{pmatrix}
$$

with $m_n$ the mass of the $n$-th rigid body and $I_n$ the moments of inertia about the center of mass.
### The Base Equations: Newton-Euler Approach
The Newton-Euler Equations are then

$$\mathbf{F} = \hat{M} \cdot \mathbf{a} + \mathbf{G}.$$

$\mathbf{G}$ is the gyroscopic term in matrix form (often ignored). With the Lagrangian

$$\mathcal{L} = T(\dot{q_i}) - V(q_i),$$

note that $V(q_i)$ is only position-dependent), and the Euler-Lagrange Equation

$$
\frac{d}{dt} \left( \frac{\partial \mathcal{L}}{\partial \dot{q_i}} \right) - \frac{\partial \mathcal{L}}{\partial q_i} + \sum \lambda_k \frac{\partial f_k}{\partial q_i} = 0
$$

we plug $\mathcal{L}$ into the Euler-Lagrange equation

$$
\frac{d}{dt} \left( \frac{\partial (T(\dot{q_i}) - V(q_i))}{\partial \dot{q_i}} \right) - \frac{\partial (T(\dot{q_i}) - V(q_i))}{\partial q_i} = \cdots
$$

which simplifies to

$$
\begin{align}
\underbrace{\frac{d}{dt} \left( \frac{\partial T}{\partial \dot{q_i}} \right)}_{m \cdot a} - \underbrace{\frac{\partial V}{\partial q_i}}_{\nabla V} + \underbrace{\sum \lambda_k \frac{\partial f_k}{\partial q_i}}_{J^T \lambda} &= 0 \\\\

\Leftrightarrow \qquad \underbrace{m \cdot a}_{F} - \underbrace{\nabla V}_{N} + \underbrace{\hat J^T \lambda}_{C} &= 0
\end{align}
$$

where $\hat J$ is the Jacobian matrix of the constraint function $f$, $\lambda$ is the vector of Lagrange multipliers, F$ represented the inertial forces, $N$ are non-constraint forces (e.g. gravity), and $C$ are constraint forces. This resembles the Newton-Euler equation $N + C = M \cdot a$ and may also be called a "Continuous-Time Equation" which we will now need to discretize so we can solve it numerically for $\lambda$. We will do so by introducing the time-step $h$.

### Discretization Using Euler Integration
In discrete time-stepping, we use a simple explicit Euler scheme to update the velocity $v$:

$$
v_2 = v_1 + h \cdot a
$$

with $v_2$ the velocity at the next time step, $v_1$ the velocity at the current time step, and $a$ the acceleration, of course.

If we now take what we may call the "constraint equation"

$$
J v + b = 0
$$

with an introduced bias term $b$ (which could account for things like external forces e.g. a motor, drift correction, etc.) we can update it to be discrete:

$$
J(v_1 + h \cdot a) + b = 0.
$$

We can also rewrite our previous continuous-time equation as the equation of motion

$$
a = \hat{M}^{-1}(N+J^T\lambda)
$$

and insert this back into our now discretized constraint equation which gives us

$$
J(v_1 + h \cdot \hat{M}^{-1}(N+J^T\lambda)) + b = 0.
$$

We expand

$$
J \cdot v_1 + J \cdot h \cdot \hat{M}^{-1} N + Jh \hat{M}^{-1} J^T \lambda + b = 0 
$$

and isolate the $\lambda$ term

$$
J \hat{M}^{-1} J^T \lambda = - \big[ J (v_1 + h \hat{M}^{-1} N) + b \big]
$$

which is an equation of the form

$$
\hat{A} \cdot \lambda = \vec{b}
$$

with $$\hat{A}$$ a matrix and $$\vec{b}$$ a vector. This is very important. The nature of $$\hat{A}$$ is especially important. More on that later when we discuss how to solve this equation. 
### Deriving & Implementing Constraints
For now, we still have to define what our system, should actually look like. A double pendulum? A ball in bowl? A catapult? A skyscraper? A piston engine? There are various constraints to be discussed which we will need to describe any arbitrary mechanical system.










### Solving the System of Equations
All physics solvers come with certain pros and cons. Hence, for any non-trivial problem, we need to tailor the solver to our problem. 

My notes on [[Constrained Dynamics]] (should) mention that solving the system of equations for typically  highly sparse matrices... Imagine executing the standard methods for calculating the solution here. You'd evaluate a bunch of equations that should be zero anyway. Indeed, computers too are absolutely horrible at solving equations involving sparse matrices [citation needed]!

![[Pasted image 20240924100620.png]]
(This is a sparse matrix as shown in the #video https://www.youtube.com/watch?v=oulfRfqTxJA&list=PLUahe1BHkKtW3ekopap0g-BxRMyk8UDU2&index=8 about the Engine Simulator by Ange the Great.)
### Gaussian Elimination
Gaussian elimination is fast enough for small matrices and we all know it from our linear algebra classes. Yet it has a time complexity of $O(n^3)$.
## Conjugate Gradient Method
This method seems to be much more stable. Funnily enough, it is also faster! Why? Because we actually don't need to calculate the matrix. But... it kinda breaks??? (Ange talked about this here: https://www.youtube.com/watch?v=n5CIlrOMKiU&list=PLUahe1BHkKtW3ekopap0g-BxRMyk8UDU2&index=9)
## Position Based Dynamics
This method is very fast. It is also stable. Yet it is not very accurate.
paper: https://mmacklin.com/2017-EG-CourseNotes.pdf
### Gauss-Seidel Method
We need to compute with the entire matrix here.
But, we can solve the equations iteratively, approximating the correct solution with every iteration ever more closely. [This video](https://www.youtube.com/watch?v=oulfRfqTxJA&list=PLUahe1BHkKtW3ekopap0g-BxRMyk8UDU2&index=8 ) (again) talks about how it can be used to speed up such physics simulations. Typically, we initialize the lambda vector with random values and then iteratively update them until the error is small enough. But amazingly, we can also just use the previous solution in the time-series as the starting point in this process which should reduce how many iterations are needed quite significantly. [By how much?] 

The key problem with this method is that it is not guaranteed to always converge which can be extremely annoying. [Are there any solutions to this problem?]
## SIMD Optimization of the Gauss-Seidel Method
The paper https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2782869/ explains how to parallelize this very much serial method using SIMD instructions with the purpose to utilize massively parallel computing using GPGPUs for example. Awesome idea! [I need to look into that.]

But again, the convergence and stability of this method is questionable.
## A Bunch of more amazing Gauss-Seidel Optimizations!
Short version: Instead of storing the entire matrix, we only store the non-zero values and don't do all the unnecessary multiplications by zero! We can expect an order of magnitude speed up here, possibly more as the system grows in complexity.

About sparse matrices:
https://en.wikipedia.org/wiki/Sparse_matrix

This is an amazing video. A MUST WATCH!
https://www.youtube.com/watch?v=P-WP1yMOkc4









While written in a very non-academic style, I'd love to see you cite the writing below if it helped you in hopes that I might see who I helped and how. You can cite me either as **Quentin Wach, _"Constrained Dynamics"_, 2024** or using: 

<span class="sidenote-right">
```bibtex
@misc{wach2024constrained,
  author = {Quentin Wach},
  title = {Constrained Dynamics},
  year = {2024},
  howpublished = {\url{https://www.quentinwach.com/constrained-dynamics}},
  note = {Blog post},
  month = {Sep}
}
```

[^paper_jakab]: [Zoltán Jakab, _"Real-Time Rigid Body Simulation with Constraints", Proceedings of CESCG, 2021](https://cescg.org/wp-content/uploads/2021/03/Jakab-Real-Time-Rigid-Body-Simulation-with-Constraints-1.pdf)
[^ange_engine_vids]: [Ange The Great, _"Original Engine Simulator"_, https://www.youtube.com/watch?v=TtgS-b191V0&list=PLUahe1BHkKtW3ekopap0g-BxRMyk8UDU2](https://www.youtube.com/watch?v=TtgS-b191V0&list=PLUahe1BHkKtW3ekopap0g-BxRMyk8UDU2)
[^brashtop_phys_blog]: [Brash and Plucky, _"Constrained Dynamics IV"_, https://brashandplucky.com/2023/09/05/constrained-dynamics-iv.html](https://brashandplucky.com/2023/09/05/constrained-dynamics-iv.html)
[^voxagon_blog]: [Dennis Gustafsson's Homepage, https://voxagon.se/](https://voxagon.se/)
[^gamephys_book_mill]: Ian Millington, _"Game Physics Engine Developement"_
[^Witkin_constrained]: [Andrew Witkin, _"Constrained Dynamics"_, 1997](https://www.cs.cmu.edu/~baraff/sigcourse/notesf.pdf) 

