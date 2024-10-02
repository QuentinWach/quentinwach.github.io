---
layout: post
mathjax: true
title:  "Solving Massive Systems of Linear Equations with Deep Learning"
description: "To give some background: systems of linear equations show up everywhere (and systems of non-linear equations can often be linearized), for example, in solving a constraint mechanical system as I discussed in my previous introduction to constrained dynamics. A variety of methods can be used to solve such systems, e.g. Gaussian elimination, the Conjugate Gradient Method, the Gauss-Seidel Method, Position-Based Dynamics, or Impulse-Based solvers. Yet, all of them are relatively inefficient and do not scale well to extremely large systems."
date:   2024-09-29 20:38:24 +0100
authors: ["Quentin Wach"]
tags: ["physics", "deep-learning"]
tag_search: true
image:     ""
weight:
note: 
categories: "blog"
---
Systems of linear equations are fundamental in various fields of mathematics, physics, and engineering. They are typically represented in matrix form as:[^syslin_wiki]

$$
\hat{A} \cdot \vec{\lambda} = \vec{b}
$$

where $$\hat{A}$$ is an $$m \times n$$ matrix, $$\vec{\lambda}$$ is an $$n$$-dimensional vector of unknowns, and $$\vec{b}$$ is an $$m$$-dimensional vector of constants. (And indeed systems of non-linear equations can often be linearized). These systems appear in numerous applications, including solving constraint mechanical systems, as I discussed in my previous introduction to constrained dynamics[^QWConstrained], electrical circuit analysis, economic models, computer graphics and image processing, or machine learning and optimization problems.

A variety of methods can be used to solve such systems. Yet, all of them are relatively inefficient and do not scale well to extremely large systems. While matrix multiplications are extremely well parallelized, making them really fast on GPUs, and kick-starting the AI/deep learning revolution, this isn't true of solving linear systems and matrix inversion which can be orders of magnitude slower than matmuls.

>"99% of the complexity of rigid body formulations comes from using global solvers!" says Matthias Müller-Fischer[^MatRigidBody].

The list of other challenges regarding global solvers fills books. As such many variations and optimizations of these methods exist to improve their scaling, stability, accuracy, convergence times and so on. And while the list of classical methods to improve these solvers is long, deep learning is still a relatively unexplored path, it seems to me, yet a very promising one!

Let's first get a little bit of an overview of classical methods.

### Classical Solvers
**Gaussian Elimination** is a direct method that transforms the augmented matrix $$[\hat{A}|\vec{b}]$$ into row echelon form. The **Conjugate Gradient Method** on the other hand is iterative method particularly effective for sparse, symmetric, positive-definite matrices. The **Gauss-Seidel Method** is an iterative method that updates each component of $$\vec{\lambda}$$ using the latest available values of other components.

Global solvers, like Gaussian elimination, consider the entire system at once. Local solvers, like the Gauss-Seidel method, focus on solving one equation at a time. The Gauss-Seidel method, for instance, iterates through the system:

For the $i$-th equation:

$$
\lambda_i = \frac{1}{a_{ii}} \left(b_i - \sum_{j<i} a_{ij}\lambda_j - \sum_{j>i} a_{ij}\lambda_j^{(k-1)}\right)
$$

Where $$\lambda_j^{(k-1)}$$ is the value from the previous iteration.
##### Code for Gaussian Elimination, Conjugate Gradient Method, and Gauss-Seidel Method

##### Results & Comparison
This comparison is meant to be taken with a grain of salt since the software and hardware implementation play a huge role in how well these methods perform. 

First, we compare Gaussian elimination, an LU decomposition-based solver, the conjugate gradient method and the Gauss Seidel method for dense random matrices.

<div style="text-align: center;">
    <img src="/images/classic_solv_dense.png" alt="centerAI" style="width: 100%; border-radius: 5px; margin-bottom: 10px; margin-top: 10px;">
</div>

<div style="text-align: center; margin-bottom: 15px;">
    <span style="font-size: 14px;">
        My first shader, red drops moving from right to left, merging and splitting smoothly.
    </span>
</div>

The iterative methods come with some overhead and thus perform worse for smaller matrices but then start outperforming the global solvers for matrices of larger sizes.

Below you can see a sparse matrix where most values are zero or close to zero and only values close to the diagonal of the matrix are large and contribute to the system of equations:

<div style="text-align: center;">
    <img src="/images/sparse_matrix.png" alt="centerAI" style="width: 50%; border-radius: 5px; margin-bottom: 10px; margin-top: 10px;">
</div>

<span style="font-size: 14px;">
    The amount of compute required to train (a) neural network and do inference (b) after training.
    This figure was created by myself but the data was compiled by Jaime Sevilla et al.[^AIDemand_Data_1][^AIDemand_Data_2].
</span>


Such matrices are very common e.g. in mechanical systems and the iterative solvers tend to perform much better for such matrices as well.


### Direct Approximation with a Neural Network
The most straightforward approach [^TUMNeuralApprox] is to train a neural network to directly approximate the solution $$\vec{\lambda}$$ with a neural network $$f_\theta$$ :
$$
\vec{\lambda} \approx f_\theta(\hat{A}, \vec{b}).
$$
Here, the network may simply be trained to minimize the loss
$$
L = \|\hat{A} \cdot f_\theta(\hat{A}, \vec{b}) - \vec{b}\|^2.
$$
The two glaring issues that come with such an approach are that 1. the neural architecture must be designed for a specific system, and 2. even with training it is not guaranteed that it will generalize well enough to model all edge cases accurately.
##### Code
```python
import torch
import torch.nn as nn
import torch.optim as optim

# Define a simple neural network model
class NeuralSolver(nn.Module):
    def __init__(self):
        super(NeuralSolver, self).__init__()
        self.fc1 = nn.Linear(3, 10)
        self.fc2 = nn.Linear(10, 3)

    def forward(self, x):
        x = torch.relu(self.fc1(x))
        x = self.fc2(x)
        return x

# Initialize the model, criterion, and optimizer
model = NeuralSolver()
criterion = nn.MSELoss()
optimizer = optim.SGD(model.parameters(), lr=0.01)

# Training loop
for epoch in range(1000):
    # Forward pass
    outputs = model(A)
    loss = criterion(outputs, b)
    # Backward pass and optimization
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()

# Print the final output
print(outputs)
```

##### Results


### Deep Iterative Methods
Neural networks can also be used to enhance traditional iterative methods[^DeepIter]. We may train a neural network to generate effective _"preconditioners"_  $$P_\theta$$ for iterative methods like conjugate gradient. So instead of initializing the network randomly, we neural network gives us a good first guess:

$$
\vec{\lambda}_0 = P_\theta(\hat{A}, \vec{b}).
$$

This is basically the same idea as that of the direct neural network approximation and the returns are diminishing since, once we have the solution for a time-step $$t_1$$ we can use that to inform the new solution i.e. to initialize the solver to find the solution for $$t_2$$ which is likely close to that of $$t_1$$. So rather than just initializing, we may also use a network $$U_\theta$$ to learn a better update rules for iterative methods, in hopes to converge faster than the classical approaches:

$$
\vec{\lambda}_{k+1} = \vec{\lambda}_k + U_\theta(\hat{A}, \vec{b}, \vec{\lambda}_k, \vec{r}_k).
$$

(Here, $\vec{r}_k = \vec{b} - \hat{A}\vec{\lambda}_k$ is the residual.)

##### Code

##### Results

### Autoencoder for Dimensionality Reduction
For high-dimensional problems, neural networks can be employed for dimensionality reduction[^GU_DNNSolve]. An encoder network $$E_\theta$$: $$\mathbb{R}^n \rightarrow \mathbb{R}^k$$ (where $k < n$) can be used to project the high-dimensional problem into a lower-dimensional space. We then solve the reduced problem using traditional methods or other neural network approaches and a decoder network $$D_\phi$$: $$\mathbb{R}^k \rightarrow \mathbb{R}^n$$ is used to reconstruct the full-dimensional solution as the final step. The reduced problem becomes:

$$
E_\theta(\hat{A}) \cdot \vec{\lambda}_\text{reduced} = E_\theta(\vec{b}).
$$

And the solution is reconstructed as:

$$
\vec{\lambda} = D_\phi(\vec{\lambda}_\text{reduced}).
$$

##### Code

##### Results

### Physics-Informed Neural Networks (PINNs)
PINNs (also known as _"Theory-Trained Neural Networks"_[^PINN_Wiki]) on the other hand don't merely learn from the error signal of the training data but they incorporate the physical constraints of the problem into the neural network[^PINN_1][^PINN_Nature][^PINN_Proteins][^PINN_Raissi]. 

For a differential equation $$\mathcal{N}[u] = 0$$, the PINN loss might be:

$$
L = \underbrace{\sum_i |\mathcal{N}[u_\theta](x_i)|^2}_\text{Physics-based loss} + \underbrace{\sum_j |u_\theta(x_j) - u(x_j)|^2}_\text{Data-based loss}
$$

Where $$u_\theta$$ is the neural network approximation of the solution.

##### Code

##### Results

### Conclusion

##### All Results


Not only do neural networks allow us to efficiently fight the curse of dimensionality but they are also inherently faster to execute on available hardware i.e. GPUs since running neural networks consists largely of matmul operations. But how can we ensure accuracy and allow for these methods to be adaptable to arbitrary systems or arbitrary dimensions?


---
[^QWConstrained]: Quentin Wach, _"Constrained Dynamics"_, 2024
[^MatRigidBody]: [Matthias Müller-Fischer, _"SCA2020: Detailed Rigid Body Simulation with Extended Position Based Dynamics"_, https://www.youtube.com/watch?v=zzy6u1z_l9A, 2020. (Accessed Sep. 29, 2024)](https://www.youtube.com/watch?v=zzy6u1z_l9A)
[^TUMNeuralApprox]: [Iremnur Kidil, _"Neural Networks Solving Linear Systems"_, TU München, 2021, https://mediatum.ub.tum.de/doc/1632857/kwo12gbs02f2xqp5euupmw2y9.pdf (Accessed Sep 30, 2024](https://mediatum.ub.tum.de/doc/1632857/kwo12gbs02f2xqp5euupmw2y9.pdf)
[^PINN_1]: [Computational Physics, _"Solving Differential Equations with Deep Learning"_, https://compphysics.github.io/MachineLearning/doc/LectureNotes/_build/html/chapter11.html#, (Accessed Sep 30, 2024)](https://compphysics.github.io/MachineLearning/doc/LectureNotes/_build/html/chapter11.html#)
[^PINN_Nature]: [George Em. Karniadakis et al., _"Physics-informed machine learning"_, Nature Reviews Physics, 2021](https://www.nature.com/articles/s42254-021-00314-5)
[^PINN_Proteins]: [Freyr Sverrisson et al., _"Physics-informed Deep Neural Network for Rigid-Body Protein Docking"_, ICLR, 2022](https://openreview.net/pdf?id=5yn5shS6wN)
[^PINN_Wiki]: [Wikipedia, _"Physics-informed neural networks", https://en.wikipedia.org/wiki/Physics-informed_neural_networks (Accessed September 30, 2024)](https://en.wikipedia.org/wiki/Physics-informed_neural_networks)
[^PINN_Raissi]: [Maziar Raissi et al., _"Physics Informed Deep Learning (Part I): Data-driven Solutions of Nonlinear Partial Differential Equations"_, Arxix: https://arxiv.org/pdf/1711.10561 (Accessed Sep. 30, 2024)](https://arxiv.org/pdf/1711.10561)
[^syslin_wiki]: [Wikipedia, _"System of linear equations"_, https://en.wikipedia.org/wiki/System_of_linear_equations (Accessed Sep 30, 2024)](https://en.wikipedia.org/wiki/System_of_linear_equations)
[^DeepIter]: [Yiqi Gu, Michael K. Ng, _"Deep neural networks for solving large linear systems arising rom high-dimensional problems"_, https://arxiv.org/abs/2204.00313 (Accessed Sep 30, 2024)](https://arxiv.org/abs/2204.00313)
[^GU_DNNSolve]: [Yiqi Gu and Michael K. Ng, _"Deep Neural Networks for Solving Large Linear Systems Arising from High-Dimensional Problems"_, Siam J. Sci. Comput. Vol. 45, No. 5, 2023](http://yiqigu.org.cn/Linear_system.pdf)