---
layout: post
mathjax: true
title:  "32-bit CPU & Instruction Set: Building a Computer from Scratch"
description: "A series of custom CPUs is designed from the bottom up, increasing complexity until comparable to modern CPUs. All the explanations, references, manuals, and schematics are found or linked to here."
date:   2028-2-15 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["physics", "photonics", "design", "routing", "gds"]
image: "/images/dubin/wikipedia_4.png"
tag_search: true
toc: true
toc_sticky: true
weight: 0
note: "Log & notes."
categories: "science-engineering"
progress: 0.02
---

As I learn to design and build a computer from the bottom up, I use the book **_"The Elements of Computing Systems Building a Modern Computer from First Principles"_ by Noam Nisan and Shimon Schocken** as my starting point, working through it chapter by chapter. (Though I have been skipping a lot of the first parts since I already have experience with boolean logic.) A rough overview of the design levels is shown in this picture.
<style>
    img[alt=overview] {float: left; width: 50%; border-radius:5px; margin-right: 10px; margin-bottom: 30px; margin-top: 5px;}
</style>
![overview](/images/cpu/overview.png)

#### Arithmetic Logic Unit