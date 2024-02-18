---
layout: post
mathjax: true
title:  "Electrodynamics of Nanostructures"
date:   2024-02-11 20:38:24 +0100
author: Quentin Wach
categories: physics, nanoscience
---
_We explore the need for dedicated hardware for physics processing in modern gaming, especially for VR and spatial computing. It discusses the limitations of current graphics cards and proposes the use of dedicated hardware and AI techniques to enhance physics simulations. We outline a plan for developing a new physics processing unit, emphasizing the importance of defining system requirements, mathematical modeling, circuit implementation, and testing. The goal is to prioritize interactivity, speed, and scalability in physics simulations, aiming for immersive experiences akin to those seen in blockbuster movies like Avatar._

<div class="tag_list"> 
    <div class="tag">quantum transport</div>
    <div class="tag">charge-carrier dynamics</div>
    <div class="tag">THz</div>
    <div class="tag">nanoscience</div>
</div>

# Introduction
In recent decades, nanoscience and technology have become essential in fields of computation, communication, energy, and many more. Material science and engineering are essentially nanoengineering. And while scientists are now assembling materials almost atom by atom to create highly complex structure it the theoretical models, our understanding of what behaviour is to be expected, which guide these efforts are lagging behind.

Fundamentally, the elctron-dynamics or more generally, the charge-carrier dynamics, play a crucial role in properties like eletrical conductivity or light absorption or emission.

## Problems of Existing Models

## The Density Matrix
This post is based on research I did with Alexander Achstein and Michael Quick[^1] [^2] [^3].
We can write the Liouville-von Neumann equation like

$$
\begin{equation}
    \dot\rho_{ij}(t) = \underbrace{\frac{1}{i \hbar}[\hat H, \hat O]}_{\text{Unitary Dynamics}} + \underbrace{R_{ij}}_{\text{Relaxation and Dephasing}}
\end{equation}
$$

to describe the temporal evolution of the density matrix including the Hamiltonian $$\hat H$$, the observable $$\hat O$$ and an additional non-unitary part ment to describe the relation and dephasing phenomena seen in quantum systems $$R_{ij}$$. 

Boyd[^Boyd] and Rand[^Rand] ...


# Citing
If this post helped you in your own research, please cite it as
```Python
@article{WachQEoN2024,
    title = {"Electrodynamics of Nanostructures"},
    author = {Quentin Wach},
    publisher = {WWW},
    date = {2024},
}
```


# References
[^1]: [Michael T. Quick et al., _THz Response of Charge Carriers in Nanoparticles: Microscopic Master Equations Reveal an Unexplored Equilibration Current and Nonlinear Mobility Regimes_, Advanced Photonics Research, 2023](https://onlinelibrary.wiley.com/doi/full/10.1002/adpr.202200243)
[^2]: [Michael T. Quick and A. Achtstein, _Challenging Kubo-Greenwood Theory: Nonunitarian Dynamics Reshapes THz Conductivity and Transport in Nanosystems_, Journal of Physical Chemistry, 2023](https://onlinelibrary.wiley.com/doi/full/10.1002/adpr.202200243)
[^3]: Quentin Wach, _Pulsed THz-Photoconductivitiy in Semiconductor Nanorods_, Technische Universität Berlin, 2022
[^Boyd]: Boyd, ...
[^Rand]: Rand, _Lectures On Light_
