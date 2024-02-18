---
layout: post
mathjax: true
title:  "Dubin's Paths for Waveguide Routing"
description: "What does the perfect waveguide look like? Dubin's paths, already well known in robotics and control theory, turn out to be a simple and highly practical solution. This post explains why and how to implement them."
date:   2025-11-1 20:38:24 +0100
author: Quentin Wach
tags: ["physics", "photonics", "design", "routing"]
image: "/images/dubin/DubinAdvantage.PNG"
tag_search: true
---
Read the <a href="/pdfs/Nanoscale_2024_2_13_SA.pdf"><button class="PDFButton">PDF</button></a>.

_What does the perfect waveguide look like? Traditional waveguide interconnects lack efficiency and optimization, leading to suboptimal photonic integrated circuits (PICs). Addressing key concerns like minimizing internal and radiation losses, reducing cross-talk, and avoiding unnecessary crossings, I explored the concept of finding the shortest path between two points in a PIC given a minimum bending radius. Dubin's paths, already well known in robotics and control theory, emerged as a simple and highly practical solution._

<div class="tag_list"> 
    <div class="tag">photonic integrated circuits</div>
    <div class="tag">design automation</div>
    <div class="tag">robotics</div>
    <div class="tag">physics</div>
</div>

### 1 Introduction
I'll try to keep this short and not ramble too much. I just want to get this out there since I found it rather useful and can't believe it isn't yet standard.

When I started my work at the [Fraunhofer HHI](https://www.hhi.fraunhofer.de/), it became quickly obvious that the typical waveguide interconnects provided by libraries are not well behaved nor optimal as to improve the performance and compactness of the photonic integrated circuit. Most commonly we have simple straights, circular arcs, all sorts of splines, as well as Euler-bends, in short: They are all simple analytical functions. But then there are also splines that optimize themselves. Yet all of these are either simple building blocks that leave most of the work to the designer who has to plan out and specify every route, or behave extremely poorly and lead to overly wavey results that may even cross each other. 

So in my first two weeks there, I asked myself this question. We have to consider multiple things:

* As short as possible as to minimize internal losses.
* As straight and continuos as possible as to minimize radiation losses.
* As far away from other waveguides and structures as to minimize cross-talk.
* Does not cross other waveguides unless close to a 90° angle if absolutely necessary.

It became quickly obvious that trying to find an optimimum for all these design paramters is impossible unless we either weigh their importance using a complicated metric we have to justify, or make much harder contraints. 

Since it is common to have a fixed minimum bending radius for waveguides, it makes sense to translate this here.

I then boiled all of the considerations down to the single, I believe, most important question: "What is the shortest path between the pin a and pin b given a minimum bending radius?" or rather what is the shortest path between two 2D-vectors $$\vec{a}$$ and $$\vec{b}$$ given a minimum bending radius?

As it turns out, the answer is rather simple and long established in the field of robotics / control theory. **Dubin's paths!**

### 2 What are they?
Dubin's paths are named after Lester Dubin, who introduced them in the 1950s[^DubinPaper]. They refer to the shortest paths that a vehicle can take from one point to another while constrained to move at a specific maximum turning radius. These paths are thus commonly studied in the field of motion planning for vehicles, particularly in robotics and aerospace engineering.

Now, to boil things down, these paths simply connect circular arcs with straights which leaves us with a couple of characteristic Dubin's paths:
+ **LRL** (Left-Right-Left)
+ **RLR** (Right-Left-Right)
+ **LSL** (Left-Straight-Left)
+ **RSR** (Right-Straight-Right)
+ **LSR** (Left-Straight-Right)
+ **RSL** (Right-Straight-Left)

### 3 Math

### 4 Code

### 5 Results

### 6 Comparison
I have been using the Nazca library[^NazcaLib] which comes with several interconnects, including straights and circular arcs which are used often but very tedious and slow to work with alone. There are also s-bends as well as, for example, cobra splines which are used all the time since they are much easier to use!  In the figure below, a comparison between a dense array of Dubin's paths and such arrays using Nazcas s-bends and cobra splines are shown:

![sleep_figure_1](/images/dubin/DubinAdvantage.PNG)

As one can see, not only do other interconnects lead to overbending of the waveguides and thus a longer path and greater losses, they are also less reliable, predictable, often break the design rules to not violate the minimum bending radius as is indeed the case here, and even intersect each other! Meanwhile, the Dubin's paths behave extremely predictably. They clearly show the shortest path without unnecessary bends and they do not intersect each other which allows for much denser layouts than would be possible with the other interconnects. 

Again, the hours of headaches I personally avoided just by using Dubin's paths are insane. It is also simply much more enjoyable to use.

Anyway, that's my little tip for those working on photonic integrated circuit layouts. I hope it helps!

### Citing

If you found this work helpful for your own projects or research, please cite:
```Python
@article{
    author = {Quentin Wach},
    title = {Dubin's Paths for Waveguide Routing},
    year = {2023}
}
```
### References
[^DubinPaper]:
[^NazcaLib]: 