---
layout: post
mathjax: true
title:  "The Future of Interactive Multi-Physics Simulations"
date:   2025-02-12 20:38:24 +0100
author: Quentin Wach
tags: ["physics", "nanoscience"]
tag_search: true
---
_We explore the need for dedicated hardware for physics processing in modern gaming, especially for VR and spatial computing. It discusses the limitations of current graphics cards and proposes the use of dedicated hardware and AI techniques to enhance physics simulations. We outline a plan for developing a new physics processing unit, emphasizing the importance of defining system requirements, mathematical modeling, circuit implementation, and testing. The goal is to prioritize interactivity, speed, and scalability in physics simulations, aiming for immersive experiences akin to those seen in blockbuster movies like Avatar._

<div class="tag_list"> 
    <div class="tag">computational physics</div>
    <div class="tag">integrated circuit design</div>
    <div class="tag">ASIC</div>
    <div class="tag">analog computing</div>
    <div class="tag">artificial intelligence</div>
</div>

<!--![Avatar](/images/physics-processing-unit/title_header.png)
<center>Generative art of an analog circuit created with</center> -->

# 1 Introduction
A few decades ago, the first physics processing unit (PPU) was created[^1] and took the markets by storm[^2] [^3]. Gaming enthusiasts around the world bought it, plugged it into their computer just like any audio or graphics card, and used it to enable destructable environments, rag doll physics, and pretty particle, smoke and fluid simulations. Peak interactivity. But it did not last long. Soon, NVIDIA bought the company[^4] that made it and banished the technology to Tartarus may it never be seen again. Instead, we gained PhysX allowing for physics acceleration right on NVIDIA's graphics cards[^5].

I have been thinking about this for little over a year now and it is breaking my heart a bit. It feels like NVIDIA is to blame for the lack of physics in video games nowadays. Every game seems incredibly static. This is now slowly changing again as graphics cards are becoming more powerful and game engines focus more and more on including physics simulations once again. But the fact is, that back then, coding physics and using it to enhance the core game experience were difficult problems each and the overlap was very small. So typically, physics is only an add-on to enhance the visual appeal, the spectacle, but it isn't really necessary. I can't blame NVIDIA. (Funnily enough, GPUs started with the idea of accelerating the physics of light. In a sense, GPUs were born as specialized physics processing units.) But times have changed, too.

We are now entering a new age, the age of virtual reality. And as anyone who plays VR games knows, interactive physics is _key_! The same is true for Apple's spatial computing.

This makes fast multi-physics simulations instrumental to the success of VR. And more importantly, running these simulations on compact, mobile devices is key as well, since, with spatial computing, VR is about to cut its wires to external PCs as people go onto the streets, sitting in planes and caffees with their VR, AR, XR, or spatial computing goggles on.

# 2 What Is Possible?
When I saw Avatar 2 in 3D[^Avatar] in cinema, I had tears in my eyes starting with the first shot already. Maybe that's because I, a total nerd, rarely leave the confines of my apartement. But seeing this world and how beautiful it was and knowing that it was all generated inside a computer truly touched something. I hardly focused on the story my eyes constantly oogling the physics simulations shown in the movie. It felt more real than reality. I want that. I want every computer, every game, to be as real, as immersive, as interactive as this movie and the physics in it.


![Avatar](/images/physics-processing-unit/Avatar-720x340.jpg)
<center>Fig. 1: A shot from James Cameron's Avatar 2: The Way of Water.</center>


But this movie was made only possible with extensive research and giant super-computer clusters. Computational power and recources completely out of the scope of today's gaming systems.

But so if this is the goal, how do we get there?
My answers:

1. Dedicated hardware (once again)
2. Artificial intelligence

## 2.1 Dedicated Hardware
As mentioned before, there was a time where we did indeed have dedicated hardware, a PPU! Now, we are stuck with graphics cards. And while they are great for parallel computations in general, the last case is what bothers me: I wonder if graphics cards are not _too_ general.

>"[...] GPUs are built around a larger number of **longer latency, slower threads, and designed around texture and framebuffer data paths, and poor branching performance**; this distinguishes them from PPUs and Cell as being less well optimized for taking over game world simulation tasks[^WikiPPU].


Another huge problem with graphics cards is that it is notoriously difficult to write software which utilizes the parallel processing capabilities of them to the fullest. A lot of academic software is only scratching the surface, many do not even try and stick to writing their physics simulations for the CPU since performance rarely matters for academic research. The overlap of engineers who have the understanding of mathematics and phyiscs as well as the programming skills to write and optimize such a software is extremely small. Wrapping it all up so that others can use it for their research or their games is another skill unlikely to be found in those that mastered the former. 

## 2.2 Artificial Intelligence
AI is eating the world. Graphics cards are not enough and as such, hardware engineers are increasingly designing and integrating dedicated AI accelerator modules into their chips. I believe the same should be done for physics at least for certain applications as in VR. But the point I am trying to make here is that AI can also be used to solve physics problems quicker and augment the solutions to be more detailed and realistic, essentially upscaling the solutions.

The great advantage of general purpose graphics cards is that they are able to do both the AI inference as well as the physics solving on the same chip. Intuitively, it makes sense to assume that an AI-augmented physics simulation will thus be processed much more rapidly on such a GPU than having two seperate dedicated hardware accelerators, one for AI and one for physics simulations.


## Novel Computing
Quantum computing, optical or photonic computing... There are multiple new paradigmes on the rise threatening to replace traditional computing for certain, highly specific applications. Indeed, quantum computing seems extremely promising for solcing complex physical systems. Quantum computing is far away from proving its utility in practice though. On the other hand, photonic computing using photonic integrated circuits (PICs) have already proven their use for AI acceleration as well as high-speed binary computations far above the electronic 4-5 GHz limit! I wonder if graphics processing like ray-marching could not be done using dedeicated PICs.

## Game Plan
How would I go about this? Let me think... In order to create a new physics processing unit, 
* first, we must define our system requirements: What exactly does it need to be able to do? 
* Second, we must work out the mathematics to run the simulations we want. 
* Third, we must translate that math into either digitial or analog circuits. 
* Fourth, we test if those circuits can run our simulations by simulating them on the computer. 
* Fifth, we move to an FPGA to test the performance and functionality on actual hardware (assuming we chose normal electronics for the processor). 
* Sixth, we actually create the ASIC. 
* Seventh, we test the ASIC.

A challenge. For sure. Certainly for me since I have zero to none experience in the developement of electronics and certainly not processors, FPGAs, ASICS, and so on. While I am confident that I can work out or develop the mathematics for the physics simulations, translating them to an efficient computing architecture might pose a challenge. What I know for sure is that I do not want to fall back to a mere matrix multiplication or vector operation unit. If possible, I'd indeed even want to go as analog as I possibly can! Interactivitiy, speed, and scale are what is important not accuracy or repeatability!

## 5 Napkin Math
So let's try and get some rough estimates of what sort of calculations our physics processing unit needs to do, how many, and how quickly. We want solid-body physics, soft-body physics, and fluid dynamics.

Let's say, for now, that the goal is to achieve a frame-rate of 60 fps at full-HD pixel resolution.

### 5.1 Solidy Body Physics
Unreal Engine has been showcasing its adaptive meshing techniques in order to enable film-quality polygon counts in games. But this technique basically compresses the rendered polygons to one for every pixel. For 1080 x 980 pixel, that means we are rendering approx 1.000.000 polygons / frame. Now, let's assume that every polygon in the scene is a solid-body interacting with others, and we approximate every solid body as a tetrahedon as it is the simplest 3D geometry, then we have 4 million polygons to consider.

$$
\begin{equation}
    f(x) = \int_{-\infty}^{1} x^3 \; dx = \frac{1}{4} x^4 \bigg|_{-\infty}^{1} = 0-\frac{1}{4} = -\frac{1}{4}
\end{equation}
$$

### Applications In Robotics
Not only is AI software developing rapidly, in recent months, humanoid robotics has made several advances and several companies are now competing to bring humanoid robots to mass-production in order to replace workers in warehouses and manufacturing plants. Controlling a robot is a highly complex problem though and I can imagine an efficient and fast dedicated computational unit for physics may be of great help in many robotics applications, especially, if easy APIs can be accessed to run complex simulations.

```Python
import numpy as np

# natural constants

# simulation parameters

# define the integrator

# define the objects

# define all the constraints

# run the simulation
```

# Citing
If this post helped you in your own research, please cite it as
```Python
@article{WachQPPU2024,
    title = {"The Future of Interactive Multi-Physics Simulations"},
    author = {Quentin Wach},
    publisher = {WWW},
    date = {2024-2-13},
}
```

# References
[^1]:
[^2]:
[^3]:
[^Avatar]: [Wikipedia: James Cameron, _Avatar 2: The Way of Water (2022)_,  (Online), Accessed: Feb 13, 2024](https://en.wikipedia.org/wiki/Avatar:_The_Way_of_Water)
[^4]:
[^5]:
[^WikiPPU]: [Wikipedia, _Physics Processing Unit_, (Online), Accessed: Feb 13, 2024](https://en.wikipedia.org/wiki/Physics_processing_unit)