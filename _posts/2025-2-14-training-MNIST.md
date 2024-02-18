---
layout: post
mathjax: true
title:  "Analog Electronic Neural Networks"
date:   2025-02-14 20:38:24 +0100
author: Quentin Wach
tags: ["machine learning", "aritificial intelligence", "python", "analog computing", "electronics", "neural networks"]
tag_search: true
---

<a href="/pdfs/Nanoscale_2024_2_13_SA.pdf"><button class="PDFButton">PDF</button></a>
<a href=""><button class="PDFButton">Tweet</button></a>

As a proof of concept, we will
1. create and train a basic ANN, then
2. reimplement the ANN into an analog electronic circuit with fixed weights and tune it so that the performance is matched.

## Deep Convolutional Neural Network
We can recognize handwritten numbers using deep neural networks[^1] quite easily using convolutional layers[^2]. The dataset commonly used for this task is the famous _MNIST_[^3] dataset. All of our code will be written in Python[^Python]. Let's begin with importing some libraries.

```Python
import numpy as np
import PyTorch as torch
import matplitlib.pyplot as plt
```

We then define the architecture of our network:
```Python
# input layer

# hidden layers

# output layer

```

## Analog Computing
### Why Analog Circuits?
Nowadays, most people don't study analog computing.

Yet, we live in an analog world! And so, in order to do digitial computing, we need to constantly convert from analog to digitial and back, a very challenging task that some people make a living from just doing this alone! The reason digital computers are everywhere is because of their precision. They are reliable. They are therefore also easily scalable because new components do not introduce more and more errors. Hence why we now have over a hundred-billion transisitors within our modern processors only a few cm in diameter. This is much more challenging to do with analog circuits. Note that quantum computing and photonic computing are predominately analog computing as well! 

The great disdvantage with digital computing is that it requires a clock which can only operate at a very limited speed that hasn't increased in recent decades and more importantly, digital circuits are extremely computation heavy and so consume a lot of energy.

Yet, for example, in analog computing using a memristors, matrix multiplication is almost trivial to do and done in a single shot at an extremely low energy consumption!

### Operational Amplifier as a Black Box
The typical operational amplifier has two inputs $$V_{\text{in\pm}}$$ and one output $$V_{\text{out}}$$. Then

$$
V_{\text{out}} = A_0 \cdot (V_{\text{in+}} - V_{\text{in+}}).
$$

So what the op-amp cares about is the difference between the applied input voltages.
For the ideal case, we assume that the impedances are $$Z_{\text{in}} = \infty$$ and $$Z_{\text{out}} = 0$$ for the ideal op-amp. Besides this we want to run the operations at high speed and so we desire a bandwidth $$BW = \infty$$ and a slew rate (the response rate) equaulling infinity. The output swing is supposed to be infinity as well. And finally, the gain. Sometimes it is desired to be infinity but it is actually depending on the definition. What do we mean by "ideal amplifier"? Here, we will wish it to be infinity as well, though. None of these goals/ideals can be achieved of course. But these are the goals.

[WebLink about OpAmps](https://chem.libretexts.org/Bookshelves/Analytical_Chemistry/Instrumental_Analysis_(LibreTexts)/03%3A_Operational_Amplifiers_in_Chemical_Instrumentation_(TBD)/3.04%3A_Application_of_Operational_Amplifiers_to_Mathematical_Operations)

chrome-extension://oemmndcbldboiebfnladdacbdfmadadm/https://ocw.mit.edu/courses/6-071j-introduction-to-electronics-signals-and-measurement-spring-2006/5bc88e4af14bc9c72e63f48cd2a44613_23_op_amps2.pdf

chrome-extension://oemmndcbldboiebfnladdacbdfmadadm/https://www.analog.com/media/en/training-seminars/tutorials/MT-079.pdf

https://www.youtube.com/watch?v=kbVqTMy8HMg


### References
[^1]: A
[^2]: B
[^3]: C
[^Python]: 
