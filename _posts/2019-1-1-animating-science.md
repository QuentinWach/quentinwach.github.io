---
layout: post
mathjax: true
title:  "Professional Figures with Matplotlib (2020)"
description: "An introduction into the Matplotlib API, how to get started customizing plots, and create professional figures for your scientific work."
date:   2020-1-1
authors: ["Quentin Wach"]
tags: ["software", "computer graphics"]
tag_search: true
image:          "/images/science animations/happy4_c3.gif"
weight: 10
github: QuentinWach/Animating-Science
note: "+100K views across the internet."
categories: "blog"
---

<!--
A free collection of tutorials and simulation examples that aim to showcase and explain the animation capabilites one has using Python. This includes chemical reaction diffusion, the viral spread in pandemics, fractals, chaotic pendulums with springs, Conway's game of life, quantum states of hydrogen, galaxy collisions, and much more.
-->

<span class="sidenote-left">
    (_Note, Dec 14, 2024.)_ This blog post was originally published on my old blog about scientific animations which, in my naivety, I had written entirely in raw HTML, CSS, and JavaScript. Naturally, this did not scale. But since students still ask me how to use Matplotlib beyond the basics and how I make my figures and animations, I now took the time to reformat and release it here again. All of the graphics you see here (with exception of the Python logo) were created with Matplotlib. I hope it helps!
</span>
In this blog post you will learn the technical basics of how to create professional figures with [Python](https://www.python.org/) and Matplotlib. If you take only one idea out of this tutorial, let it be this:

**Do not trust the default! - Customize everything!**

Hence this tutorial is not oriented towards students just starting out and searching for coding advice or directions in how to set up their environment. - If however you already have some experience coding and using Python, and you want to start visualizing your data or simulation without moving to another tool, and do so properly, this is the guide you have been searching for.

<!-- Start of Selection -->
<div style="display: flex; margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 20px; width: 70px; filter: grayscale(100%);">
    <img src="/images/anim_science_imgs/python.png" alt="Python">
</div>
<!-- End of Selection -->

## Why choose Python with Matplotlib?

There are many great tools to create interactive visualizations and animations for science most notably _Mathematica_ and _Matlab_. Many academics in STEM use them, but there is no discussion that if you want to create beautiful, solid and creative visualizations that are to be published, _Matplotlib_ is the way to go.
      
It offers the precision other tools lack and creates clean plots without aliasing, correct vectorizations and formatting no matter what backend. There is nothing you can't access and thus you can customize anything you desire. Every single plot object like figures and axes or even individual ticks, lines, labels or points can be changed to fit your needs.

All of that can be done with Python which is the most popular programming language in STEM research mostly because it's very high level and therefore very easy to use especially for bigger projects. It offers a wide range of other modules besides Matplotlib that can be imported to extend it's functionality and the community is working relentlessly to enable anyone to do anything with Python. You want to create and test new algorithms and design circuits for quantum computing? You want to prototype custom machine learning models as fast as possible? Analyze big data? Run with Python.
      
Both are completely free for everyone.
<!-- Start of Selection -->
<div style="display: flex; margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 20px; width: 70px; filter: grayscale(100%);">
    <img src="/images/anim_science_imgs/matplot.png" alt="Matplot">
</div>
<!-- End of Selection -->

## How do I work through this?

I encourage you to create a Jupyter notebook for this particular tutorial so that you can play around with the given codesnippets and examples, but later on, when we start animating, it will be best to work with a simple editor and the terminal.

Please install Numpy as well if you dared not to do until now despite it being the fundamental Python package for scientific computing.

Do not use Pylab all the much if at all, please.

## The Matplotlib API

Most tutorials are very focused on very rudimentary aspects of this library or only show you a very special example. Let's do things differently and get at least some overview so that we can actually form the general understanding we need to truly be able to grow our plotting powers.

With Matplotlib you have access to [56 submodules](https://matplotlib.org/3.2.0/api/index.html).

You might find this a bit overwelming at first, but the module is carefully desgined to be very **object oriented** and the naming conventions are mostly quite intuitive as you will realize soon. In fact, you won't even really have to understand anything at first, because you can simply load [matplotlib.pyplot](https://matplotlib.org/3.2.1/api/pyplot_summary.html) for a **command line approach** which makes it very easy to get the basics done quickly. (Sadly Matplotlib's biggest issue is it's [**API**](https://matplotlib.org/3.2.1/api/index.html#usage-patterns). This is mostly because it is heavily influenced by Matlab.) These two aspects, the `pyplot` and the object oriented approach are the most common ways of using this vast library.


## Primitives & Containers

In Matplotlib objects are seperated into primitives and containers.

"The primitives represent the standard graphical objects we want to paint onto our canvas: Line2D, Rectangle, Text, AxesImage, etc., and the containers are places to put them (Axis, Axes and Figure). The standard use is to create a Figure instance, use the Figure to create one or more Axes or Subplot instances, and use the Axes instance helper methods to create the primitives." <a href="https://matplotlib.org/3.2.1/api/index.html#usage-patterns"  target="_blank"> Read more.</a>

Most of the time we will be interested in customizing the primitives like the font family of a text or the thickness and color of a line.


## Artist Objects
<!--https://matplotlib.org/3.2.0/tutorials/intermediate/artists.
html-->
The class from which all other objects inherit their basic properties is the artist. It's list of basic options to configure is quite long. You can use <a href="https://matplotlib.org/3.2.0/api/_as_gen/matplotlib.artist.getp.html#matplotlib.artist.getp" target="_blank"> `matplotlib.artist.getp()` </a> to print out the properties of any object. This way you may change the background colors, the positioning order / z-order or fix objects so that they don't get animated etc..
In general, properties of any object 'o' can be changed with `o.set(alpha=0.5, animated=False)` for example.

The reason for why it is called Artist is that this is where Matplotlib defines how to render objects to the canvas.

## <a href="https://matplotlib.org/3.2.1/api/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure" target="_blank">The Figure</a> & <a href="https://matplotlib.org/3.2.1/api/axes_api.html#matplotlib.axes.Axes" target="_blank">Axes</a>

The complete image we create is the `matplotlib.figure.Figure`, and it holds all the axes objects.

<div style="display: flex; margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 20px; width: 100%;">
    <img src="/images/anim_science_imgs/E6.svg" alt="E6">
</div>

The axes container holds the vast majority of all the objects used in a figures. Here we can directly add our data and create a plot, which makes this object the center of our attention most of the time. There are a bunch of helper methods like `ax.plot()`, `ax.scatter()` or `ax.imshow()` which enable the display of your data inside these containers. We do not have to limit ourselves to simple x-y-plots, yet as the name of this object also tells us, there are still the axis container that we have to explore:

## <a href="https://matplotlib.org/3.2.1/api/axis_api.html?highlight=axis#module-matplotlib.axis" target="_blank">Axis</a> & <a href="https://matplotlib.org/3.2.1/api/axis_api.html?highlight=tick#matplotlib.axis.Tick" target="_blank">Ticks</a>

The Axis is the place where our data is actually stored and will be generated automatically by the named helper methods. This instance of the Artist then draws the tick lines, the grid lines, the tick labels as well as the axis label, which can then be customized separately, too!

<div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
    <img src="/images/anim_science_imgs/E7.svg" alt="E7">
</div>

The then created Tick object is the container which holds these tick and grid line instances, and also the label instances to name each axis.
We will learn to customize all of those soon!

## Filling Figures
Let's start at the top by defining our figure. We'll then be adding axes or subplots, fill it with the data and then fine tune the details! - After importing the helpful little `pyplot` submodule as `plt`, we create our figure, define the axes independently and then add them together by writing:

```python
import matplotlib.pyplot as plt

# create figure
fig = plt.figure(figsize=(2.5,2.5), dpi=200)

# define axes
ax1 = plt.Axes(fig=fig, rect=[0.75, 0.75, 0.5, 0.5], facecolor='crimson')
ax2 = plt.Axes(fig=fig, rect=[0, 0, 1, 1], facecolor='steelblue')

# add axes to figure
fig.add_axes(ax2)
fig.add_axes(ax1)

plt.show()
```

Which returns a plot similar to the one shown here:

<!-- Start of Selection -->
<div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
    <img src="/images/anim_science_imgs/E5.svg" alt="E5">
</div>
<!-- End of Selection -->

Here is a nice <a href="https://matplotlib.org/matplotblog/posts/an-inquiry-into-matplotlib-figures/" target="_blank">post on figures</a>. - In some of the examples we will visualize the propagation of a simulation and then measure a few features we are interested in and plot them in an additional subplot next to the main one. This comes handy also when we want to plot a series of images from your animation in your paper.

## <a href="https://matplotlib.org/3.2.1/api/_as_gen/matplotlib.pyplot.subplots.html#matplotlib.pyplot.subplots" target="_blank">Subplots & the Grid</a>

I've already explained that Matplotlib uses the Axes container to hold and draw data. Multiple plots in a single figure are called _subplots_ and Matplotlib offers an additional functionality `add_subplot()` to simplify their creation.
   
Although both `add_axes()` and `add_subplot()` create a `matplotlib.axes.Axes` object, the way they do so is quite different. We can use `add_axes()` and specify the exact absolute position of the rectangle of this object on the canvas. But this results in us having to constantly tweak the positioning as the plot becomes more complicated. Instead of that, we might as well just call `add_subplot()` which handles the placing of axes objects in an even grid with a certain number of cells automatically. All we have to do is specify in which cell of the grid the axes should go. When creating subplots, this leaves enough space around the axes for the title, ticks and labels. The positioning changes dynamically as we continue to work on our figure.

<div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
    <img src="/images/anim_science_imgs/E9.svg" alt="E9">
</div>

Another nice way which allows for subplots to occupy multiple cells as seen in the image is `subplot2grid()`. The subplots span over several columns and rows of the grid. This functionality builds on another fundamental part, in fact, the grid itself.

## <a href="https://matplotlib.org/3.2.1/api/_as_gen/matplotlib.gridspec.GridSpec.html" target="_blank">GridSpec</a>

We can specify the geometry of the grid in which a subplot will be placed with `gridspec()`. But not just by defining the number of rows and columns. We can also specify where the grid should be placed and how much distance their should be between subplots etc. ... This allows us to become very creative with our grid designs. We can place multiple grids in a figure and even grids inside grids!

<div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
    <img src="/images/anim_science_imgs/E10.svg" alt="E10">
</div>

The basic procedure here goes as follows:

```python
import matplotlib.pyplot as plt

# create figure
fig = plt.figure(figsize=(6,8), constrained_layout=False)

# define grid specifications
gs = fig.add_gridspec(nrows=3, ncols=3, left=0.2, right=0.90, wspace=0.6)

# add subplots to the grid
ax1 = fig.add_subplot(gs[:-1, :])
ax2 = fig.add_subplot(gs[-1, :-1])
ax3 = fig.add_subplot(gs[-1, -1])

plt.show()
```
      
Go on and test it out. It can easily be extended for more complicated grid arrangements. <a href="https://matplotlib.org/3.2.1/tutorials/intermediate/gridspec.html" target="_blank">Read more.</a>

After adding the grid specifications, embedding axes as subplots on the grid or grids and filling in the data, then - if the general ratios of the image seem right - we start finalizing the details.

## Plotting Details
I assume you already know about the basics of changing line and dot colors and thickness. Since this information is so widely spread throughout the internet I won't bother talking about it. Yet, a few other very simple things are not talked about that much starting with limits of the axes.

<!-- LIMITS 
<hr>
<p><b><a>Limits</a></b></p>
-->

### <a href="https://matplotlib.org/3.2.1/api/ticker_api.html" target="_blank">Ticks</a>

They are small but well formatted ticks are integral for publishing-ready figures and again Matplotlib enables us to fully configure them, both major and minor ticks independently. 

**Tick formatters** can be used to change their appearance the way we want, deleting the labels on the ticks, display them as percentages and <a href="https://matplotlib.org/3.2.1/api/ticker_api.html" target="_blank">more</a>.

**Tick locators** are used to specify where ticks should appear. These derive from the base class **matplotlib.ticker.Locator**.

<div style="text-align: center; margin-top: 20px; margin-bottom: 20px; margin-left: auto; margin-right: auto; width: 80%;">
    <img src="/images/anim_science_imgs/E11.svg" alt="E11">
</div>

(**Note**: Because handling dates as ticks can be especially tricky matplotlib provides additional locators in <a href="https://matplotlib.org/3.2.1/api/dates_api.html" target="_blank">matplotlib.dates</a>. Read <a href="https://matplotlib.org/3.2.1/gallery/text_labels_and_annotations/date.html" target="_blank">more</a>)

The tick locations can be changed either change the scaling when setting up the axes object like here:

```python
ax = plt.axes(xscale='log', yscale='log')
```

Or by importing the ticker class and adding one or two lines similar to this example:

```python
import matplotlib.ticker as ticker
ax.xaxis.set_major_locator(ticker.FixedLocator([0,0.4,0.7, 1]))
```

We can hide both ticks and labels using

```python
ax.xaxis.set_major_locator(plt.NullLocator())     # x-axis without ticks
ax.xaxis.set_major_formatter(plt.NullFormatter()) # x-axis without labels
```

The same holds true for minor ticks, which aren't visible by default.


### Spines
The spines are the lines that form the borders of the plot area. They are essentially the axes of the plot and can be customized to enhance the visual appeal of your figures. You can control the visibility, position, and appearance of spines using the `spines` attribute of the Axes object.

For example:

```python
import matplotlib.pyplot as plt

# Sample data
x = [1, 2, 3, 4, 5]
y = [2, 3, 5, 7, 11]

# Create a figure and axis
fig, ax = plt.subplots()

# Plot data
ax.plot(x, y)

# Customize spines
ax.spines['top'].set_visible(False)  # Hide the top spine
ax.spines['right'].set_visible(False)  # Hide the right spine
ax.spines['left'].set_color('blue')  # Change the color of the left spine
ax.spines['bottom'].set_color('green')  # Change the color of the bottom spine
ax.spines['left'].set_linewidth(2)  # Change the width of the left spine
ax.spines['bottom'].set_linewidth(2)  # Change the width of the bottom spine

# Set labels
ax.set_xlabel('X-axis Label')
ax.set_ylabel('Y-axis Label')

plt.show()
```

Here, we hide the top and right spines, change the color of the left spine to blue, and the bottom spine to green. Additionally, we adjust the line width of the left and bottom spines to make them more prominent.

## Text, Math & Annotations
Most of the time text of any kind won't be necessary or will in fact only confuse the recipient looking at the figure. Relevant text must usually be added next to the picture and not be a part of it as to not distract or confuse.

Nonetheless displaying some math, units and axes descriptions are essential. To keep the figure as visually clean as possible and get it's message across without throwing around with ugly fonts, we need to know how to customize these as well.

### <a href="https://matplotlib.org/3.1.0/api/font_manager_api.html#matplotlib.font_manager.FontManager" target="_blank">Fonts</a>

Matplotlib supports any type of font you throw at as long it is installed at your system and also a <a>.ttf</a> or <a>.afm</a> file. Here are a few more or less random examples: 

<div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
    <img src="/images/anim_science_imgs/text_sheet.png" alt="text_sheet">
</div>

Certain font families can change the personality of a plot drastically. In general, less is more, Comic Sans is a joke and if you can go without text, go without.

The general method of changing any text font to a new one (here 'fontname') goes somewhat like this:

```python
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm

prop = fm.FontProperties(fname='/usr/share/fonts/truetype/fontname.ttf')
plt.title('text', fontproperties=prop)

plt.show()
```

If a font is not rendered this may have two reasons. Matplotlib might either need to refresh it's font cache:

```python
matplotlib.font_manager._rebuild()
```

### Labels
Labels are essential for providing context to your plots. They help the viewer understand what the axes represent and what the data signifies. In Matplotlib, you can easily add labels to your axes using the `set_xlabel()` and `set_ylabel()` methods on the Axes object. Here’s how you can do it:

```python
import matplotlib.pyplot as plt

# Sample data
x = [1, 2, 3, 4, 5]
y = [2, 3, 5, 7, 11]

# Create a figure and axis
fig, ax = plt.subplots()

# Plot data
ax.plot(x, y)

# Set labels
ax.set_xlabel('X-axis Label')
ax.set_ylabel('Y-axis Label')

plt.show()
```

In this example, we create a simple line plot and add labels to both the x-axis and y-axis. This makes the plot more informative and easier to understand.

### Annotations
Annotations allow you to add notes or highlight specific points in your plot. This can be particularly useful for emphasizing important data points or providing additional information. You can use the `annotate()` method to add annotations to your plots. Here’s an example:

```python
import matplotlib.pyplot as plt

# Sample data
x = [1, 2, 3, 4, 5]
y = [2, 3, 5, 7, 11]

# Create a figure and axis
fig, ax = plt.subplots()

# Plot data
ax.plot(x, y)

# Annotate a specific point
ax.annotate('Important Point', xy=(3, 5), xytext=(4, 6),
             arrowprops=dict(facecolor='black', shrink=0.05))

plt.show()
```

In this example, we annotate the point (3, 5) with a label "Important Point" and an arrow pointing to it. This helps draw attention to significant data points in your visualization.

### Text
Adding text to your plots can provide additional context or explanations. You can use the `text()` method to place text at specific coordinates within your plot. Here’s how to do it:

```python
import matplotlib.pyplot as plt

# Sample data
x = [1, 2, 3, 4, 5]
y = [2, 3, 5, 7, 11]

# Create a figure and axis
fig, ax = plt.subplots()

# Plot data
ax.plot(x, y)

# Add text to the plot
ax.text(3, 6, 'This is a text annotation', fontsize=12, color='blue')

plt.show()
```

In this example, we add a text annotation at the coordinates (3, 6) with a specified font size and color. This can be useful for providing explanations or highlighting specific aspects of your data.

### Math
Matplotlib also supports LaTeX-style math expressions, allowing you to include mathematical notation in your plots. To use LaTeX formatting, you can set the `usetex` option in the `rc` module. Here’s an example of how to include a mathematical expression in your plot:

```python
# for LaTeX font
from matplotlib import rc
rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
rc('text', usetex=True)
```

we can add <a href="https://www.latex-project.org/"> LaTeX </a> equations to our plot. For example, we may write

```python
# red LaTeX expression
plt.text(0.25,8.5,r"$(x-1)^3 + 1$", color="crimson", size=15)
```

to plot the expression $$(x-1)^3 + 1$$ at the center of a given plot.

<div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
    <img src="/images/anim_science_imgs/E1.svg" alt="E1">
</div>

By changing the rc parameters you have now made changes to the style. To reverse this, you can use <a href="https://matplotlib.org/3.2.0/api/style_api.html" target="_blank"> `matplotlib.style.use('default')` </a> or <a href="https://matplotlib.org/api/_as_gen/matplotlib.pyplot.rcdefaults.html" target="_blank"> `rcdefaults()` </a> to restore the default rc parameters.


## Style

It turns out that Matplotlib already has a big <a href="https://matplotlib.org/3.2.0/gallery/style_sheets/style_sheets_reference.html" target="_blank">library of styles</a> you can choose from at the beginning of you script. Just like we reset the style in the previous section we can import a style by writing: 

```python
matplotlib.style.use('ggplot')
```

(In this case, the imported changes to the style are designed to emulate the look of a plotting package for R.) We can also load multiple styles one after another to create mixed versions where each following loaded style overwrites some special rc parameters. Please take a peak at the <a href="https://matplotlib.org/3.2.0/gallery/style_sheets/style_sheets_reference.html" target="_blank">style sheets</a> but don't think we are finished here. A master of his craft creates his own defining style. Let's look at how we can write our own that we can save as a seperate file and then simply load with this one line.

## What's Next?
I hope you have learned a couple of things about the Matplotlib API. If you want to learn more, I recommend you to read the <a href="https://matplotlib.org/stable/tutorials/index.html" target="_blank">tutorials</a> and <a href="https://matplotlib.org/3.2.0/gallery/index.html" target="_blank">gallery</a> sections of the Matplotlib documentation. And if you really want to level up your Matplotlib skills, I recommend you to read the <a href="https://github.com/rougier/scientific-visualization-book?tab=readme-ov-file" target="_blank">Scientific Visualization Book</a> by Nicolas P. Rougier[^SciVisBook].

[^SciVisBook]: Nicolas P. Rougier, *Scientific Visualization: Python & Matplotlib*, 2019, 978-2-9579901-0-8, _hal-03427242_, [https://github.com/rougier/scientific-visualization-book](https://github.com/rougier/scientific-visualization-book)


