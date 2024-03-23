# Active learning algorithm Opax
Optimistic active exploration using a GP Model

Here I implement an algortihm called OPAX from the following paper 
"optimistic active exploration of dynamical systems" and then I compare it
to different Active learning algorithms.

The OPAX algorithm for active dynamics learning is implemented in MATLAB.
In our case, we do not use any stochastic elements so we do not use the expeted
value neither the noise.
The implementation begins by initializing a system model and generating an initial
training set of state transitions from randomly sampled control inputs. A Gaussian
process (GP) which represents the dynamics model model is fitted to this training
data to capture a probabilistic model of the system dynamics.
Then, in a loop, the algorithm solves the optimal control problem (2.3) over a
horizon N that aims to maximize an information-gathering objective based on the
GP model’s uncertainty and also while respecting the optimization constraint (2.4).
This optimization is done with fmincon, while the GP is fit using the predefined
MATLAB statistics toolbox function fitrgp.
This objective exploits areas of high variance, which corresponds to uncertainty in
the model to improve learning.
The selected control input from the optimization is then applied to the system,
a new state transition is observed, and the GP model is updated with this new
additional data.
Importantly, constraints are included in the optimal control problem based on
the GP’s predictions to ensure safety during this exploration process. These con-
straints are user defined in the code and can be updated. For the implementation
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
