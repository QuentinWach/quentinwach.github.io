---
layout: post
mathjax: true
title:  "Semantic Learning Using LLMs to Speed Up Spaced-Repetition"
date:   2024-02-04 20:38:24 +0100
author: Quentin Wach
categories: physics, note, quantum mechanics
---

* Do not remove this line (it will not be displayed)
{:toc}

### Introduction
Space-repetition is old. Super old. And indeed the open source versions of it have been outdated for decades. Modified versions use machine learning to optimize the algorithm to better estimate what topic a student should be questioned on and when to speed up and deepen his learning. But with very little improvement.

But now we have large language models (LLMs) that encode information semantically, meaning, topics that relate to each other are closely connected within the neural network's embedding space and we can even measure how similar topics are to others given that embedding and a simple metric.

$$
\begin{equation}
    \int_0^{\infty} x\; dx = \bigg[ \frac{1}{2}x^2 + C \bigg]_0^{\infty} \rightarrow \infty
\end{equation}
$$

### Second Part
The idea is now to generate a tree of knowledge of all the Anki cards in our decks to see how they relate to each other using an LLM. The algorithm can then update what we know with an extremely high precision and doesn't waste the student's time asking him the same questions over and over even though he already understands them!


![Figure1][Field Figure]
<center>Fig. 1: The Amazon Rainforest contains a multitude of species. </center>

[Field Figure]: /images/Field_Strength_V3_1.png

<div id="disqus_thread"></div>
<script>
    /**
     *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT 
     *  THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR 
     *  PLATFORM OR CMS.
     *  
     *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: 
     *  https://disqus.com/admin/universalcode/#configuration-variables
     */
    /*
    var disqus_config = function () {
        // Replace PAGE_URL with your page's canonical URL variable
        this.page.url = PAGE_URL;  
        
        // Replace PAGE_IDENTIFIER with your page's unique identifier variable
        this.page.identifier = PAGE_IDENTIFIER_2; 
    };
    */
    
    (function() {  // REQUIRED CONFIGURATION VARIABLE: EDIT THE SHORTNAME BELOW
        var d = document, s = d.createElement('script');
        
        // IMPORTANT: Replace EXAMPLE with your forum shortname!
        s.src = 'https://EXAMPLE.disqus.com/embed.js';
        
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
</script>
<noscript>
    Please enable JavaScript to view the 
    <a href="https://disqus.com/?ref_noscript" rel="nofollow">
        comments powered by Disqus.
    </a>
</noscript>