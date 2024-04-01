# OPAX Algorithm Implementation

## Overview

This repository contains an implementation of the OPAX (Optimistic Active Exploration of Dynamical Systems) algorithm in MATLAB.

### Description

The OPAX algorithm is designed for active dynamics learning in dynamical systems. It utilizes a Gaussian process (GP) to model system dynamics and employs an information-gathering objective to guide exploration. This implementation follows the methodology described in the paper, with the following key steps:

1. **Initialization:** Initialize system model and generate an initial training set.
2. **Model Fitting:** Fit a Gaussian process (GP) to the training data.
3. **Optimal Control:** Solve an optimal control problem to maximize information gain while respecting constraints.
4. **Exploration and Safety:** Apply selected control inputs to the system, update GP model, and ensure safety during exploration.
5. **Trajectory Planning:** Generate planned trajectory targeting high uncertainty regions and execute on the true system.
6. **Model Evaluation:** Evaluate final GP on held-out test set using mean-squared error.

## Usage

### Getting Started

To use this implementation, follow these steps:

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/aymen5507/optimistic-active-learning.git
    ```

2. Open MATLAB and navigate to the cloned repository.

3. Run the `opax_algorithm.m` script to execute the OPAX algorithm.

4. Adjust parameters and settings as needed for your specific application.

## Requirements

- MATLAB R2019b or later
- MATLAB Statistics and Machine Learning Toolbox

## Acknowledgements

- This implementation is based on the OPAX algorithm described in the paper "Optimistic Active Exploration of Dynamical Systems".

## Contact

For questions or feedback, please contact me.
