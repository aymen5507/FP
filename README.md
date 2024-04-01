#OPAX Algorithm Implementation
This repository contains an implementation of the OPAX (Optimistic Active Exploration of Dynamical Systems) algorithm in MATLAB. The OPAX algorithm is described in the paper "Optimistic Active Exploration of Dynamical Systems," and this implementation aims to replicate the algorithm's functionality as outlined in the paper.

Overview
The OPAX algorithm is designed for active dynamics learning in dynamical systems. It utilizes a Gaussian process (GP) to model system dynamics and employs an information-gathering objective to guide exploration. This implementation follows the methodology described in the paper, with the following key steps:

Initialization: Initialize system model and generate an initial training set.
Model Fitting: Fit a Gaussian process (GP) to the training data.
Optimal Control: Solve an optimal control problem to maximize information gain while respecting constraints.
Exploration and Safety: Apply selected control inputs to the system, update GP model, and ensure safety during exploration.
Trajectory Planning: Generate planned trajectory targeting high uncertainty regions and execute on the true system.
Model Evaluation: Evaluate final GP on held-out test set using mean-squared error.
Usage
To use this implementation:

Clone this repository to your local machine:

bash
Copy code
git clone https://github.com/username/opax-algorithm.git
Open MATLAB and navigate to the cloned repository.

Run the opax_algorithm.m script to execute the OPAX algorithm.

Adjust parameters and settings as needed for your specific application.

Requirements
MATLAB R2019b or later
MATLAB Statistics and Machine Learning Toolbox
License
This project is licensed under the MIT License.

Acknowledgements
This implementation is based on the OPAX algorithm described in the paper "Optimistic Active Exploration of Dynamical Systems".
s. These constraints are user defined in the code and can be updated. For the implementation
we used infinity.
This results in a planned trajectory targeting high uncertainty regions of the state
space.
This planned trajectory is then rolled out on the true system using the utilize
control function.
Noise is added and the resulting state transitions are appended to the dataset.
The GP is fitted again with the new data to reduce uncertainty.
After OPAX learning, the final dynamics GP is evaluated on a held-out test set.
The mean-squared error between GP predictions and ground truth on test data
will be used as a performance metric for the algorithm’s efficiency.
The implementation could be extended by testing on higher-dimensional systems.
The current simplicity allowed rapid debugging and experimentation.
Overall, the MATLAB implementation realizes the core OPAX algorithm using
available toolboxes, and evaluates the algorithms using the mean squared error
method.
