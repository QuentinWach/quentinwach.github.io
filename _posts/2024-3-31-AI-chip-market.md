---
layout: post
mathjax: true
title:  "The Space of Neural Network Accelerators"
description: "An overview and commentary of (mostly) commercial AI and neuromorphic hardware currently available comparing ASICs, FPGAs, GPUs, digital, analog, electronic, and photonic computing. I update these notes as I work on my own AI accelerator."
date:   2026-04-10 20:38:24 +0100
author: ["Quentin Wach"]
tags: ["machine learning", "aritificial intelligence", "python", "analog computing", "electronics", "neural networks", "hardware design", "computer engineering"]
tag_search: true
image:          "/images/AI_acc_comparison_QW_animated_WTtitle.gif"
weight: 4
note: 
categories: "science-engineering"
---

![AIAccComp](/images/AI_acc_comparison_QW_animated_WT.gif)
<span style="font-size: 14px;">
    Speed of computing as dependent on the consumed power for different hardware architectures: GPUs, digital ASICs, mixed signal ASICs, and FPGAs. I adapted and animated this figure based on a figure I found and saved quite some time ago [^MFigure].
</span>

## 1. Introduction
Artificial general intelligence (AGI)
<span class="sidenote-right">
    Google's Deep Mind characterizes current general AIs as **emerging AGI**. Level 1. Examples, their researchers say, include: ChatGPT, Bard, Llama 2, and Gemini [^GoogleAGI].
</span>
is speculated to arrive within only a couple of years from now. And with its emergence comes a plethora of issues. In these notes, I want to focus not on the consequences of AGI, nor what algorithms and software will lead to it, but rather the bottlenecks and problems there are especially regarding its hardware.

>"We may recall that the first steam engine had less than 0.1% efficiency and it took 200 years (1780 to 1980) to develop steam engines that reached biological efficiency."

writes Ruch et al. in 2011 [^RuchBioAI].<span class="sidenote-right">Where _"efficiency"_ means how much energy is consumed proportional to the power of the engine.</span> Initial utility is typically achieved through effectiveness. We build something that gets the job done. And we do not mind how long it takes or how much it costs as long as it fixes the problem we couldn't otherwise solve. We saw and see the same thing happening with the rise of the digital computer and now with modern AI based on artificial neural networks. CPUs and GPUs are general tools. Architectures meant to accomplish whatever task we throw at it. And time is _the_ enemy of any technology company. Accelerate or be out-competed. Companies are willing to spend millions to innovate and train giant neural networks and billions to build the required infrastructure just to stay in the game. Efficiency is or has been an afterthought.

In 2020-2023, the bottleneck for AI was arguably the amount of hardware available due to a global chip shortage so vast it made history [^ChipShortage] [^ChipShortage2]. 
In 2024, managing the voltage conversion is still a major issue for scaling up [^MuskVTransformers].
<span class="sidenote-left">
    **Voltage transformers** play a crucial role in transmitting electrical power over long distances. To achieve this, voltage is stepped up for transmission and stepped down for safe use in homes, offices, and data centers. These transformers are bulky and expensive but necessary for safety and equipment protection. Demand for both types of transformers has surged since 2020 due to the needs of AI startups, data centers, and renewable energy sources like solar and wind farms [^TransformerBottleneck] [^TFormer1] [^TFormer2]. A topic worth its own article.
</span>

With these things hopefully more or more under control the future bottleneck will simply be the availability and cost of energy. In the short term, this means, how can we get the required energy cheapely? But as we continue to scale it also means: How can we make our hardware more energy efficient?

And then there is a data problem. We can fit all of the books in the world on a single harddrive if represented as tokens. So then we may look at videos and podcasts etc. But will it be enough?

Grog3 will require 100.000 H100s to train coherently. And at that point, there really is a lack of avaiable data, including text, video, and synthetic data. Much more is needed to satisfy the training needs of such large models. [Musk says that. And I heard Yan Le Cun say the same. But why exactly is that? I actually feel like this is a relatively trivial problem to solve.]


How do we get to the top left quadrant of this figure? How do we achieve high performance for low power?

Software optimization does not cut it. The hardware is too general to be efficient. And among other things the von-Neumann bottleneck [^vonNeumannBottle] fundamentally limits what these computers can do.

>"People who are really serious about software should make their own hardware." Alan Kay [^AKayHard].


## 2. Compute
>"The base metric is becoming compute. Not money." Harrison Kinsley (aka Sentdex) [^ComputeNotMoney1].

This statement has been repeated over and over by engineers and technologists in and outside of Silicon Valley, including Sam Altman saying

>"I think compute is going to be the currency of the future. I think it’ll be maybe the most precious commodity in the world." [^SamAltmanLex1]

_"Compute"_ or computing power is simply a general term to describe how much computations can be done in practice to solve our problems or, simplified even further, it is a measure of how powerful a computer is [^WikiCompute]. Today's GPUs reach several TFLOPs (Tera-FLOP) with a FLOP being a _"floating point operation"_. It has to be considered though that these can be 64-, 32-, 16-, 8-, or even just 4-bit operations! Nonetheless, 1 TFLOP = $$1\cdot10^{12}$$ FLOP. The question is now how many operations can be done per second as well what KIND of operations. Multiplication? Addition? Some functional transformation?
<span class="sidenote-left">
    The **scaling hypothesis in AI** posits that as the amount of data and computational resources available for training a machine learning model increases, the performance of the model also improves, often in a predictable manner. This hypothesis suggests that many AI tasks, particularly those related to deep learning, benefit from scaling up both the size of the dataset used for training and the computational power available for training the model.
    In practice, this means that larger neural networks trained on more extensive datasets tend to achieve better performance, such as higher accuracy or improved generalization, compared to smaller models trained on smaller datasets. The scaling hypothesis has been supported by empirical evidence in various domains, particularly in natural language processing, computer vision, and other areas where deep learning techniques are prevalent [^ScalingHypo].
    <!--
    <style>
        img[alt=centerAI] { float: left; width: 100%; border-radius:5px; margin-left: 10px; margin-bottom: 10px; margin-top: 10px;}
    </style>
    ![centerAI](/images/scaling_hypothesis.jpg) -->
</span>
<style>
    img[alt=centerAI] { float: right; width: 100%; border-radius:5px; margin-left: 10px;, margin-bottom: 10px; margin-top: 10px;}
</style>
![centerAI](/images/AI_compute.png)
<span style="font-size: 14px;">
    The amount of compute required to train (a) neural network and do inference (b) after training.
    This figure was created by myself but the data was compiled by Jaime Sevilla et al. [^AIDemand_Data_1] [^AIDemand_Data_2].
</span>

### 2.1 Training
Subplot (a) of the figure presented above shows the insane increase in training compute over time to create more and more capable AIs, rising orders of magnitude within years. 

>"[...] since 2012, the amount of compute used in the largest AI training runs has been increasing exponentially with **a 3.4-month doubling time** (by comparison, Moore’s Law had a 2-year doubling period). Since 2012, this metric has grown by more than **300,000x** (a 2-year doubling period would yield only a 7x increase)." This was previously observed by OpenAI [^OpenAIComputePost].

As we can see in the figure above, this is not only true for the largest AIs but for AI in general!


### 2.2 Inference
<span class="sidenote-right">
    <style>
        img[alt=NAchip] {float: right; width: 100%; border-radius:5px; margin-left: 10px; margin-bottom: 10px; margin-top: 10px;}
    </style>
    In fact, the **North American AI chipset market** is growing much faster for edge compute (which is essentially infernce) compared to cloud compute (mostly training) [^NAChipMarket1].
    ![NAchip](/images/NA_AI_chipmarket.png)
    In a live stream, George Hotz mockingly said:
    _"All those fucks are trying to make edge AI. [...] Look! The AI inference market is bigger than the AI training market! So we should all go for the inference market! It's way easier! [...] Easier and bigger! [...] There are a hundred little fucks who make inference chips that no one really wants and only one who is making training chips (NVIDIA)."_ [^GHotz_InferenceMarket]
    <style>
        img[alt=H100Buyers] {float: right; width: 100%; border-radius:5px; margin-left: 10px; margin-bottom: 10px; margin-top: 10px;}
    </style>
    ![H100Buyers](/images/H100_buyers.png)
    _Estimated 2023 H100 shipments by end customer as reported by Omida Research [^OmidaH100Shipments]._
    ![H100Buyers](/images/compute_Facebook_2024.jpg)
    _Estimated 2024 H100s access of different companies including Facebook [^asdg]._
</span>
Contrary to training, the compute for inference has hardly grown in comparison. That is because we want the inference to be fast and cheap in order for it to be practical. There can't be a seconds of delay for the self-driving car. We don't want our LLMs to spend hours computing an hour for our question and burn the energy of a small town for it. So with traditional hardware we are quite limited here and models are optimized to work within these boundaries. Imagine what we could do with better dedicated hardware though! Imagine LLMs would respond instantly and run locally on your phone. This will be necessary for robots especially. So while inference does not seem like a growth market at first glance, the demand is absolutely there.


## 3. Energy
At this point, I want to highlight the title figure at the beginning of these notes showing the speed in GOP/s over power in W of GPUs, FPGAs, digital and mixed signal ASICs. More than any other figure here, I think it gives a sense of how the different hardware compares. 

The sad truth as of now is that there seems to be a linear relationship between the amount of compute per second we can achieve and the energy required. To drive down the costs or AI developement and inference, we'd have to dramatically reduce the cost of energy, which would require an energy revolution in of itself, or rethink and rebuild our hardware on a much more fundamental level than is currently done (in the industry). That is precisely why I am writing these notes.

### 3.1 GPUs
NVIDIA is the non-plus ultra for AI training at the largest scale. We see this reflected with commercial GPUs providing the fastest training. The drawback: These GPUs also consume by far the most power.

In NVIDIA's most recent developer conference, Jensen Huang bragged about how hot these GPUs get. So hot, that they need to be liquid cooled (which poses new challenges in data centres). So hot, that the coolant coming out after just seconds could be used as a whirlpool, I remember him stating. Later on stage, he then continued talking about how NVIDIAs new accelerators are now much more energy efficient [^NVIDIAGTC2024]. It takes a special kind of genius to pull of such contradiction marketing. I am not even trying to be critical. It's rather humorous!

Even with their incredible energy demands and the high training costs that follow, NVIDIAs glowing hot GPUs have a bright future.

### 3.2 FPGAs
Still, if we were to compete, lowering energy consumption is the angle of attack. FPGAs are, in part, competitive enough in terms of speed yet at similar power consumption and much, much worse usability. Nonetheless, some argue for a future of FPGA data centres:

>"Due to their software-defined nature, FPGAs offer easier design flows and shorter time to market accelerators than an application-specific integrated circuit (ASIC)." [^FPGACentres]

I think that is questionable. [Why exactly? Why are people even using FPGAs? For what applications especially in AI?]

### 3.3 ASICs

### 3.4 TPUs


### 3.5 NPUs



>"It can be concluded that FPGAs are a feasible choice for a real-time application with a limited power-budget. ASICs are well suited for the use in data centers since the high initial costs and the longtime-to-market is an acceptable risk to achieve a higher performance and energy efficiency. For all other applications, GPUs is the most feasible choice." [^AIAcceleratorComp1]

### 3.6 Applications
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



AI Impacts writes
>"In November 2017, we estimate the price for one GFLOPS to be between $0.03 and $3 for single or double precision performance, using GPUs (therefore excluding some applications). Amortized over three years, this is $1.1 x 10-5 -$1.1 x 10-7 /GFLOPShour". [^AiImpacts]


<style>
    img[alt=BiologicalComputation] { float: left; width: 50%; border-radius:5px; margin-right: 10px;, margin-bottom: 10px; margin-top: 8px;}
</style>
![BiologicalComputation](/images/comp_eff_dens.png)


### 4. Price
<!-- What accelerators are currently available? How much do they cost? -->

NVIDIA
Apple
Intel
Microsoft
Google
AMD
IBM
...


### 5. Hardware: Old & New
<!-- von-Neumann vs. Harvard architecture vs. ASICs vs. analog etc. -->

### 5.1 Physics-Imposed Limitations
What should be physically possible?

### 5.2 Accelerators

As of now, GPUs are the way to go to train and run deep neural networks as they are by far the fastest, most common, available, and easy to use processors. All praise NVIDIA. Yet there are also ASICs like Google's TPUs created specifically to improve the performance just for neural networks. Indeed, they require less power while being similarly fast. Still, the fastest training is, weirdly, achieved with GPUs. Then there are FPGAs that similar to ASICs achieve a lower power consumption at similar performance. Both ASICs and FPGAs are less general though. - More importantly, all available processors either consume a lot of power or have low performance. Ideally, we would like to get 100 OPS for less than 2 Watt, similarly to the brain.

I believe part of the solution are photonics as a way to speed up data transmission and bandwidth. But computation is extremely difficult and it will take much more time until photonic computers enter the competition in this particular field. We can use analog electronics though as well which, while less accurate, achieve incredible power-efficiency at high speeds! The key challenge here is thus dealing with noise and errors especially as we scale up the analog electronic circuit size. 

I can't seem to find much information on this topic online nor in books. So I will hack this together myself.

### 5.3 Digital vs Analog
Most accelerators as of now still use digital signals to ensure accuracy and direct compatibility with existing technologies as the conversion from digital to analog and analog to digital is a science and art in itself. This leaves a wide opening to try and play with analog approaches though.

### 5.4 Non-Conventional Computers


### 6. Conclusion
+ Photonics is great at communication but has a lot of fundamental issues that keep it from being practical for computing in comparison electronics at least for now and likely the next 5-10 years. Integrating photonics as intra- and interconnects will be crucial for high-performance computing though. But it is not yet a bottleneck.

+ Thermodynamic computing, to me, seems mostly academic for now.

+ Quantum computing seems extremely promising but simply scaling this technology will take more decades as well.

+ Analog electronic computing on the other hand just works. The issue here is not the fundamental technology but rather our ability to design analog ICs quickly! It is my quess that analog electronics should also naturally play well with photonics. Very large scale integration (VLSI) is a resulting challenge. 
  >"Conventional analog designs require schematic-entry based specification and **a custom layout design that requires many iterations to meet design goals**."[^ADesign]

+ While I believe GPUs will continue to dominate the training market for the next 3+ years while digital ASICs, and to some degree FPGAs, will increasingly dominate the market for AI inference. But if we take a larger view of humanity and the required compute in the next decades and centuries, analog computing will have to become a dominating force. Not for general computing but for AI acceleration. And not just inference but, importantly, training as well.

---

Generative AI is the most energy consuming task yet th

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
[^MFigure]: Adapted based on a figure originally linked to [https://NICSEFC.EE.TSINGHUA.EDU.CN](https://NICSEFC.EE.TSINGHUA.EDU.CN). Yet, I was not able to find it again as the link seemed to have been broken.
[^ADesign]: https://theopenroadproject.org/automated-soc-mixed-signal-design-using-openroad-and-openfasoc/
[^SamAltmanLex1]: https://lexfridman.com/sam-altman-2-transcript/
[^AKayHard]: [Alan Kay](https://en.wikipedia.org/wiki/Alan_Kay), _[Creative Think](https://www.folklore.org/Creative_Think.html)_, 1982
[^ScalingHypo]: [J. Hestness et al., _DEEPLEARNING SCALING IS PREDICTABLE, EMPIRICALLY_, https://arxiv.org/pdf/1712.00409.pdf?source=content_type%3Areact%7Cfirst_level_url%3Aarticle%7Csection%3Amain_content%7Cbutton%3Abody_link, 2017](https://arxiv.org/pdf/1712.00409.pdf?source=content_type%3Areact%7Cfirst_level_url%3Aarticle%7Csection%3Amain_content%7Cbutton%3Abody_link)
[^RuchBioAI]: [P. Ruch et al., _Toward five-dimensionalscaling: How densityimproves efficiency infuture computers_, IBM, 2011](chrome-extension://oemmndcbldboiebfnladdacbdfmadadm/https://www.zurich.ibm.com/pdf/news/Towards_5D_Scaling.pdf)
[^vonNeumannBottle]: https://en.wikipedia.org/wiki/Von_Neumann_architecture
[^MuskVTransformers]: Interview with Elon Musk on X.com: https://twitter.com/i/spaces/1YqJDgRydwaGV/peek Musk mentioned the various bottlenecks of AI in other recent interviews as well.
[^TransformerBottleneck]: https://finance.yahoo.com/news/electrical-transformers-could-giant-bottleneck-220423599.html
[^ChipShortage]: https://en.wikipedia.org/wiki/2020%E2%80%932023_global_chip_shortage
[^ChipShortage2]: https://edition.cnn.com/2023/08/06/tech/ai-chips-supply-chain/index.html
[^GoogleAGI]: https://arxiv.org/pdf/2311.02462.pdf
[^OpenAIComputePost]: OpenAI, AI and compute: https://openai.com/research/ai-and-compute
[^NVIDIAGTC2024]: [NVIDIA GTC March 2024 Keynote with Jensen Huang: https://www.youtube.com/watch?v=Y2F8yisiS6E&list=PLZHnYvH1qtOYPPHRaHf9yPQkIcGpIUpdL](https://www.youtube.com/watch?v=Y2F8yisiS6E&list=PLZHnYvH1qtOYPPHRaHf9yPQkIcGpIUpdL)
[^FPGACentres]: https://www.allaboutcircuits.com/news/shifting-to-a-field-programable-gate-array-data-center-future/
[^AIAcceleratorComp1]: [Baischer et al., _Learning on Hardware: A Tutorial on Neural Network Accelerators and Co-Processors_, https://arxiv.org/pdf/2104.09252.pdf, 2021](https://arxiv.org/pdf/2104.09252.pdf)
[^TFormer1]: https://en.wikipedia.org/wiki/Data_center
[^TFormer2]: https://www.olsun.com/power-integrator-data-center-2/