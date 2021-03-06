  %
% RunExamples for the main cases
clear all;
close all;

%% Set 2parameters
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; else, SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end % Please keep this fixed, simply create a symlink ~/DataAnalyses pointing wherever you like
VERBOSE                         = 1;                                                                % indicator to print certain output
time_stamp                      = datestr(now, 30);
if ~exist('Params','var'), Params = [];     end
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
%Examples                        = LoadExampleDefinitions();
%ExampleIdx                      = SelectExample(Params, Examples);

%% Get example parameters
%Example                         = Examples{3};
Example = OD_def();% LJ_Def
sysInfo                        = Example.sysInfo;
solverInfo                     = Example.solverInfo;
obsInfo                        = Example.obsInfo;   % move n to learn_info

obsInfo.VERBOSE                = VERBOSE;
obsInfo.SAVE_DIR               = SAVE_DIR;
obsInfo.MrhoT = 10; % to generate rhoT


if obsInfo.obs_noise>0
    obsInfo.use_derivative     = true;
end


%% begin to do sparsty learning
saveON=0;
plotON=0;

% number of independent trials
num_trials=1;

errLS       = zeros(num_trials,1);
errSLS      = zeros(num_trials,1);
errLASSO    = zeros(num_trials,1);

for k=1:num_trials

    [dxpath_test,xpath_test,dxpath_train, xpath_train]=Generate_training_data(sysInfo,obsInfo,solverInfo);
    
    rho_emp = rho_empirical(xpath_train,sysInfo,obsInfo,saveON,plotON);% empirical pairwise distance
    
    dxpath_train= trajUnifNoiseAdditive(dxpath_train, obsInfo.obs_noise);
    
    
    
    
    fprintf('\n Done! begin to learn ......');
    
    %% manual parameters to set
    lib.exporder = 5;       % exponent order; r.^i
    lib.usesine = 400;        % sine function; sin(i*r)
    lib.usecos = 400;         % cosine function; cos(i*r)
    lib.ratexp = 0;         % rational functions; r.^(-i) 
    lib.chebyorder = 0;     % chebyshev polynomial of first kind
    lib.legorder = 0;       % legendre polynomial of first kind
    lib.cosker = 0;         % cosine kernel function; cos(pi*r/2), 0<r<1
    
    % creates library of n amount of functions psi
    psiLib = poolPsi(lib);
    
    % add the coefficient 
    truec =[0 1 zeros(1,lib.exporder-1) 2 zeros(1,lib.usesine-1) 0 -4 zeros(1,lib.usesine-2)]';
    
    
    % Least squares
    cLS = findC_LS(xpath_train,dxpath_train,sysInfo,psiLib);
    %iisualizeC(psiLib,cLS,lib,'Using Least Squares');
    
    %
    % Lasso
    cLASSO= findC_LASSO(xpath_train,dxpath_train,sysInfo,psiLib);
    %ssualizeC(psiLib,cLASSO,lib,'Using Lasso');
    
    % Sequential least squares
    lambda = 1e-3;          % threshold parameter for SLS
    cSLS = findC_SLS(xpath_train, dxpath_train, sysInfo,psiLib,lambda);
    %visualizeC(psiLib,cSLS,lib,'Using Sequential Least Squares');
    
    
    % plot the kernel and compute the error metric
    rspan= [rho_emp.edgesSupp(1),rho_emp.edgesSupp(end)];
    plotKernel(sysInfo.phi{1},cLS,cSLS,cLASSO,psiLib,rspan);
    
    errLS(k) = norm(cLS-truec)./norm(truec);
    errSLS(k)= norm (cSLS-truec)./norm(truec);
    errLASSO(k)= norm(cLASSO-truec)./norm(truec);

end


% compute the etimators using the learned coefficient
idenLS =@(r) construct_estimators(cLS,psiLib,r);
idenSLS =@(r) construct_estimators(cSLS,psiLib,r);
idenLASSO =@(r) construct_estimators(cLASSO,psiLib,r);

% Compute the trajectory errors and make predictions
LS_traj    = construct_and_compute_traj(sysInfo,idenLS,obsInfo,solverInfo, xpath_train(:,1,:));
SLS_traj   = construct_and_compute_traj(sysInfo,idenSLS,obsInfo,solverInfo, xpath_train(:,1,:));
LASSO_traj = construct_and_compute_traj(sysInfo,idenLASSO,obsInfo,solverInfo, xpath_train(:,1,:));

newinitial = sysInfo.mu0();
LS_traj_test    = construct_and_compute_traj(sysInfo,idenLS,obsInfo,solverInfo, newinitial);
SLS_traj_test   = construct_and_compute_traj(sysInfo,idenSLS,obsInfo,solverInfo, newinitial);
LASSO_traj_test = construct_and_compute_traj(sysInfo,idenLASSO,obsInfo,solverInfo, newinitial);

 
% visualize the trajectory 
visualize_trajs_2D(sysInfo,idenLS,obsInfo,solverInfo,xpath_train);
visualize_trajs_2D(sysInfo,idenSLS,obsInfo,solverInfo,xpath_train);
visualize_trajs_2D(sysInfo,idenLASSO,obsInfo,solverInfo,xpath_train);

