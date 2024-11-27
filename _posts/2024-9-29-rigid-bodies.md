---
layout: post
mathjax: true
title:  "Constrained Dynamics"
description: "Where we derive the math for rigid body physics, various constraints, and how to implement them with high accuracy and performance."
date:   2025-09-28 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["physics"]
tag_search: true
image:     ""
weight:
note: 
categories: "blog"
---
Physics simulations are abundant in the sciences, in movies, games, and engineering. Many of the problems to be solved have rigid and soft-body physics as the primary elements and most contain such bodies, at least in part, as they interact with other physics such as fluids.

## Introduction
Let's build and break some stuff. Let's solve the mathematics of the trebuchet. Let's simulate the collapse of bridges and houses. Let's simulate complex pulley systems, gears and clocks, and do so correctly!

I am quite the fan of the game Teardown and its maker Dennis Gustafsson[^voxagon_blog]. I've also long been jealous of _Ange the Great_ and his custom physics engines[^ange_engine_vids] to implement complex constrained physics systems. So some time ago, I went down the rabbit hole of the physics of constrained systems and discovered that barely any of it was ever even mentioned during my undergrad physics program. Nor are there any graduate courses that talk about such things.

While Ange explains the basic ideas and some of the mathematics of how to solve such systems and even links some sources[^Witkin_constrained], which others talk about as well[^brashtop_phys_blog]. Yet, they aren't quite as detailed as I would wish for.

So this is my take on it.

I will begin laying out the general approach. Then we will discuss various common methods to solve such a system of equations. Then we will learn how to define all the possible constraints to set up any constraint rigid body system we can think of.

## Starting Point: Analytical Mechanics
Much of the mathematics below is based on an article by Zoltán Jakab[^paper_jakab] since the derivation is more grounded in rigorous theoretical physics than argued for phenomenologically. We start with the Euler-Lagrange equation with additional constraints and derive the Newton-Euler equations of motion.

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

with $$m_n$$ the mass of the $$n$$-th rigid body and $$I_n$$ the moments of inertia about the center of mass.

### The Base Equations
The Newton-Euler Equations are then

$$\mathbf{F} = \hat{M} \cdot \mathbf{a} + \mathbf{G}.$$

$\mathbf{G}$ is the gyroscopic term in matrix form (often ignored). With the Lagrangian

$$\mathcal{L} = T(\dot{q_i}) - V(q_i),$$

note that $$V(q_i)$$ is only position-dependent, and the Euler-Lagrange Equation

$$
\frac{d}{dt} \left( \frac{\partial \mathcal{L}}{\partial \dot{q_i}} \right) - \frac{\partial \mathcal{L}}{\partial q_i} + \sum \lambda_k \frac{\partial f_k}{\partial q_i} = 0
$$

we plug $$\mathcal{L}$$ into the Euler-Lagrange equation

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

where $$\hat J$$ is the Jacobian matrix of the constraint function $$f$$, $$\lambda$$ is the vector of Lagrange multipliers, $$F$$ represented the inertial forces, $$N$$ are non-constraint forces (e.g. gravity), and $$C$$ are constraint forces. This resembles the Newton-Euler equation $$N + C = M \cdot a$$ and may also be called a "Continuous-Time Equation" which we will now need to discretize so we can solve it numerically for $$\lambda$$. We will do so by introducing the time-step $$h$$.

### Discretization Using Euler Integration
In discrete time-stepping, we use a simple explicit Euler scheme to update the velocity $$v$$:

$$
v_2 = v_1 + h \cdot a
$$

with $$v_2$$ the velocity at the next time step, $$v_1$$ the velocity at the current time step, and $$a$$ the acceleration, of course.

If we now take what we may call the "constraint equation"

$$
J v + b = 0
$$

with an introduced bias term $$b$$ (which could account for things like external forces e.g. a motor, drift correction, etc.) we can update it to be discrete:

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

and isolate the $$\lambda$$ term

$$
J \hat{M}^{-1} J^T \lambda = - \big[ J (v_1 + h \hat{M}^{-1} N) + b \big]
$$

which is an equation of the form

$$
\hat{A} \cdot \lambda = \vec{b}
$$

with $$\hat{A}$$ a matrix and $$\vec{b}$$ a vector. This is very important. The nature of $$\hat{A}$$ is especially important. More on that later when we discuss how to solve this equation. 

## Deriving & Implementing Constraints
For now, we still have to define what our system, should actually look like. A double pendulum? A ball in bowl? A catapult? A skyscraper? A piston engine? There are various constraints to be discussed which we will need to describe any arbitrary mechanical system. For detailed derivations of the constraints, I recommend Daniel Chappuis' _"Contraint Derivation for Rigid Body Simulation in 3D"_[^chappuis_constr_der] and the references[^Witkin_constrained][^brashtop_phys_blog].

### Contact and Friction
The general equations of motion for two rigid bodies

$$
a(t) = F_{\text{total}} / M = (F_{\text{ext}} + F_c) / M
$$

where $$\vec{a}(t)$$ is the acceleration vector, $$M$$ is the mass matrix, $$\vec{F}_{\text{total}}$$ is the total force, $$\vec{F}_{\text{ext}}$$ are external forces, and $$\vec{F}_c$$ are constraint forces, and $$F_c$$ are constraint forces.

A general constraint is defined as:

$$
C(s) = 0
$$

The time derivative of this constraint gives the velocity constraint:

$$
\dot{C}(s) = J \cdot \vec{v}(t) + b = 0
$$

where $$J$$ is the Jacobian matrix, $$v(t)$$ is the velocity vector, and $$b$$ is the bias velocity vector.

The constraint force is calculated as:

$$
F_c = J^T \lambda
$$

Where $$\lambda$$ is the Lagrange multiplier.

We solve for $$\lambda$$:

$$
\lambda' = -K^{-1}(J \cdot v'_i + b)
$$

with $$K = JM^{-1}J^T$$, $$v'_i = v_i + M^{-1}F_{\text{ext}} Δt$$, and $$\lambda' = \lambda Δt$$.

The penetration depth (constraint function) is:

$$
C_{\text{pen}}(s) = (\vec{p}_2 - \vec{p}_1) \cdot \vec{n}_1 \geq 0
$$

where $$p_1$$ and $$p_2$$ are contact points and $$n_1$$ is the contact normal.

The Jacobian for this constraint is:

$$
J_{\text{pen}} = [-\vec{n}_1^T  -(\vec{r}_1 \times \vec{n}_1)^T  \vec{n}_1^T  (\vec{r}_2 \times \vec{n}_1)^T]
$$

To use these constraints in a simulation:

1. Identify all constraints in the system.
2. For each constraint, compute its Jacobian $$J$$ and bias term $$b$$.
3. Solve for $$\lambda'$$ using the equation in step 4.
4. Calculate the constraint force $$F_c$$ or impulse $$P_c$$.
5. Update velocities and positions using:

$$
\begin{align*}
v_i+1 &= v_i + Δt M^{-1}(F_{\text{ext}} + F_c) \\
s_i+1 &= s_i + Δt S v_i+1
\end{align*}
$$

This process ensures that the constraints are satisfied at each time step, preventing penetration between bodies and simulating friction effects. The key idea is to use the constraint equations to compute forces that keep the bodies in a valid configuration while allowing realistic motion.

### Distance Joint
The distance joint, or point-to-point constraint, restricts the distance between two points on separate bodies, effectively creating a "rigid rod" between them. For two points, $$ \vec{p_1} $$ and $$ \vec{p_2} $$, the constraint function is given by:

$$
C(\vec{p_1}, \vec{p_2}) = |\vec{p_2} - \vec{p_1}| - d = 0
$$

where $$ d $$ is the desired distance between the points. Differentiating with respect to time gives us the velocity constraint:

$$
\dot{C} = \vec{J} \cdot \vec{v} = 0
$$

The Jacobian, $$ \vec{J} $$, for this constraint can be defined as:

$$
\vec{J} = \left[-\vec{n}, -(\vec{r}_1 \times \vec{n}), \vec{n}, (\vec{r}_2 \times \vec{n}) \right]
$$

where $$ \vec{n} = \frac{\vec{p}_2 - \vec{p}_1}{\| \vec{p}_2 - \vec{p}_1 \|} $$ is the normalized direction vector from $$ \vec{p}_1 $$ to $$ \vec{p}_2 $$, and $$ \vec{r}_1 $$, $$ \vec{r}_2 $$ are the distances from the center of mass to the points on each rigid body. Solving this constraint ensures the distance remains constant, simulating a fixed rod between the bodies.

### Slider Joint
The slider joint restricts relative motion between two bodies to a single linear axis, such as a piston in a cylinder. The constraint can be defined by ensuring that the relative velocity perpendicular to the slide direction is zero:

$$
C(\vec{p_1}, \vec{p_2}, \hat{d}) = (\vec{p_2} - \vec{p_1}) \times \hat{d} = 0
$$

where $$ \hat{d} $$ is the direction of allowed movement. Differentiating with respect to time gives us:

$$
\dot{C} = \vec{J} \cdot \vec{v} = 0
$$

The Jacobian, $$ \vec{J} $$, is computed by projecting velocities along and perpendicular to $$ \hat{d} $$, using:

$$
\vec{J} = \left[-\hat{d}, -(\vec{r_1} \times \hat{d}), \hat{d}, (\vec{r_2} \times \hat{d})\right]
$$

### Hinge Joint
A hinge joint allows rotation around a single axis but constrains any other relative translation or rotation. It effectively locks two points together but allows a degree of freedom in rotation about the hinge axis.

Let’s define the constraint function in terms of perpendicular directions $$ \hat{a} $$ and $$ \hat{b} $$:

$$
C(\vec{p_1}, \vec{p_2}, \hat{a}, \hat{b}) = (\vec{p_2} - \vec{p_1}) \cdot \hat{a} = 0, \quad (\vec{p_2} - \vec{p_1}) \cdot \hat{b} = 0
$$

This ensures that $$ \vec{p_1} $$ and $$ \vec{p_2} $$ remain aligned along the hinge axis. The Jacobians for this constraint involve projecting velocities perpendicular to the hinge direction to enforce constraint forces that prevent translation but allow rotation along the axis.

### Fixed Joint
The fixed joint restricts all degrees of freedom between two points, effectively making them a single rigid body. For two points on separate bodies, $$ \vec{p_1} $$ and $$\vec{p_2} $$, the constraint equations enforce both position and orientation:

$$
C(\vec{p_1}, \vec{p_2}) = \vec{p_2} - \vec{p_1} = 0
$$

Differentiating with respect to time, we get a velocity constraint:

$$
\dot{C} = \vec{J} \cdot \vec{v} = 0
$$

The Jacobian $$ \vec{J} $$ in this case encompasses both the translational and rotational constraints, effectively preventing any relative movement between $$ \vec{p_1} $$ and $$ \vec{p_2} $$.

---

In your simulation, implementing each constraint involves:

1. **Identifying Constraint Functions:** For each joint, define the constraint function \( C \) to describe the motion restrictions.
2. **Computing Jacobians:** Differentiate \( C \) with respect to positions and orientations to find the Jacobians.
3. **Solving for Lagrange Multipliers:** Using the system’s equations of motion, solve for \( \lambda \) values to enforce each constraint.
4. **Applying Constraint Forces:** Compute constraint forces using \( F_c = J^T \lambda \) and incorporate them into the simulation’s force calculations.
5. **Updating Motion:** Using constraint-corrected forces, update positions and velocities to ensure the bodies remain in valid configurations.

---





<!--
## Solving the System of Equations
All physics solvers come with certain pros and cons. Hence, for any non-trivial problem, we need to tailor the solver to our problem. 

My notes on [[Constrained Dynamics]] (should) mention that solving the system of equations for typically  highly sparse matrices... Imagine executing the standard methods for calculating the solution here. You'd evaluate a bunch of equations that should be zero anyway. Indeed, computers too are absolutely horrible at solving equations involving sparse matrices [citation needed]!

![[Pasted image 20240924100620.png]]
(This is a sparse matrix as shown in the #video https://www.youtube.com/watch?v=oulfRfqTxJA&list=PLUahe1BHkKtW3ekopap0g-BxRMyk8UDU2&index=8 about the Engine Simulator by Ange the Great.)

### Gaussian Elimination
Gaussian elimination is fast enough for small matrices and we all know it from our linear algebra classes. Yet it has a time complexity of $O(n^3)$.

### Conjugate Gradient Method
This method seems to be much more stable. Funnily enough, it is also faster! Why? Because we actually don't need to calculate the matrix. But... it kinda breaks??? (Ange talked about this here: https://www.youtube.com/watch?v=n5CIlrOMKiU&list=PLUahe1BHkKtW3ekopap0g-BxRMyk8UDU2&index=9)

### Position Based Dynamics
This method is very fast. It is also stable. Yet it is not very accurate.
paper: https://mmacklin.com/2017-EG-CourseNotes.pdf

### Gauss-Seidel Method
We need to compute with the entire matrix here.
But, we can solve the equations iteratively, approximating the correct solution with every iteration ever more closely. [This video](https://www.youtube.com/watch?v=oulfRfqTxJA&list=PLUahe1BHkKtW3ekopap0g-BxRMyk8UDU2&index=8 ) (again) talks about how it can be used to speed up such physics simulations. Typically, we initialize the lambda vector with random values and then iteratively update them until the error is small enough. But amazingly, we can also just use the previous solution in the time-series as the starting point in this process which should reduce how many iterations are needed quite significantly. [By how much?] 

The key problem with this method is that it is not guaranteed to always converge which can be extremely annoying. [Are there any solutions to this problem?]

## Concluding Thoughts
### SIMD Optimization of the Gauss-Seidel Method
The paper https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2782869/ explains how to parallelize this very much serial method using SIMD instructions with the purpose to utilize massively parallel computing using GPGPUs for example. Awesome idea! [I need to look into that.]

But again, the convergence and stability of this method is questionable.

### A Bunch of more amazing Gauss-Seidel Optimizations!
Short version: Instead of storing the entire matrix, we only store the non-zero values and don't do all the unnecessary multiplications by zero! We can expect an order of magnitude speed up here, possibly more as the system grows in complexity.

About sparse matrices:
https://en.wikipedia.org/wiki/Sparse_matrix

This is an amazing video. A MUST WATCH!
https://www.youtube.com/watch?v=P-WP1yMOkc4

-->







While written in a very non-academic style, I'd love to see you cite the writing below if it helped you in hopes that I might see who I helped and how. You can cite me either as **Quentin Wach, _"Constrained Dynamics"_, 2024** or using: 

<span class="sidenote-right">
```bibtex
@online{wach2024constrained,
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
[^chappuis_constr_der]: [Daniel Chappuis, _"Constraint Derivation for Rigid Body Simulation in 3D"_, 2011, https://danielchappuis.ch/download/ConstraintsDerivationRigidBody3D.pdf](https://danielchappuis.ch/download/ConstraintsDerivationRigidBody3D.pdf)
