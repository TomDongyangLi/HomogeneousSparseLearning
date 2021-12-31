# HomogeneousSparseLearning

## Homogeneous Sparse Learning&mdash; Official Matlab Implementation

### Update

- 2021.12.30 ---  A basic framework .

### Requirements

* macOS Big Sur is supported. 
* Matlab R2020b installation. 

### Features


### Quick Start


#### How to run experiments on different prepared dataset

1. Run the **Startup_AddPaths.m** to add all the folders.

2. Modify the parameters in the **OD_def.m** file.
   Systems are generally considered by their interaction law and the parameters {d,N,M,L,\sigma}, or dimension, number of particles, number of initial conditions, number of time steps, and noise level. These system parameters are defined in OD_def.m as sysInfo.d, sysInfo.N, sysInfo.M, length(obsInfo.time_vec), and obsInfo.obs_noise. takes parameters of the form "xey", where x, y are real numbers, x is nonnegative. E.g. 0.001=1e-3.
   
3. Run **Run_SparseLearning_singleset.m** to see the interaction law approximation and trajectory visualization with parameters from **OD_def.m**.

4. Run **Run-SparseLearning_mprog.m** to see how this approximation improves as M increases.

### Acknowledgement

