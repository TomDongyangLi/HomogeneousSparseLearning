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

2. Modify the parameters in the **OD_def.m** file. The changable parameters are listed below.
   
   * sysINfo.d:            dimension 
   * sysINfo.N:            number of particle 
   * obsInfo.M:            number of initial condition 
   * obsInfo.time_vec:     training interval
   
   
3. Run **Run_SparseLearning_singleset.m** to see the interaction law approximation and trajectory visualiztion with parameters from **OD_def.m**.

4. Run **Run-SparseLearning_mprog.m** to see how this approximation increases as M improved.

### Acknowledgement

