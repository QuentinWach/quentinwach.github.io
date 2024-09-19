---
layout: personal
mathjax: true
title:  "Physics Processing Units"
description: "The first dedicated physics processing unit, the Ageia PhysX PPU, was released in 2006 yet the market for it was killed quickly by NVIDIA. In the decades after, only few attempts were made to build hardware for physics acceleration like the Intel Xeon Phi. Game developers stopped pushing the boundaries and integrating physics on a fundamental level despite the often fundamental importance for game play and scientist have been struggling with the complexities of implementing the often complex math to GPUs only to realize that this hardware was never meant for these applications."
date:   2025-09-14 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["physics", "hardware design", "computer engineering", "electronics"]
tag_search: true
image:     "/images/ppu.png"
weight:
note: 
categories: "personal"
---
<!--
<style>
    img[alt=AIAccComp] { float: right; width: 100%; border-radius:5px; margin-left: 10px;, margin-bottom: 10px; margin-top: 10px; }
    img[alt=AIAccComp]:hover {
                            transform: scale(1);
                            box-shadow: 0px 0px 0px rgba(0, 0, 0, 0);
                            z-index: 10000;
    }
</style>
![AIAccComp](/images/AI_acc_comparison_QW_animated_WT.gif)
<span style="font-size: 14px;">
    Speed of computing as dependent on the consumed power for different hardware architectures: GPUs, digital ASICs, mixed signal ASICs, and FPGAs. I adapted and animated this figure based on a figure I found and saved quite some time ago [^MFigure].
</span>
-->

<span class="sidenote-left">
I increasingly see it as my mission to create **world simulators**. To recreate reality and allow for virtual worlds with levels of detail that we can't even imagine today. That is why I am exploring the history and state-of-the-art regarding physics simulation and physics hardware acceleration here.
_(Updated: September 15, 2024.)_
</span>



## 1. Introduction






### 1.1 History of Physics and Computing
Progress in the sciences and progress in computer science and engineering have been linked to each other since the invention of the abacus[^abacus]. It is common knowledge that computers were enabled by discoveries in physics but much of the discoveries in physics such as the vacuum tube[^vacuum_tube], the transistor[^transistor][^transistor_2], various lithography techniques and so on. Yet, physics itself, the other sciences, and the progress in engineering have been accelerated with the creation of increasingly powerful computing hardware and software as well. 

Computer simulations have opened up a new platform for research and development that offers various advantages compared to experiments and experimental _simulations_ using analog systems/models: 
+ **Flexibility / controllability**: Programmers have full control over the computer simulations they create.
+ **Cost**: Proprietary software solutions and hardware allow for quick testing without the otherwise high material and development costs.
+ **Safety**: Simulations don't pose dangers like radiation poisoning e.g. in the case of atomic experiments. 
+ **Speed**: Depending on the state of hardware and software simulations can be run much faster than real experiments and often in parallel.


### 1.2 Recent Developments
There have been a few attempts at dedicated PPUs for accelerating physics calculations in games and simulations. Ageia PhysX PPU was arguably the first dedicated physics processor, released in 2006. It was designed to offload physics calculations from the CPU [4]. NVIDIA PhysX: After NVIDIA acquired Ageia in 2008, they integrated PhysX technology into their GPUs, allowing physics acceleration on NVIDIA graphics cards rather than a separate PPU [4].



Havok FX: Havok developed a physics engine that could utilize GPU acceleration, though it wasn't a dedicated PPU [4].



Intel Xeon Phi: While not exclusively for physics, these many-core processors were designed for highly parallel workloads including scientific simulations [5].



Modern CPUs: Current high-end CPUs from Intel and AMD have many cores and specialized instructions that can be utilized for physics calculations [6]. For example, AMD has published the FEMFX deformable physics library optimized for their CPUs [8].



GPUs: Modern GPUs are often used for physics acceleration in games and simulations due to their highly parallel architecture [2].



FPGAs and ASICs: For specialized applications, field-programmable gate arrays or application-specific integrated circuits can be designed to accelerate physics computations [1].



While dedicated PPUs are no longer common, physics acceleration is now typically handled by a combination of multi-core CPUs and GPUs in modern systems. Game engines and simulation software can distribute physics workloads across available computing resources [8].


## The Need for PPUs
Ageia's PPU answered a huge demand for physics acceleration at a time where games rapidly became more realistic and neither CPUs nor GPUs could keep up with the software innovations. NVIDIA quickly acquired Ageia to incorporate their ideas into their GPUs as well as the PhysX software which is an industry standard still today and was recently open-sourced[^PhysX_open_source] as part of NVIDIA's Omniverse initiative[^NVIDIA_Omniverse]. 

<!-- 
Why is NVIDIA working on the Omniverse?
- Training AI!
- Empowering Science!
- Solving everything! This is THE endgame!
-->


<!--
Why is Facebook working on the Metaverse?
- Because Virtual Reality is the final computing platform!
-->

<!-- 
Why does VR require sophisticated physics?
- For now, because it is disturbing and feels unnatural to users if the virtual world does not also follow actual laws of physics.
- In the future: Because VR will largely if not completely replace the material world we live in. So our digital physics better be up for the task!
-->


## Arguments Against Physics Hardware Acceleration
There are _no_ arguments against physics hardware acceleration.

## Conclusion


>"See a need, fill a need!" said Bigwell in Pixar's _Robots_ (2005)[^Pixar_Robots].

### References
[^abacus]: [Abacus, https://en.wikipedia.org/wiki/Abacus](https://en.wikipedia.org/wiki/Abacus)
[^vacuum_tube]: [Vacuum Tube, https://en.wikipedia.org/wiki/Vacuum_tube](https://en.wikipedia.org/wiki/Vacuum_tube)
[^transistor]: [Transistor, https://en.wikipedia.org/wiki/Transistor](https://en.wikipedia.org/wiki/Transistor)
[^transistor_2]: [History of the Transistor, https://en.wikipedia.org/wiki/History_of_the_transistor](https://en.wikipedia.org/wiki/History_of_the_transistor)

[^PhysX_open_source]: [PhysX, https://github.com/NVIDIA-Omniverse/PhysX](https://github.com/NVIDIA-Omniverse/PhysX)
[^NVIDIA_Omniverse]: [NVIDIA Omniverse, https://www.nvidia.com/en-us/omniverse/](https://www.nvidia.com/en-us/omniverse/)

[^Pixar_Robots]: [Pixar's _Robots_ (2005)](https://en.wikipedia.org/wiki/Robots_(2005_film)).

[^1]: A
[^2]: B
[^3]: C
[^Python]: [Python, https://www.python.org/](https://www.python.org/)
[^AIDemand_Data_1]: [Sevilla et al., _Compute Trends Across Three Eras of Machine Learning_, ArXiv, 2022](https://arxiv.org/pdf/2202.05924.pdf)
[^AIDemand_Data_2]: [Epoch AI, _Compute Trends_, https://epochai.org/blog/compute-trends](https://epochai.org/blog/compute-trends)
[^AI_EnergyInference]: [Luccioni et al., _Power Hungry Processing: Watts Driving the Cost of AI Deployment?_, ArXiv, 2023](https://arxiv.org/pdf/2311.16863.pdf)
[^WikiCompute]: [Wikipedia: Floating Point Operations Per Second, https://de.wikipedia.org/wiki/Floating_Point_Operations_Per_Second](Wikipedia: Floating Point Operations Per Second, https://de.wikipedia.org/wiki/Floating_Point_Operations_Per_Second)
[^AiImpacts]: [AI Impacts, _Current Flop Prices_, https://aiimpacts.org/current-flops-prices/](https://aiimpacts.org/current-flops-prices/)
[^ComputeNotMoney1]: [Harrison Kinsley on X.com: https://x.com/Sentdex/status/1773358212403654860?s=20](https://x.com/Sentdex/status/1773358212403654860?s=20)
[^NAChipMarket1]: https://www.eetasia.com/ai-chip-market-to-reach-70b-by-2026/
[^GHotz_InferenceMarket]: George Hotz, https://www.youtube.com/watch?v=iXupOjSZu1Y
[^OmidaH100Shipments]: Omida Research. (I was unable to find the original source though similar data can be found here: https://www.tomshardware.com/tech-industry/nvidia-ai-and-hpc-gpu-sales-reportedly-approached-half-a-million-units-in-q3-thanks-to-meta-facebook)
[^MFigure]: Adapted based on a figure originally linked to [https://NICSEFC.EE.TSINGHUA.EDU.CN](https://NICSEFC.EE.TSINGHUA.EDU.CN). Yet, I was not able to find it again as the link seemed to have been broken.
[^ADesign]: https://theopenroadproject.org/automated-soc-mixed-signal-design-using-openroad-and-openfasoc/
[^SamAltmanLex1]: Sam Altman on the Lex Fridman podcast: [https://lexfridman.com/sam-altman-2-transcript/](https://lexfridman.com/sam-altman-2-transcript/)
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
[^kcal_in_Watt]: Feel free to convert back and forth between kcal and Wh yourself at [https://convertlive.com/u/convert/kilocalories-per-hour/to/watts#2000](https://convertlive.com/u/convert/kilocalories-per-hour/to/watts#2000).
[^kcal_in_Watt2]: https://de.wikipedia.org/wiki/Kalorie
[^ScalingHypo2]: Gwern actually wrote about the scaling hypothesis on his blog as well: [https://gwern.net/scaling-hypothesis](https://gwern.net/scaling-hypothesis)
[^ScalingHypo3]: [J. Kaplan et al., _Scaling Laws for Neural Language Models_, ArXiv, 2020: https://arxiv.org/pdf/2001.08361.pdf](https://arxiv.org/pdf/2001.08361.pdf)
[^HintonScaling]: [Geoffrey Hinton on Twitter in 2020: https://twitter.com/geoffreyhinton/status/1270814602931187715](https://twitter.com/geoffreyhinton/status/1270814602931187715)
[^GPT4_price]: Knight, Will. "OpenAI's CEO Says the Age of Giant AI Models Is Already Over". Wired. Archived from the original on April 18, 2023. Retrieved April 18, 2023 – via www.wired.com. https://www.wired.com/story/openai-ceo-sam-altman-the-age-of-giant-ai-models-is-already-over/
[^GPT4_energy]: https://www.ri.se/en/news/blog/generative-ai-does-not-run-on-thin-air
[^GPT4_facts]: https://patmcguinness.substack.com/p/gpt-4-details-revealed
[^TokenOverview]: https://www.educatingsilicon.com/2024/05/09/how-much-llm-training-data-is-there-in-the-limit/
[^LandauP]: https://en.wikipedia.org/wiki/Landauer%27s_principle