# HomogeneousSparseLearning

## Homogeneous Sparse Learning&mdash; Official Matlab Implementation

### Update

- 2021.12.31 ---  A basic framework.

### Requirements

* macOS Big Sur is supported. 
* Matlab R2020b installation. 

### Quick Start

#### How to run experiments 

1. Run the **Startup_AddPaths.m** to add all the folders.

2. Modify the parameters in the **OD_def.m** file in **Examples** folder.
   Systems are generally considered by their interaction law and the parameters {d,N,M,L,\sigma}, 
      * sysInfo.d:            dimension
      * sysInfo.N:            number of particles
      * sysInfo.phi:          interaction law
      * obsInfo.M:            number of initial conditions
      * obsInfo.time_vec:     training interval (L=length(obsInfo.time_vec):number of time steps)
      * obsInfo.obs_noise:    noise level (takes parameters of the form "xey", where x, y are real numbers, x is nonnegative.  *E.g. 0.001=1e-3 and 0.0005=5e-4.*)
   
3. Run **Run_SparseLearning_singleset.m** to see the interaction law approximation and trajectory visualization with parameters from **OD_def.m**.

#### How to repoduce graphics and tables
###### (specifically firgure 4, table 3, and table 4)

1. Run **Run_SparseLearning_mprog.m** to see how this approximation improves as M increases.
      * automatically calculates the results in table 3.   
      * save data with different M listed in paper, then run **probplot.m** in **ploting** folder.

2. Run **Run_SparseLearning_trajctoryerrors** to see the trajactory prediction errors in the table 4. 

