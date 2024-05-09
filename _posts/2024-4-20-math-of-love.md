---
layout: post
mathjax: true
title:  "Equations of Love as Sexual Selection"
description: "I took Steven Strogatz' equations of love way too seriously, 
generalized them, and expanded them to a network of agents
all capable of loving or hating each other,
attracting or repulsing each other.
These nonlinear dynamics are fascinating."
date:   2026-02-26 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["mathematics"]
tag_search: true
image:          "/images/applied mechanics/Cover_Sims_2.png"
weight: 0
note:
categories: "science-engineering"
---

I took [**Steven Strogatz' equations of love**]() way too seriously, 
generalized them, and expanded them to a network of agents
all capable of loving or hating each other,
attracting or repulsing each other.
These nonlinear dynamics are fascinating.

We start with the simple case:

$$
\dot{R}(t) = \alpha_R \cdot J(t) + \beta_R \cdot R(t) \\
\dot{J}(t) = \alpha_J \cdot R(t) + \beta_J \cdot J(t) \\
$$

Yet, I wanted to actually try and module human psychology a bit more accurately. You can read my blog post about the dynamics and what we can learn from them [here](https://quentinwach.com/science_and_engineering). 

### 1. Competition & Noise
My original question was pretty much what would happen to couple in the presence of environmental noise and other love interests. But that question is rather trivial to answer. We can write the equations as

$$
\dot{R}(t) = \alpha_R \cdot J(t) + \beta_R \cdot R(t) + \gamma_R \cdot B(t) + \mathcal{N}(t) \\
\dot{J}(t) = \alpha_J \cdot R(t) + \beta_J \cdot J(t) + \gamma_J \cdot B(t) + \mathcal{N}(t)\\
\dot{B}(t) = \alpha_B \cdot B(t) + \beta_B \cdot R(t) + \gamma_B \cdot J(t) + \mathcal{N}(t)
$$

where $$B(t)$$ is Bob and $$\mathcal{N(t)}$$ is white noise. We can generalize this for $$n$$ agents to 

$$
\dot{A}_i(t) = \sum_i^n \Gamma_i \cdot A_i(t) + \mathcal{N}_i(t)
$$

assuming that the noise is different for every agent as well.

### 2. Recources & Survival
I then wondered how the dynamics depended on recources.
To answer that, we first have to attribute a function for why we love or hate someone.
**Let's make this a survival game.**

Every animal is born, becomes adult, ages, and dies. There are males and females. Males have sperm as a recource that recharges at the rate $$\mathcal{s}_i = \text{const.}$$ with an upper limit of $$S_i = \text{const.} \in \mathbb{R}$$ while females have a lifetime supply of eggs $$E_i = \text{const.} \in \mathbb{R}$$ that cannot be increased but only decreases over time at a rate $$e_i = \text{const.} \in \mathbb{R}$$ unless pregnant. Within this model, that makes female eggs the limited recource for the survival of the species. We extend our previous equation to

$$
\dot{A}_i(t, a, \Gamma_i) = \sum_i^n \Gamma_i(A_i(t), a) + \mathcal{N}_i(t) \\
$$

where $$\Gamma_i$$ now depends on the gender-specific recources of the agents depending on their age and other factors. In order to properly define $$\Gamma_i$$ we must thus first define these recources.

#### 2.1 Male Fertility
**Age-dependend maximum.** Males are assumed to have an absolute, normalized sperm count limit of $$S_i^{\text{max}} = 3$$, meaning, they can never have so much sperm as to impregnate three women within a short time frame. This upper limit peaks at a certain age $$a$$. For $$\sigma = 1\;$$year and $$\mu = \log(40)\;$$ years, $$a \approx 24\;$$ years.
This max. sperm count as depending on the age can be expressed as

$$
S_i^{\text{max}}(a) = S_i^{\text{max}} \cdot N_s \cdot e^{- ((\log(a) - \mu)/\sigma)^2 / (x \cdot \sigma \cdot \pi)}.
$$

where $$N_s$$ normalizes the exponential term alone such that the max. value equals one and $$\max(S_i^{\text{max}}(a)) = S_i^{max} = 3$$.

**Depletion & recovery.** Sex depletes the sperm count by one until it is zero. In that case, it takes two days to recover a single charge, assuming a linear recovery rate, or generally

$$
S_i(t,a) =
\begin{cases}
S_i^{max}(a) & \text{if} \quad S_i(t,a) = S_i^{max}(a),\\
S_i(t,a)  + (\frac{1}{6} \cdot S_i^{max}(a))/\;\text{day} & \text{if} \quad S_i(t,a) < S_i^{max}(a).
\end{cases}
$$

#### 2.2 Female Fertility
We model the count of available eggs ready for insemination as

$$
E_i(t,a) =
\begin{cases}
0 & \text{if} \quad a \leq 12 \; \text{years},\\
E_i^{max}(a)  - (\frac{1}{30} /\;\text{day})\cdot (a - 12 \cdot 365 \text{ days})& \text{if} \quad a > 12 \; \text{years}.
\end{cases}
$$

(Note that the simulation of this system is run with a time resolution of days and over a time span of multiple generations, $$\approx 100.000 \;$$days.)
Assuming that females run out of eggs at the age of 50 years and starting at 12 years, that's 38 $$\times$$ 12 eggs $$=$$ 456 eggs $$= E_i^{\text{max}}(a=0).$$

#### 2.3 
We may define it as

$$
\Gamma_i(A_i(t), a) = \begin{cases}
        & \text{if}
\end{cases}
$$


