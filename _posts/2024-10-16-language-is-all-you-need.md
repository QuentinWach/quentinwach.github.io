---
layout: post
mathjax: true
title:  "Language Is All You Need: Abstraction and Reasoning with DSLs"
description: "_'Language is all you need'_ I thought jokingly while building a simple DSL for Chollet's Abstraction and Reasoning Corpus (ARC). The reason is that, while you could in theory describe and submit any arbitrary image using just 3-4 instructions (words), doing so would require very long 'sentences' which is inefficient and error-prone. Humans memorize and use thousands of words to communicate so why shouldn't AI's utilize complex languages to express and think through abstract problems as well? Let's think about this."
date:   2025-10-16 10:38:24 +0100
authors: ["Quentin Wach"]
tags: ["artificial intelligence"]
tag_search: true
image:     "/images/shader_2.png"
weight:
note: 
categories: "blog"
---

I think the current domain specific languages (DSLs) for ARC are just not scalable because they don't actually abstract and they outsource the reasoning rather than guiding it through the abstraction.

They directly take in the input grid data, apply various transformations, and return the output. Now, that is done extremely cleverly! It looks quite elegant to me. But I believe that it doesn't really utilize the object nature and prior knowledge that is immediately obvious to humans.

But anyway. This is a blog post. Let me give a bit of context and dump my thoughts.

## Introduction
I found myself recently working as an _AI Researcher_ for a company with the given task to push towards artificial super intelligence. I quickly decided that I wanted to attack the Abstraction and Reasoning Corpus (ARC)[^ARC] as it had been a long-time dream of mine to do so and slay this dragon and fit the approach others in the company named perfectly. After a couple of days of brainstorming and reading papers mainly about LLMs, I found myself sketching out an idea which, one week later, I would discover to be extremely similar to DreamCoder[^DreamCoder]. While there were differences to my idea, the overlap is significant enough that I knew I had to dive in and learn everything about this branch of research.


## The Idea



## Abstraction

### Domain-Specific Languages (DSLs)

#### Michael Hodl's DSL
In 1204 lines of Python code (without empty lines), Michael Hodl collects 160 functions. He then wrote 5776 more lines of code (without empty lines) with 400 functions, one for each problem in the ARC dataset. Yet, if we count how often each of the DSL operations is used, it turns out: not so much! Most functions are called each for less than 40 of the 400 problems in total as shown in the figure below.

![](/images/dsl.py_combined_function_usage.png)

One might now think that we can therefore throw out most of these handcrafted functions and still be able to solve the vast majority of problems and probably have a much easier time searching given how much smaller the space is, correct?

If we look at the total usage count, we can see that certain functions are not used as often for every problem but when they are used for a single problem, they are used a lot.

##### Example
Let's look an example and how Hodle solves it.


This is puzzle `22eb0ac0`. (You can play with it on https://arcprize.org/play?task=22eb0ac0.) Humans can tell what needs to be done on a glance. 
Solution: **If pixels in the same row are of the same color, connect them with a line.**
Easy. Right?



Hodle's DSL solution looks like this though:
```python
def solve_22eb0ac0(I):
    x1 = fgpartition(I)
    x2 = fork(recolor, color, backdrop)
    x3 = apply(x2, x1)
    x4 = mfilter(x3, hline)
    O = paint(I, x4)
    return O
```

What does that mean? Well. Let's add some comments:

```python
def solve_22eb0ac0(I):
    """
    If pixels in the same row are of the same color,
    connect them with a line.
    """

    # Step 1: Partition the foreground objects in the image I
    # This function identifies distinct objects in the image based on color.
    x1 = fgpartition(I)

    # Step 2: Create a function that recolors pixels to a specified color
    # The 'fork' function allows us to create a new function that will apply
    # the recoloring to the identified objects, using the specified color and backdrop.
    x2 = fork(recolor, color, backdrop)
    
    # Step 3: Apply the recoloring function to the foreground partitions
    # This applies the recoloring to each object identified in the previous step.
    x3 = apply(x2, x1)
    
    # Step 4: Filter the results to keep only horizontal lines
    # The 'mfilter' function is used to filter the output, keeping only the
    # segments that form horizontal lines.
    x4 = mfilter(x3, hline)

    # Step 5: Paint the original image I with the filtered horizontal lines
    # This overlays the horizontal lines onto the original image.
    O = paint(I, x4)

    return O
```

That is not really what the English sentence states. Or is it?

My approach, roughly speaking, would be quite similar to what is said in the English sentence!

```python
def q_solve_22eb0ac0(objects):
    """
    If pixels in the same row are of the same color,
    connect them with a line.
    """
    grid = Grid(I)

	# If pixels...
    for object_A in objects:
        for object_B in objects:
            if object_A != object_B:
	            # ... in the same row ...
                if object_A.position[1] == object_B.position[1]:   
	                # ... are of the same color ... 
                    if object_A.color == object_B.color:
	                    # ... connect them with a line.
                        grid.add(Line(object_A.position, object_B.position), color=object_A.color)
    return grid
```

The premise here is that we have already done a previous abstraction step. Rather than just taking in the raw pixel data, we abstract the pixel data in a hierarchy of objects with properties and relations between each other which allows us to think about the problem in a much more simplified way.

Rather than having to apply specialized filters to the whole grid, we just reason about the changes regarding the objects between input and output image. 

## Objects
I believe all DSLs I have found so far take a purely functional approach. My DSL on the other hand is largely object-oriented despite my usual hate for object-oriented programming. That is because it is my goal to abstract the image into a hierarchy of objects that encodes how these objects relate to each other, so that if complicated objects go through transformations, this can be easily spotted. Object-oriented progamming lends itself to this appraoch because it allows for this kind of nested data structure where, as we create more complicated constructs of objects.

There is an inherent advantage to object-oriented abstraction and programming. It is highly informative regarding the transformations for various reasons. One way to think about this is that objects have limited properties and limited functions. A pixel can't be rotated or mirrored so by automatically categorizing an object as a pixel before we even begin searching for the program of the transformation, we already massively prune the tree of possible operations.

How do we do this in a functional way? I think they are limiting the search by enforcing types. But I don't see how Hodl's approach is informative in any way.

An interesting discussion on DSL and functional vs. object-oriented DSLs can be found in this [Reddit forum](https://www.reddit.com/r/functionalprogramming/comments/q60o1q/functional_vs_objectoriented_dsls/).


## Transformations


### Levels of Abstraction


### Orthogonality


#### Jack Cole's DSL





[^ARC]:
[^DreamCoder]:


---
A key design question is the selection of operations for the AI to use to generate the solutions.

An almost absurdly minimal DSL (let’s call it DSL.1 with 4 operations) could be

M (move to next pixel in the array)
C (change pixel to next color (10))
I (change to next canvas size/frame (900))
S (submit solution)

is enough to describe the solution image for any problem on ARC. If a model is meant to generalize and solve all problems using this DSL, it will have to
generate an extremely long chain of operations though, all of which have to be correct, and
do all the abstract thinking outside of the DSL.

The language / tool that is used to create the solutions is essential as it encodes abstract knowledge that can massively speed up thinking! In other words, we want to maximize the size of the DSL. The other advantage that comes with that is that this way, we can actually understand the reasoning of the AI.

```txt
DSL.2 (with 10 operations) could be:

ML (move left)
MR (move right)
MU (move up)
MD (move down)
CN (change pixel to next color (c+1))
CP (change pixel to previous color (c-1))
CB (reset pixel color to black (c=0))
I (increase canvas size)
D (decrease canvas size)
S (submit solution)


DSL.3 (with 35 operation) could be:
// Coloring
Color0
Color1
Color2
Color3
Color4
Color5
Color6
Color7
Color8
Color9

// Flood Fill
FloodFill0
FloodFill1
FloodFill2
FloodFill3
FloodFill4
FloodFill5
FloodFill6
FloodFill7
FloodFill8
FloodFill9

// Object Oriented
MoveU
MoveD
MoveR
MoveL
Rotate90
Rotate270
FlipH
FlipV

// Clipboard
CopyI
CopyO
Paste

// Critical
CopyInput
Reset Grid
ResizeGrid
Submit
```
The median vocabulary size for a human 40-year-old is around 30,000 words. Even a 3-year old child recognizes about 3,000 words! There is a very good practical reason for this: Words are concepts that help us abstract / condense complicated things into a simple idea. So instead of using a set of 5 words in a 4500 word sentence to describe an image, we may use vocabulary of 100 words and shorten the sentence (or program) to only a 10 words (or lines).

Given how many words humans know and are more than capable of handling fluently, I think it is plausible that we should scale up the size of our DSL to be much larger and much more complex.

The great upside of this is also that it makes the system extremely modular and highly interpretable!

The great thing about a word is that it can be explained with other words. And in software, too, high-level functions can be seen as words/concepts which could otherwise be expressed using a longer chain of other more concrete words / functions (which are inside the function).

This leaves us with the question: What is the minimal instruction set / vocabular / the atomic words / atomic operations with which all higher concepts / words can be expressed building upon them?