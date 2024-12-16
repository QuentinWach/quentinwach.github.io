---
layout: post
mathjax: true
title:  "Building User-Friendly Applications: Development Summary"
description: "Where I explain how I created Quester the Anki killer, talking about the projects that lead up to it and the learning and development process filled with many mistakes and arbitrary decisions that might help you avoid the same pitfalls."
date:   2124-12-05 10:38:24 +0100
authors: ["Quentin Wach"]
tags: ["software"]
tag_search: true
image:     "/images/shader_2.png"
weight:
note: 
categories: "blog"
social_image: "/images/shader_2.png"
---
I believe any larger side-project that does not yet have a lot of momentum behind it should be approached as a series of micro-projects that can be completed within one or two sessions without breaks. This is how I approached the early development of Quester.

## Previous Projects
But even way before I started actively working on Quester, I was already thinking about it and variations of it. I am making glorious plans as one does to build a great product that people across the globe would love. Many years ago, friends and I would talk about knowledge manegement and study apps under a project I called _Ponder_. I bought domains like collab.science  thinking that one day, I will make some of these grant ideas real. Maybe I still will... A rather small idea that started to brew then was that of a study app like Anki which I was slowly developing a love-hate relationship with. 

_(Note: The following projects are script kiddy projects if anything so don't think I am bragging. But I do think it is relevant to mention them given that I was always thinking about something like Quester while working on these.)_

<!--
<div style="text-align: center;">
  <img src="/images/quester/miniarxiv.png" alt="Mini-ArXiv Image" style="height: auto; width: 100%; padding-bottom: 15px;" />
</div>
-->

### Merlin's Beard: The _Mini-ArXiv_
A long time ago, when LLMs were still unknown and software engineers were still using StackOverflow, I wrote a basic search engine / recommender system for papers from the ArXiv inspired by Andrej Karpathy's [min-ArXiv](https://github.com/karpathy/arxiv-sanity-preserver). This was my first exposure to Flask and I did not take this project all that seriously but it goes to show that I was always thinking about the problem of knowledge management.

To me, this project was largely an exercise in learning how to use Flask and improve my still basic html and css skills.


<div style="float: right; width: 50%; margin-left: 10px;">
  <img src="/images/quester/pdftocards.png" alt="PDFtoCards Image" style="height: auto;" />
</div>

### PDFtoCards
..., I wrote a Python script that converts PDFs into flashcards using the ChatGPT API and OCR to recognize and extract images and equations. Take any book or powerpoint and convert it into a deck of flashcards in seconds! I thought this would be super useful for studying. I spent way too much time trying to make this into a webapp but this was before AI-assisted coding and I did not want to bother learning advanced webdev at the time.

### Obsidian.ai
As I am writing daily markdown notes in [Obsidian](https://obsidian.md/), I also realized that there is a lot of clutter that could use some cleaning. My knowledge graph is more of a knowledge mess. Once again, LLMs are my friend and I can use them to clean up my mess. I mention this here because many years before when I first started thinking about tools for thought with my friends, we found that one key technology that was missing was some sort of semantic engine to create knowledge graphs from data. With LLMs, this is now largely solved and Obsidian.ai was a trivial but important project for me to remember that.

<div style="float: right; width: 50%; margin-left: 10px;">
  <img src="/images/quester/webiny.png" alt="Webiny Image" style="height: auto;" />
</div>

### Webiny
Realizing that I needed to learn how to build desktop apps, but not wanting to use Electron and Javascript, I started dabbling with PyQt for Python a bit to build a simple web browser one evening when I was really annoyed by being tracked by Google everywhere.


### Image Ranker
Soon later, another long frustration of mine of not being able to make decisions when there are many choices lead me to build a ranking app with a pretty GUI using Python and Flask. I added quite a few features to make it more useful and polished the GUI with some pretty CSS and animations. Proud of my work and seeing the utility in ranking images especially for curating image datasets for training image models, I went to Reddit and shared my project which got a lot of attention. I was flooded with messages, questions, and requests for more features many of which I implemented. Several people forked the project and some even contributed to it directly, a first for me. Excited, I bought a fitting domain,rented a Linode server, and started hosting this app there so it would be more accessible but realized that I would have to rewrite the ranking logic such that it would all happen on the frontend. Since I never even intended to push this project this far and only saw a way to monetize it using annoying ads, I was not motivated to continue the development so I have a long list of amazing features I can see myself implementing in the future.

<div style="text-align: center;">
  <img src="/images/quester/imageranker.png" alt="Image Ranker Image" style="height: auto; width: 85%; padding-bottom: 15px;" />
</div>

_(Sometimes, I still open up this app when my girlfriend and I are indecisive about which movie to watch or which dress to buy.)_

## Live Markdown Editor
On the Halloween evening of 2024, I built a [live markdown editor _**Markedit**_](https://github.com/QuentinWach/markedit) with LaTeX support. This was meant to be the first simple step towards a markdown-based flashcard app. It was built using Python, PyQt, and MathJax. I initialially attempted to build this with TKinter but realized that it did not support live html rendering with Javascript which was necessary for MathJax to render the LaTeX. I also wanted to be able to style the app using a CSS-like approach. So I switched to PyQt.


<div style="text-align: center;">
  <img src="/images/quester/mdedit.png" alt="Markedit Image" style="height: auto; width: 70%; padding-bottom: 15px;" />
</div>

I think this extremely simple editor is a good foundation for other future projects (e.g. I can see myself using it to build a little Jekyll blog editor) and it seemed like a neat example of how to use PyQt (though I realize my code is far from elegant).

## _Kartei_ Editor
That done, I quickly moved on, cloned the project, and started building a flashcard manager (German: _"Kartei"_) on top of the markdown editor the same evening. My to-do list was as follows:
+ [X] Create a deck.
+ [X] See an overview of all decks.
+ [X] Add cards to a deck.
+ [X] See an overview of all cards in a deck.
+ [X] Open to edit a card.

_(SHOW IMAGES HERE!)_

I was now able to create, edit, and manage flashcards using this simple app. Cards are simple markdown files and decks are folders.
This makes deck creation and management easy and intuitive.

## Study System
The next evening, I sat down to start working on the study flow which would complete the app and make it a basic Anki clone.
+ [X] Fix bug where the csv is not updated properly as we create new cards!
+ [X] Add button to rename cards.
+ [X] Add a new window for studying.
+ [X] When clicking a deck, start studying. Modifying the deck requires clicking a special button.
+ [X] Add Study algorithm with a meta data file for every deck.
+ [X] Implement SM-2 algorithm for scheduling reviews.
+ [X] Test and improve the SM-2 algorithm.
+ [X] Implement Anki's improved SM-2 algorithm.

_(SHOW IMAGES HERE!)_

This worked more or less though there were various bugs. Making the UI highly polished became increasingly tedious and thinking of all the modules I wanted to add still it seemed like a nightmare to implement this in Python. Additionally,I had trouble compiling the Python app into an .exe. I eventually concluded that a Python app was not the way to go if I wanted to take this project seriously and build a real product with cross platform support.

## Rewrite the App with Tauri and Rust
After a Saturday spent with my girlfriend and friends, and a Sunday of fighting a mean headache, I continued working on the project on the next Monday. I wanted to build the frontend/GUI with HTML/CSS/JS i.e. React and have a Rust + Python backend to handle the heavy lifting.
+ [X] Create Tauri project file with React frontend.
+ [X] Build a test project succesfully!
+ [X] Build a simple Markdown editor for testing.


<div style="text-align: center;">
  <img src="/images/quester/new_rust_editor.png" alt="Rust Editor Image" style="height: auto; width: 70%; padding-bottom: 15px;" />
</div>

Amazingly, using React allows for a much much better UI/UX than the Python/PyQt version. Debugging is also much easier. The modularity is also amazing. And now the flickering issue of the previous editor is gone, too! I also took the liberty to add a button to toggle the dark mode.

+ [ ] Add a styled title bar with close, minimize, and full-screen buttons.
+ [ ] Box inside editors to display they are front.
+ [ ] Style the boxes for better focus and interactivbilty.
+ [ ] Add a widget box that measures the complexity/difficulty of a card given the size!
+ [ ] Add word count to the editor.
+ [ ] Add import .md file option.
+ [ ] Add ability to drag and drop images into the editor.
+ [ ] Add button to change the .css style of the rendered markdown.
+ [ ] Add manual add card button.
+ [ ] Add clear card button.

I am pretty pissed off that I can't figure out how to get the file system API to work... Hours stuck on this! No AI is of any help here. So I guess I gotta boot up my good old brain and dust off Google to see if I can find a solution online. And indeed, [this article](https://medium.com/@richard.stromer/lets-learn-tauri-and-rust-by-building-an-ebook-manager-34c84e4b3788) talks about the same issue. [This video](https://www.youtube.com/watch?v=87SbZs-phmA) also seems to be valuable. So is [this documentation about the capabilities](https://v2.tauri.app/reference/acl/capability/).