---

---

# RetinaNet in `tinygrad`: A Double Introduction
This blog post will introduce the `tinygrad` library, Python library to train
and run artificial neural networks as well RetinaNet which is a famous object detection architecture which we will implement and train using `tinygrad`.
This not only seemed like a neat thing to work on this evening but once I dove into the code, it became clear that it would also make me a better programmer. Also, implementing this was worth $600 to [George Hotz](https://de.wikipedia.org/wiki/George_Hotz) and I am glad to have gotten the bounty. 😉 Thanks! 

## The Code Style
`tinygrad` is extremely compact and minimal Python code. I mean, that is part of the whole point, hence the name. Still, at first glance, it seemed difficult to grasp compared to what I am personally used to among physicists especially. Typically, I am almost bombarding my code with comments explaining exactly how to use it what the arguments and returns are and so on. `tinygrad` doesn't do that at all. Rather, the code aims to speak for itself and minimize noise. Usually the function definitions are self-explanatory though as they clearly state their purpose, arguments, and returns. Still, I wonder how much sense this makes as the library is meant to be adopted by a larger crowd.
Compare the `tinygrad` library to `Keras` which takes the approach I am more used to.

In my opinion, I think it makes sense, at some point, to sacrifice code simplicity + readability for a faster user adoption of the library.

## Getting Started
The best way to understand how to use this library is by building something with an eye on the **examples** (like this one). Most things you'll do have already been done and you can simply adapt it. `tinygrad` does provide [documentation](https://github.com/QuentinWach/tinygrad/tree/master/docs) though, too, including [a little _quickstart_ introduction](https://github.com/QuentinWach/tinygrad/blob/master/docs/quickstart.md).


## Work of Giants
Some genius, a giant, came before me and already implemented the RetinaNet: `tinygrad/extra/models/retinanet.py`. Blessed be you who came before me. 🙏🏻 So all that's left is loading in the weights, a dataset, and training the RetinaNet on said data to showcase the power of `tinygrad` with this new example.

Once again, code is already provided showing how to train ResNet! So all I am doing is copying it and tweaking it for RetinaNet. Then we run it all on [wandb.ai](https://wandb.ai/) and see if we can reach the desired benchmarks shown at [ML Commons](https://mlcommons.org/benchmarks/inference-edge/). 

As can be seen in the code, RetinaNet builds on top of Resnet thus using its weights. So then what do we even have to train here?

## RetinaNet
[TowardsMachineLearning.org](https://towardsmachinelearning.org/retinanet-model-for-object-detection-explanation/) features a simple post explaining RetinaNet. Given how famous it is, recources online aren't lacking. 

