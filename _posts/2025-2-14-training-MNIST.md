---
layout: post
mathjax: true
title:  "Analog Electronic Artificial Neural Networks"
description: "As a proof of concept, a deep artificial neural network (DNN) is created, trained, and then reimplemented as an analog electronic circuit. The hardware is then tuned so that the performance of the digital original is matched. To do so, a Python library is developed which converts the DNN design into a analog hardware design using a hardware description language (HDL)."
date:   2025-02-14 20:38:24 +0100
author: ["Quentin Wach"]
tags: ["machine learning", "aritificial intelligence", "python", "analog computing", "electronics", "neural networks", "hardware design", "computer engineering"]
tag_search: true
image:          "/images/physics-processing-unit/quentinwach_A_modern_machine_brain_made_of_glass_metal_transist_c0e95e7c-154f-422d-b562-a1d5a2845fa7.png"
---

Read the <a href="/pdfs/Nanoscale_2024_2_13_SA.pdf"><button class="PDFButton">PDF</button></a>.

_As a proof of concept, a deep artificial neural network (DNN) is created, trained, and then reimplemented as an analog electronic circuit. The hardware is then tuned so that the performance of the digital original is matched. To do so, a Python library is developed which converts the DNN design into a analog hardware design using a hardware description language (HDL)._

<div class="tag_list"> 
    <div class="tag">machine learning</div>
    <div class="tag">artificial intelligence</div>
    <div class="tag">python</div>
    <div class="tag">analog computing</div>
    <div class="tag">electronics</div>
    <div class="tag">neural networks</div>
    <div class="tag">hardware design</div>
    <div class="tag">computer engineering</div>
</div>

## 1 Introduction
### Physics-Imposed Limitations

### Accelerators
As of now, GPUs are the way to go to train and run deep neural networks as they are by far the fastest, most common, available, and easy to use processors. All praise NVIDIA. Yet there are also ASICs like Google's TPUs created specifically to improve the performance just for neural networks. Indeed, they require less power while being similarly fast. Still, the fastest training is, weirdly, achieved with GPUs. Then there are FPGAs that similar to ASICs achieve a lower power consumption at similar performance. Both ASICs and FPGAs are less general though. - More importantly, all available processors either consume a lot of power or have low performance. Ideally, we would like to get 100 OPS for less than 2 Watt, similarly to the brain.

I believe part of the solution are photonics as a way to speed up data transmission and bandwidth. But computation is extremely difficult and it will take much more time until photonic computers enter the competition in this particular field. We can use analog electronics though as well which, while less accurate, achieve incredible power-efficiency at high speeds! The key challenge here is thus dealing with noise and errors especially as we scale up the analog electronic circuit size. 

I can't seem to find much information on this topic online nor in books. So I will hack this together myself.

### Digital vs Analog
Most accelerators as of now still use digital signals to ensure accuracy and direct compatibility with existing technologies as the conversion from digital to analog and analog to digital is a science and art in itself. This leaves a wide opening to try and play with analog approaches though.

## Analog Computing
### Why Analog Circuits?
Nowadays, most people don't study analog computing.

Yet, we live in an analog world! And so, in order to do digital computing, we need to constantly convert from analog to digital and back, a very challenging task that some people make a living from just doing this alone! The reason digital computers are everywhere is because of their precision. They are reliable. They are therefore also easily scalable because new components do not introduce more and more errors. Hence why we now have over a hundred-billion transistors within our modern processors only a few cm in diameter. This is much more challenging to do with analog circuits. Note that quantum computing and photonic computing are predominately analog computing as well! 

The great disadvantage with digital computing is that it requires a clock which can only operate at a very limited speed that hasn't increased in recent decades and more importantly, digital circuits are extremely computation heavy and so consume a lot of energy.

Yet, for example, in analog computing using a memristors, matrix multiplication is almost trivial to do and done in a single shot at an extremely low energy consumption!

### Operational Amplifier as a Black Box
The typical operational amplifier has two inputs $$V_{\text{in\pm}}$$ and one output $$V_{\text{out}}$$. Then

$$
V_{\text{out}} = A_0 \cdot (V_{\text{in+}} - V_{\text{in+}}).
$$

So what the op-amp cares about is the difference between the applied input voltages.
For the ideal case, we assume that the impedances are $$Z_{\text{in}} = \infty$$ and $$Z_{\text{out}} = 0$$ for the ideal op-amp. Besides this we want to run the operations at high speed and so we desire a bandwidth $$BW = \infty$$ and a slew rate (the response rate) equaulling infinity. The output swing is supposed to be infinity as well. And finally, the gain. Sometimes it is desired to be infinity but it is actually depending on the definition. What do we mean by "ideal amplifier"? Here, we will wish it to be infinity as well, though. None of these goals/ideals can be achieved of course. But these are the goals.

[WebLink about OpAmps](https://chem.libretexts.org/Bookshelves/Analytical_Chemistry/Instrumental_Analysis_(LibreTexts)/03%3A_Operational_Amplifiers_in_Chemical_Instrumentation_(TBD)/3.04%3A_Application_of_Operational_Amplifiers_to_Mathematical_Operations)

The increase in computation! (Also compare with the phoenix project paper!)
https://www.visualcapitalist.com/cp/charted-history-exponential-growth-in-ai-computation/
Better data:
https://arxiv.org/pdf/2202.05924.pdf
Costs of training: 
https://spectrum.ieee.org/state-of-ai-2023

https://ocw.mit.edu/courses/6-071j-introduction-to-electronics-signals-and-measurement-spring-2006/5bc88e4af14bc9c72e63f48cd2a44613_23_op_amps2.pdf

https://arxiv.org/pdf/2107.06283.pdf

https://www.analog.com/media/en/training-seminars/tutorials/MT-079.pdf

https://medium.com/@adi.fu7/ai-accelerators-part-i-intro-822c2cdb4ca4

https://www.youtube.com/watch?v=Qgjawf20v7Y

https://www.youtube.com/watch?v=kbVqTMy8HMg

https://www.youtube.com/watch?v=RTtpUi-gQOg

https://www.youtube.com/watch?v=VQoyypYTz2U

Neural Networks on FPGAs:
https://www.youtube.com/@marcowinzker3682

Still to watch:
https://www.youtube.com/watch?v=brhOo-_7NS4

https://ars.copernicus.org/articles/19/105/2021/

https://www.youtube.com/watch?v=VWn6Ixh2eDg

https://www.youtube.com/watch?v=VWn6Ixh2eDg

https://www.youtube.com/watch?v=GVsUOuSjvcg&t=898s


Brain inspired Computing Nature Paper: FUNDAMENTAL!
https://www.nature.com/articles/s41467-019-12521-x

Von-Neumann Computing: Super important Nature paper, too!
https://www.nature.com/collections/dhdjceebhg

Still watch:
https://www.youtube.com/watch?v=EwueqdgIvq4

First full analog chip for machine learning:
https://www.aspinity.com/aml100
Yet it is mostly aimed at IOT applications!
How is it programmable? Field programmable? Is it an analog FPGA or smth?!

MUST READ FOR ELECTRONICS!
https://github.com/kitspace/awesome-electronics

Why are OPAMPS so expensive?
https://open.spotify.com/intl-de/track/164VgxTozx99XCinCB9ITR?si=d850164a39d54909

Why are there so many fucking different OPAMS?
See the blog on my HHI laptop.

Why people don't think about analog computing. Yet it is everywhere!
https://electronics.stackexchange.com/questions/595199/what-is-the-actual-niche-for-operational-amplifiers-these-days


### Analog Electronic Artificial Neuron
It is actually extremely fascinating to think about spiking neural networks but given that these are as of now very uncommon
in state-of-the-art (SOTA) AIs, let's focus on how we can build a simple perceptron-like artificial neural with analog electronics.


I wanted to keep this first experiment under a budget of 50€ because I am broke as hell. Most opamps sadly cost around $30ct though! But not all. We can use a LM258DRG4 by Texas Instruments which only costs $0.072 / piece (https://www.ti.com/product/LM258/part-details/LM258DRG4?HQS=ocb-tistore-invf-invftransact-invf-store-octopart-wwe found on https://octopart.com/search?category_id=4252&start=790). If we have 300 opamps that's less than 25€.




## Dense Neural Network
We can recognize handwritten numbers using deep neural networks[^1] quite easily using convolutional layers[^2] but I will focus only on densily connected neurons for now. The dataset commonly used for this task is the famous _MNIST_[^3] dataset. All of our code will be written in Python[^Python]. Let's begin with importing some libraries.

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


### Error Discussion



### References
[^1]: A
[^2]: B
[^3]: C
[^Python]: 
