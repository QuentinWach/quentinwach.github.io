---
layout: post
mathjax: true
title:  "Constrained Multi-Body Physics Engine in C++: Theory & Implementation"
description: "Introducing my book _Applied Mechanics Tutorials_, within a short 45 min read, I give a first taste of C++ as a programming language and explain the fundamentals of contrained multi-body physics with all the mathematics needed to get started."
date:   2026-02-26 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["physics"]
tag_search: true
image:          "/images/applied mechanics/Cover_Sims_2.png"
weight: 0
note:
categories: "science-engineering"
---
<span class="sidenote-right">
    If you learned something reading this and want to go start solving and simulating complex mechanical systems yourself, you can go and buy my book with 100+ examples and indepth explanations on Amazon: **Tutorials On Applied Mechanics**.
    <button>$4.99 on Amazon</button>
    <style>
        img[alt=book] { float: right; width: 100%; border-radius:5px; margin-left: 0px;, margin-bottom: 10px; margin-top: 10px; box-shadow: 0px 0px 4px 2px #063970;}
    </style>
    ![book](/images/applied%20mechanics/Cover_Sims_2.png)
</span>
# 1. Introduction
Modern physics classes in classical (and relativistic) mechanics do the field a monumental disservice. Solid bodies are maybe discussed within 1-2 weeks. Fluid mechanics is hardly even mentioned. The most complicated problems we solve have maybe two balls, a bowl and some springs... What about catapults, bridges, skyscrapers, ships, clocks, cars, colliding, crumbling, folding, and exploding structures?

If, like me, you want to understand the world so you may recreate and creatively play with your own little universe as you wish, this post, I hope, is the introduction you need.

# 2. Theory
The fundamental challenge of multi-body physics are collisions as the mathematics can only describe continuous motion of a fully described system. In multi-body physics, every body not interacting with another is a seperate system though. And once bodies collide, they suddenly become part of a new system only to split again into seperate systems, perturbed by this single event. I like to think of it as a bifurcation. [Does that make sense?]

Describing such systems fully analytically is impossible.

For example, in the case of a bouncing ball, this means that every time the ball hits the ground, the Lagrangian describing the ball becomes invalid and a new one has to be formulated which described both the ball as well as the ground as long as they are interacting with each other. All of that becomes rather complicated very quickly. A trick we can use is to simply flip / mirror the velocity vector of the ball once it collides so it bounces back. We may add some factor to mimic a loss of energy as well. Sadly, we must get used to such tricks as we implement our physics simulation.

Nonetheless, my goal here is to formulate the mathematics more or less rigorously as far as we can go before we start hacking away to make it work in practice. 
<span class="sidenote-right">
    Of course, while I hope that it is possible for anyone willing to put in the time and effort to understand all of which I will be talking about here, I do recommend to freshen up on analysis, linear algebra, and classical mechanics if you have trouble following. Ideally, you have already used Lagrangians and Hamiltonians to solve some physics problems because this short guide will not go into any depth explaining these concepts and how to apply them. For that I would recommend [] [] [].
</span>

### 2.1 Newtonian Mechanics


There are no constraints we can impose on our dynamics in Newtonian mechanics but rather we have to find all the forces that act upon our system of interest and add them up. Yet, often we don't know what these forces are exactly!

### 2.2 Lagrangian Mechanics
This problem is often remedeed with Lagrangian mechanics. The idea is that every symmetry leads to a conserved parameters, a constant in the system. (See Noether's Theorem.) How can we exploit this? By redifining our variables such that they exploit the geometry of the system. Is it a ball swining on a rope? Then the ball can always only move on a circle! That's a symmetry. A constraint that allows us to then kick out the, in this case, distance variable of the ball to the end of the stick around which the ball swings.


<!-- 
COLORS
https://latexcolor.com/
======
RED:    #BE0032
BLUE:   #007FFF
GREEN:
ORANGE:
-->

The Euler-Lagrange equation with the Lagrange function $$\mathcal{L}(q, \dot q)$$ for generalized coordinates $$q(t)$$ without constraints is

$$
\begin{equation}
\color{#BE0032}{\underbrace{\frac{d}{dt} \frac{d \mathcal{L}}{d \dot q}}_{\text{Force}}} - \color{standard}{\underbrace{\frac{d \mathcal{L}}{dq}}_{\text{Momentum}}}  = 0.
\end{equation}
$$

Equivalent to Newton's laws, the acceleration of an object depends on the forces acting upon it. Having generalized coordinates allows us to exploit symmetries of the system though making most problems that would be quite difficult to solve using Newton's approach often trivial.

### 2.3 Constrained Lagrangian Mechanics

# 3. Implementation

```c++
int a = 0

for i in 3 {
    print("Hello World!")
}
```






# 4. Results






# 5. Conclusion


<span class="sidenote-right">
    A question I have long been asking myself to what degree it may make sense to build a **_physics processing unit_** (PPU) and if we can do so using more exotic computing paradigms to solve some of science's largest challenges. After all, numerical simulations and parallelizing numerical simulations is an incredibly ardeous task. And I am a big fan of analog computing. I'll likely explore this more in the future. _(April 18, 2024)_
</span>