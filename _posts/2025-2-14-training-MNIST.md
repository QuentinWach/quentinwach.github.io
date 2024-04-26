---
layout: redirect
mathjax: true
title:  "Analog Electronic Artificial Neural Network for Extreme Energy-Efficient Inference"
description: "A dense artificial neural network is trained and then converted to an analog electronic circuit simulated with SPICE using Python. While a fully analog implementation of a neural network shows great promise in terms of energy efficiency and speed, a hybrid approach is necessary to make it programmable. This is an introduction. As such, I also discuss the advantages and problems of analog computing. (BM.1, the first version, is promising. BM.2 will be an 130 nm IC design. Work in progress.)"
date:   2024-02-26 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["machine learning", "aritificial intelligence", "python", "analog computing", "electronics", "neural networks", "hardware design", "computer engineering"]
tag_search: true
image:          "/images/physics-processing-unit/machine_brain_2.png"
weight: 15
note: "Releasing the first update soon. (Read the previous post.)"
redirect: "/science_and_engineering"
categories: "science-engineering"
progress: 0.3
---


+ Convert dense neural network in PyTorch to analog electric circuit based on op-amps.
+ Implement non-linear activation functions as op-amp based neural network with linear activation functions.
+ Discussion of the Landauer limit: In order to increase compute / energy beyond the limit, we must either make computation reversible or reduce the number of bits used. One way to reduce the number of bits is to simply go partially or even fully analog. Or we can stick to digital and make the logic reversible, meaning, no bits are wasted. Correct?



<!-- IMAGE: "/images/physics-processing-unit/quentinwach_A_modern_machine_brain_made_of_glass_metal_transist_c0e95e7c-154f-422d-b562-a1d5a2845fa7.png" -->
<!-- Challenges of Analog AI Accelerators -->
<!-- Read the <a href="/pdfs/Nanoscale_2024_2_13_SA.pdf"><button class="PDFButton">PDF</button></a>. -->
Try the <a href="https://github.com/QuentinWach/QuentinWach/blob/master/README.md"><button class="PDFButton">Code on GitHub</button></a>.
<span class="sidenote-left">
This rather laborious post is meant to be somewhat of a starting point and reference for me to point to when friends with other interests and expertise want to know what I have been up to. At the same time, I am just starting to figure a lot of things out as well. I think this whole topic is not only awesome but important to at least think about.
</span>
_A deep artificial neural network (DNN) is trained and then reimplemented as an analog electronic circuit simulated with Python. The Python library is developed to converts the DNN design into an analog hardware design and simulate its operation. That is because an actual physical implementation is extremely costly due to the high cost of the individual components, notably the operational amplifiers, digital to analog converters and digital potentiometers. While a fully analog implementation of a neural network shows great promise in terms of energy efficiency and potentially speed, scaling this technology is not only challenging due to accumulating inaccuracies but also due to the high component costs. (10 TFLOPS at 4 W.)_
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
<style>
    img[alt=Board] {float: left; width: 100%; border-radius:5px; margin-right: 10px; margin-bottom: 30px; margin-top: 5px;}
</style>
![Board](/images/mem_analog_2024.png)

<span class="sidenote-left">
    <style>
        img[alt=me] {float: left; width: 100%; border-radius:5px; margin-right: 10px; margin-bottom: 30px; margin-top: 5px;}
    </style>
    ![me](/images/memes/floating_me.webp)
    Many thanks for reading!
</span>


<!--
Work through the following articles:
+ https://openaccess.thecvf.com/content/WACV2023W/WVAQ/papers/Ornhag_Accelerating_AI_Using_Next-Generation_Hardware_Possibilities_and_Challenges_With_Analog_WACVW_2023_paper.pdf
+ https://dl.acm.org/doi/pdf/10.1145/3453688.3461746?casa_token=4grhyhx2cCsAAAAA:Ho4pkCjh2oT-lwe99qegHoQLMOscAuKZ6KNCkipYP1CapWV4gvF2y8mEVAuZ7wG3zNNJA6J_v6ZFSA
+ https://www.sciencedirect.com/science/article/pii/S2095809921003349
+ https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9864008&casa_token=ZKjaCrd4dj8AAAAA:4aMxRshEMCS2yJC1LBm9QFHq50gyIRrWsNaqg89gCeY8RD1qUCu1vxMCrvW3-FrThMoYq8jRB0c&tag=1
+ https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9180545&casa_token=0XZ9QgOkFt4AAAAA:N7a31G75sAtUAwO2a6z3ID-R7GIz-DFKT15B1pv6XgM6aRNUR2caaT5TB_wVYJmIyHZKMeuK5f0
-->

>"People who are really serious about software should make their own hardware." Alan Kay [^AKayHard]


The purpose of this project is to implement a neural network capable of classifying MNIST nunbers at competitive accuracies
as an analog electronic circuit. As such we will:

1. Build and train a dense neural network in Keras.
2. Convert that model into a SPICE netlist with analog modules.
3. Simulate the analog electronic ANN with PySPICE using NGSpice as backend.
4. Discuss the results of the simulations compared to digital and other analog approaches for AI acceleration.
5. Discuss issues, limitations, and desirable features.
6. The general context of analog VLSI design, the next step of layout engineering using tools like magic, the Sky130 PDK and multi-wafer projects (MWPs) to produce an actual IC.



## 1 Introduction

### Compute Performance
>"You're trying to scale compute flops.
I'm trying to get rid of flops entirely.
We are not the same." Guillaume Verdon (aka Beff Jezos) [^TweetBeffJezos]

Let us say that every mathematical operation (OP) is equivalent to a floating point operation (FLOP). Then we can simply look at the schematic of analog neural network and count the number of operators or rather elements that are operated on in one feedforward pass. We then measure or calculate how much time the network would require to do this calculation. This gives us:
<span class="sidenote-right">
    At least that is my intution but it might very well be that OPs and FLOPs really can't be compared this directly.
</span>

$$
\begin{equation}
    500.000~\text{FLOP} / 1~\mu\text{s}\\ = 500.000 \times 10^{6}~\text{FLOPS}\\= 5 \times 10^{11}~\text{FLOPS}\\ = 0.5 \times \text{TFLOPS} 
\end{equation}
$$



### Energy Consumption
At the same time, we can calculate how much $$\text{W}$$ is consumed for that pass.

### Compute in the Age of AI

#### What is Compute? 
>"The base metric is becoming compute. Not money." Harrison Kinsley (aka Sentdex) [^ComputeNotMoney1]

_"Compute"_ or computing is simply a general term to describe how much computational power is available. So it is a measure of how powerful a computer is [^WikiCompute]. Today's GPUs reach several TFLOPs (Tera-FLOP) with a FLOP being a _"floating point operation"_. It has to be considered though that these can be 64-, 32-, 16-, 8-, or even just 4-bit operations! Nonetheless, 1 TFLOP = $$1\cdot10^{12}$$ FLOP. The question is now how many operations can be done per second as well what KIND of operations. Multiplication? Addition? Some functional transformation?
<style>
    img[alt=centerAI] { float: right; width: 100%; border-radius:5px; margin-left: 10px;, margin-bottom: 10px; margin-top: 10px;}
</style>
![centerAI](/images/AI_compute.png)
<span style="font-size: 14px;">
    The amount of compute required to train (a) neural network and do inference (b) after training.
    This figure was created by myself but the data was compiled by Jaime Sevilla et al. [^AIDemand_Data_1] [^AIDemand_Data_2].
</span>

#### The Arms Race of Training AIs


#### Do Not Underestimate the Market and Importance of Inference
Contrary to training, the compute for inference has hardly grown in comparison. That is because we want the inference to be fast and cheap in order for it to be practical. There can't be a seconds of delay for the self-driving car. We don't want our LLMs to spend hours computing an hour for our question and burn the energy of a small town for it. So with traditional hardware we are quite limited here and models are optimized to work within these boundaries. Imagine what we could do with better dedicated hardware though! Imagine LLMs would respond instantly and run locally on your phone. This will be necessary for robots especially. So while inference does not seem like a growth market at first glance, the demand is absolutely there.
<span class="sidenote-right">
    <style>
        img[alt=NAchip] {float: right; width: 100%; border-radius:5px; margin-left: 10px; margin-bottom: 10px; margin-top: 10px;}
    </style>
    In fact, the North American AI chipset market is growing much fast for edge compute (which is essentially infernce) compared to cloud compute (mostly training) [^NAChipMarket1].
    ![NAchip](/images/NA_AI_chipmarket.png)
    In a live stream, George Hotz mockingly said:
    _"All those fucks are trying to make edge AI. [...] Look! The AI inference market is bigger than the AI training market! So we should all go for the inference market! It's way easier! [...] Easier and bigger! [...] There are a hundred little fucks who make inference chips that no one really wants and only one who is making training chips (NVIDIA)."_ [^GHotz_InferenceMarket]
    <style>
        img[alt=H100Buyers] {float: right; width: 100%; border-radius:5px; margin-left: 10px; margin-bottom: 10px; margin-top: 10px;}
    </style>
    ![H100Buyers](/images/H100_buyers.png)
    _Estimated 2023 H100 shipments by end customer as reported by Omida Research [^OmidaH100Shipments]._
</span>



### Energy Consumption

My own figure based on this data.



A figure from the paper showing how much it currently costs even to do just inference.
A. S. Luccioni et al. recently compared several machine learning tasks in terms of their energy consumption and nicely showed that image generation is orders of magnitudes more costly during inference compared to other ML tasks like image classification or text generation [^AI_EnergyInference]:

| Task  |  Inference Energy (kWh) |
|-------------------------------------------|
| Text Classification | 0.002 $$\pm$$ 0.001
| Extractive QA | 0.003 $$\pm$$ 0.001
| Masked Language Modeling | 0.003 $$\pm$$ 0.001
| Toke Classification | 0.004 $$\pm$$ 0.002
| Image Classification | 0.007 $$\pm$$ 0.001
| Object Detection | 0.04 $$\pm$$ 0.02
| Text Generation | 0.05 $$\pm$$ 0.03
| Summarization | 0.49 $$\pm$$ 0.01
| Image Captioning | 0.63 $$\pm$$ 0.02
| Image Generation | 2.9 $$\pm$$ 3.3



10^23 FLOP for 10^6 USD thus 10^17 FLOP / USD = 10^5 TFLOP / USD or rather 

$$

\$1 = 10^{17}~\text{FLOP} \\
\$1 = 100 \cdot \text{PFLOP}

$$

Figure comparing different hardware including the biological brain.

![AIAccComp](/images/AI_acc_comparison_QW_animated.gif)




AI Impacts writes
>"In November 2017, we estimate the price for one GFLOPS to be between $0.03 and $3 for single or double precision performance, using GPUs (therefore excluding some applications). Amortized over three years, this is $1.1 x 10-5 -$1.1 x 10-7 /GFLOPShour" [^AiImpacts].


### Physics-Imposed Limitations
What should be physically possible?

### Accelerators

As of now, GPUs are the way to go to train and run deep neural networks as they are by far the fastest, most common, available, and easy to use processors. All praise NVIDIA. Yet there are also ASICs like Google's TPUs created specifically to improve the performance just for neural networks. Indeed, they require less power while being similarly fast. Still, the fastest training is, weirdly, achieved with GPUs. Then there are FPGAs that similar to ASICs achieve a lower power consumption at similar performance. Both ASICs and FPGAs are less general though. - More importantly, all available processors either consume a lot of power or have low performance. Ideally, we would like to get 100 OPS for less than 2 Watt, similarly to the brain.

I believe part of the solution are photonics as a way to speed up data transmission and bandwidth. But computation is extremely difficult and it will take much more time until photonic computers enter the competition in this particular field. We can use analog electronics though as well which, while less accurate, achieve incredible power-efficiency at high speeds! The key challenge here is thus dealing with noise and errors especially as we scale up the analog electronic circuit size. 

I can't seem to find much information on this topic online nor in books. So I will hack this together myself.

### Digital vs Analog
Most accelerators as of now still use digital signals to ensure accuracy and direct compatibility with existing technologies as the conversion from digital to analog and analog to digital is a science and art in itself. This leaves a wide opening to try and play with analog approaches though.


<!-- <a href="https://everycircuit.com/circuit/5270808553062400">Analog Implementation of a Novel Resistive-Type Sigmoidal Neuron</a><br> -->
<iframe width="100%" height="500px" style="border-radius: 5px;" src="https://everycircuit.com/embed/5270808553062400" frameborder="0"></iframe>


## Analog Computing
### Why Analog Circuits?
Nowadays, most people don't study analog computing.

Yet, we live in an analog world! And so, in order to do digital computing, we need to constantly convert from analog to digital and back, a very challenging task that some people make a living from just doing this alone! The reason digital computers are everywhere is because of their precision. They are reliable. They are therefore also easily scalable because new components do not introduce more and more errors. Hence why we now have over a hundred-billion transistors within our modern processors only a few cm in diameter. This is much more challenging to do with analog circuits. Note that quantum computing and photonic computing are predominately analog computing as well!

The great disadvantage with digital computing is that it requires a clock which can only operate at a very limited speed that hasn't increased in recent decades and more importantly, digital circuits are extremely computation heavy and so consume a lot of energy.

Yet, for example, in analog computing using a memristors, matrix multiplication is almost trivial to do and done in a single shot at an extremely low energy consumption!

<span class="sidenote-left">
    **How to compare analog to digital compute?** Analog computation has the advantage of not being limited to ones and zeroes as it computes directly with the floating values. This means we can also directly compare our compute with digital computers. This also highlights one of the main advantages of analog computing: 
    Lack of complexity! We do not need to _hundreds_ of transistors to express a single number. It is directly encoded in our signals.
    <style>
        img[alt=sidenote] { float: right; width: 100%; border-radius:5px; margin-left: 10px;, margin-bottom: 10px; margin-top: 10px;}
    </style>
    ![sidenote](/images/omni_man_analog_meme.png)
</span>

### Operational Amplifier as a Black Box
The typical operational amplifier has two inputs $$V_{\text{in\pm}}$$ and one output $$V_{\text{out}}$$. Then

$$
V_{\text{out}} = A_0 \cdot (V_{\text{in+}} - V_{\text{in+}}).
$$

So what the op-amp cares about is the difference between the applied input voltages.
For the ideal case, we assume that the impedances are $$Z_{\text{in}} = \infty$$ and $$Z_{\text{out}} = 0$$ for the ideal op-amp. Besides this we want to run the operations at high speed and so we desire a bandwidth $$BW = \infty$$ and a slew rate (the response rate) equaulling infinity. The output swing is supposed to be infinity as well. And finally, the gain. Sometimes it is desired to be infinity but it is actually depending on the definition. What do we mean by "ideal amplifier"? Here, we will wish it to be infinity as well, though. None of these goals/ideals can be achieved of course. But these are the goals.

<!-- 
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

MYTHIC Analog computing interview:
https://www.youtube.com/watch?v=7PJJM__zbbE
Mythic is now shipping its analog AI inference processor. 25 TOPS at 3 watts!?  Crazy!
80.000 ADCs (analog to digitial converters)
High accuracy
Mass production hitting soon (if not already).
Last hurdle: Software usability.

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


Not only are OPAMPS expensive. Digital potentiometers are even more expensive! But how do we load in our data then?

We can use the MCP4011-202E/MS digital potentiometer found on
https://www.arrow.com/en/products/mcp4011-202ems/microchip-technology?region=nac&utm_currency=USD. Yet, with around 800 input signals, this would cost us roughly 400€ given the price of 0,50€ per potentiometer.

Rather than building our own DAC (digital-to-analog converter) with so many outputs, we should attempt to find an already highly integrated pre-build DAC on the market. Typically, their output channel number is not greater than 32 or 64 though which means we'll need to multiplex.

4 channels

100 = 170€
340€ for 800 channels... This sucks...
https://www.digikey.de/en/products/detail/microchip-technology/MCP4728T-E-UN/5358293


Why are there so many fucking different OPAMS?
See the blog on my HHI laptop.

Why people don't think about analog computing. Yet it is everywhere!
https://electronics.stackexchange.com/questions/595199/what-is-the-actual-niche-for-operational-amplifiers-these-days


This paper shows how difficult it is to design, simulate, and actually build such an analog neural network as they only created a simulation as well! And they did so for a CMOS!
https://drive.google.com/file/d/1aGEucNV2uK2J1UHzV5xi8G5DK6MYNnQh/view
-->

### Analog Electronic Artificial Neuron
It is actually extremely fascinating to think about spiking neural networks but given that these are as of now very uncommon
in state-of-the-art (SOTA) AIs, let's focus on how we can build a simple perceptron-like artificial neural with analog electronics.


I wanted to keep this first experiment under a budget of 50€ because I am broke as hell. Most opamps sadly cost around $30ct though! But not all. We can use a LM258DRG4 by Texas Instruments which only costs $0.072 / piece (https://www.ti.com/product/LM258/part-details/LM258DRG4?HQS=ocb-tistore-invf-invftransact-invf-store-octopart-wwe found on https://octopart.com/search?category_id=4252&start=790). If we have 300 opamps that's less than 25€.




## Dense Neural Network
We can recognize handwritten numbers using deep neural networks[^1] quite easily using convolutional layers[^2] but I will focus only on densily connected neurons for now. The dataset commonly used for this task is the famous _MNIST_[^3] dataset. All of our code will be written in Python[^Python]. Let's begin with importing some libraries.

```python
import numpy as np
import PyTorch as torch
import matplitlib.pyplot as plt
```

We then define the architecture of our network:
```python
# input layer

# hidden layers

# output layer

```


### Error Discussion



The first Perceptron was, in fact, implemented using a custom analog computer at the time[^PerceptronAnalog] (See Veritasium.). 

>"The perceptron was invented in 1943 by Warren McCulloch and Walter Pitts[^]. The first hardware implementation was Mark I Perceptron machine built in 1957 at the Cornell Aeronautical Laboratory by Frank Rosenblatt,[^] [...]" (Wikipedia[^].)

<!-- 
<style>
    img[alt=Omniman] { float: right; width: 50%; border-radius:15px; padding-left: 10px;, padding-bottom: 10px; padding-top: 10px;}
</style>
![Omniman](/images/omni_man_analog_meme.png)
-->



### Analog Circuits

**Signal Generators.**
As it turns out, signal generators, implementing functions with analog circuitry, is a non-trivial task in its own right which has its own research field dedicated to it. But since our goal here is a _"simple"_ ASIC with only a few non-linear functions, this should be manageable, right? _RIGHT?!_ 

**Leaky ReLu.** 

**Sigmoid.**


### Creating the Printed Circuit Board (PCB)
In order to learn how to create custom PCBs, I have been watching and working through [this course by Philip Salmony (Phil's Lab)](https://www.youtube.com/watch?v=aVUqaB0IMh4). The whole project is based on the STM32 microcontroller.

If you are already proficient in PCB design, skip this section because I will be going through some fairly basic stuff, I am sure. That's because, at this point, wasn't trained to build one and so I will also share here how I learned to design PCBs.

* What is a micro-controller?
* What can the STM32 do / why did we choose it?
* Why do we add each of these capacitors?
* Why do we have a different source for analog voltage compared to the digital voltage?
* Why do we add a ferrite bead? To dissipate heat? Why is that necessary?
* Why is the internal crystal oscillator so bad that we have to add our own one? What does that mean?

Integrated Development Environment for STM32: 


### Simulating with LTSpice and Python
A quick search on YouTube doesn't offer much when it comes to learning how to build analog electronic circuits. But I found this devlog: https://www.youtube.com/watch?v=lKwzFdG2--8&list=PL_R4uxT5thflWVbSWtl-rx5_C_q0RxjyV&index=5 which brought me to learn about
+ https://www.analog.com/en/resources/media-center/videos/series/ltspice-essentials-tutorial.html
+ https://pypi.org/project/PyLTSpice/
software I will built on, to help me design the rather complex analog neural network and simulate it. If this does not work, I will just code it all from scratch or dive into IBMs analog neural network design & simulation Python library [source?!].

### Visualizing the design
To make this super awesome, let's create a visualization of the design like here https://www.youtube.com/watch?v=0Fixr39X8S4 as well as the input and output of the network! 😁
For this, once again, I wrote a little library.

### What's Next?
The great challenge of analog designs overall is managing noise. This project did not bother with that problem at all since it is a rather tiny prototype. But in order to scale it from a few hundred neurons to millions, we will need to come up with a way to either eliminate the noise problem or make it a feature just like it is in the human brain. Both are interesting directions though the latter would make more sense if we actually move away from artificial neural networks to spiking neural networks. 

Due to the cost of the components, miniaturization will also be essential. But so far, so good!

<div style="{background-color: 'crimson'; border-radius: 15px;}">
### Get One!
Thank you for reading 😁. (Or even just scrolling through all of this.) If you found this interesting, I encourage you to go and check out
    <div>
    <button href="" class="PDFButton">all the files on Github (free)</button>
    or
    <button href="" class="PDFButton">get a working and tested board ($49,99 + shipping)</button>
    </div>
</div>

<!--
### THE GREAT FUTURE CHALLENGE #1: Making it programmable. Thus allowing for upload of weights in a cheap way! (This problem was solved already by at least one company.)

### THE GREAT FUTURE CHALLENGE #2: Making it precise. Adding ADCs and DACs as well as a calibration loop to ensure that all the signals are as close to the desired, simulated signal as possible to minimize the added error.

### THE GREAT FUTURE CHALLENGE #3: Make a module that is scalable to the TFLOP regime at 3+GHz!

### THE GREAT FUTURE CHALLENGE #4: Allow for fast backpropagation and traininig.

### GFC #5: Create an API so that any Numpy or PyTorch-based ANN can be trained with this chip.

### GFC #6: Create a PCB that can be plugged into and controlled by a computer with a CPU and OS. How can we connect multiple chips and distribute training across them?
-->

For a general AI training accelerator, I could make it support tinygrad first since it has a tiny set of operations:
```
Buffer                                                       # class of memory on this device
unary_op  (NOOP, EXP2, LOG2, CAST, SIN, SQRT)                # A -> A
reduce_op (SUM, MAX)                                         # A -> B (smaller size, B has 1 in shape)
binary_op (ADD, SUB, MUL, DIV, CMPEQ, MAX)                   # A + A -> A (all the same size)
load_op   (EMPTY, CONST, FROM, CONTIGUOUS, CUSTOM)           # -> A   (initialize data on device)
ternary_op (WHERE)                                           # A, A, A -> A
```
and machine learning operations:
```
Relu, Log, Exp, Sin                            # unary ops
Sum, Max                                       # reduce ops (with axis argument)
Maximum, Add, Sub, Mul, Pow, Div, Equal        # binary ops (no broadcasting, use expand)
Expand, Reshape, Permute, Pad, Shrink, Flip    # movement ops
Where                                          # ternary ops
```
See the documentation [^tinygrad].
I have no idea how to implment these in a hybrid computer right now. One step at a time!
(Also, how would we go about supporting PyTorch, Tensorflow, Keras, Numpy, ...? Integrate some RISC-V?)


### References
[^1]: A
[^2]: B
[^3]: C
[^Python]: Python
[^AIDemand_Data_1]: [_COMPUTE TRENDS ACROSS THREE ERAS OF MACHINE LEARNING_, ArXiv](https://arxiv.org/pdf/2202.05924.pdf)
[^AIDemand_Data_2]: https://epochai.org/blog/compute-trends
[^AI_EnergyInference]: https://arxiv.org/pdf/2311.16863.pdf
[^WikiCompute]: https://de.wikipedia.org/wiki/Floating_Point_Operations_Per_Second
[^AiImpacts]: https://aiimpacts.org/current-flops-prices/
[^ComputeNotMoney1]: [Harrison Kinsley on X.com: https://x.com/Sentdex/status/1773358212403654860?s=20](https://x.com/Sentdex/status/1773358212403654860?s=20)
[^ComputeNotMoney2]: Sam Altman: 
[^NAChipMarket1]: https://www.eetasia.com/ai-chip-market-to-reach-70b-by-2026/
[^GHotz_InferenceMarket]: George Hotz, https://www.youtube.com/watch?v=iXupOjSZu1Y
[^OmidaH100Shipments]: Omida Research. (I was unable to find the original source though similar data can be found here: https://www.tomshardware.com/tech-industry/nvidia-ai-and-hpc-gpu-sales-reportedly-approached-half-a-million-units-in-q3-thanks-to-meta-facebook)
[^AKayHard]: [Alan Kay](https://en.wikipedia.org/wiki/Alan_Kay), _[Creative Think](https://www.folklore.org/Creative_Think.html)_, 1982
[^TweetBeffJezos]: Guillaume Verdon, https://twitter.com/BasedBeffJezos/status/1775445241434431541
[^tinygrad]: https://github.com/QuentinWach/tinygrad/blob/master/docs/adding_new_accelerators.md