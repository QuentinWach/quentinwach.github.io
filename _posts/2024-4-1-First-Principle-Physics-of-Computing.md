---
layout: post
mathjax: true
title:  "First Principle Physics of Computing"
description: "Moore's law is both dead and alive and I here I want to clarify exactly how. Modern computers are based on incredibly simple ideas that we were able to scale up and optimize rapidly over the past 70 years. But we are at a point of transition to entirely new architectures, materials, and physics. This post is dedicated to answer the question of what the limits of computation are in principle, where we are today, what new computers offer as a solution, and what I believe is the future in the short and long-term."
date:   2026-04-10 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["machine learning", "aritificial intelligence", "python", "analog computing", "electronics", "neural networks", "hardware design", "computer engineering"]
tag_search: true
image:          "/images/AI_acc_comparison_QW_animated_WTtitle.gif"
weight: 6
note: 
categories: "science-engineering"
---



# 2. Landau Limit for Energy Consumption

We lose energy because we increase entropy of the system. And we increase the entropy of the system because with every logic operation we lose information. Modern gates are not reversible. But there are ways around this.

## 2.1 Solutions

**Analog computing**. One way is to _simply_ reduce the amount of bits we use to do our computation but instead compute with analog signals. The improvement comes from there not being a necessity for logic gates which leak information. Rather, the signal is reshaped by the computational process.

**Reversible digital computing**. We could also redesign our digital gates to be reversible, meaning, we can literally revert the computation we did to get from the solution or function of something back to the input. This makes computation bijective [I believe. Right? What is it currently?].

**Reversible analog computing**. We already talked

**Qunatum computing**. 