---
layout: post
mathjax: true
title:  "An Introduction to the Density Matrix in Quantum Mechanics"
description: "An explanation of density matrices and the Lioville-von Neumann equation as an introduction to the theory I developed for my B.Sc. thesis _\"Pulsed THz-Photonductivity in Semiconductor Nanorods\"_."
date:   2025-6-3 20:38:24 +0100
author: ["Quentin Wach"]
tags: ["physics", "optics", "THz spectroscopy", "thesis", "density matrix", "quantum mechanics", "semiconductors", "nanoscience"]
image: "/images/a.png"
tag_search: true
categories: "science-engineering"
---

That abstract is from my B.Sc. thesis (which isn't publicly available) reads:
> **Abstract.** _The first quantum mechanical model of conductivity based on the quantum master equations is developed and used to model the linear
response to pulsed THz perturbation. It gives an explanation
to the non-Drude-like behavior in the nanoregime and shows
Drude-like models to be a limiting case as materials approach a
bulk structure. It is shown that chirp as well as pulse duration affect
the frequency-window, that can be probed theoretically. The
theory is expanded to consider the Fermi-Dirac statistic as well
as N-level systems and the influence of the domain size, temperature,
dephasing and relaxation mechanisms are discussed in detail.
The theory fully explains the oscillations in the THz spectrum of
CdSe semiconductor nanorods. Yet, it is not limited to it but
general enough to be adapted to different kinds of materials and
geometries. It can be expanded further to also consider non-linear
effects as it is beyond the need of analytical solutions._

<div class="tag_list"> 
    <div class="tag">physics</div>
    <div class="tag">optics</div>
    <div class="tag">THz spectroscopy</div>
    <div class="tag">thesis</div>
    <div class="tag">density matrix</div>
    <div class="tag">quantum mechanics</div>
    <div class="tag">semiconductors</div>
    <div class="tag">nanoscience</div>
</div>


Reading my own abstract again, I am cringing to be honest. I was really proud of this work. But I encourage you to read **[Michael T. Quick's PhD thesis _Nonlinear and Dynamic Properties of Low-Dimensional Semiconductors_](https://doi.org/10.14279/depositonce-19140)** instead.  Still, a little bit of background:

When Michael Quick, Alexander Achstein and I met, they had just realized that current theories of the charge carrier mobility (e.g. the electric current) in nanostructures as probed by THz spectroscopy are rather inadequate given their classical nature and the made approximations. Thus, a first approach was made to describe the systems quantum mechanically yet still only assuming periodic perturbations. So as part of my B.Sc. thesis, we decided that I would extend his theory to the typical Gaussian pulses as they are actually used in experiments. Yet, a long chain of problems followed and it became evident that a much more sophisticated theory had to be developed. The results were parametric master equations for the charge carrier dynamics that sparked a series of papers from this research group of which I am naturally quite proud.

Aside from the previous papers written by Michael at that point, two textbooks were incredibly useful to me. Those were
+ **Nonlinear Optics by Robert W. Boyd** and
+ **[Lectures on Light: Nonlinear and Quantum Optics using the Density Matrix by Stephen C. Rand](https://doi.org/10.1093/acprof:oso/9780198757450.001.0001)**. 

Truly though, Michael's thesis is the best introduction to this specific subject. Apart from that, I recommend our paper which directly built on my thesis **[THz Response of Charge Carriers in Nanoparticles](https://doi.org/10.1002/adpr.202200243)** published in _Advanced Photonics Research_.