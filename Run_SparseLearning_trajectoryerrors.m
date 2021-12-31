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


%% Compute error with multiple Learning Trials
saveON=0;
plotON=0;

% number of independent trials
num_trials=10;

errLS       = zeros(num_trials,1);
errSLS      = zeros(num_trials,1);
errLASSO    = zeros(num_trials,1);
flag        = zeros(num_trials,1);
TrainingIC_train      = zeros(num_trials,1);
TrainingIC_predict    = zeros(num_trials,1);


for k=1:num_trials
    k
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
    lambda = 1e-3;          % threshold parameter for SLS
    
    
    % creates library of n amount of functions psi
    psiLib = poolPsi(lib);
    
    
    % Least squares
    
    cLS = findC_LS(xpath_train,dxpath_train,sysInfo,psiLib);
    
    %visualizeC(psiLib,cLS,lib,'Using Least Squares');
    
    %
    % Lasso
    
    cLASSO= findC_LASSO(xpath_train,dxpath_train,sysInfo,psiLib);
    %visualizeC(psiLib,cLASSO,lib,'Using Lasso');
    
    
    % Sequential least squares
    cSLS = findC_SLS(xpath_train, dxpath_train, sysInfo,psiLib,lambda);
    %visualizeC(psiLib,cSLS,lib,'Using Sequential Least Squares');
    
    
    % create the estimator and compute the coefficient error 
        
    idenLS =@(r) construct_estimators(cLS,psiLib,r);
    idenSLS =@(r) construct_estimators(cSLS,psiLib,r);
    idenLASSO =@(r) construct_estimators(cLASSO,psiLib,r);
    
    
    [errLS(k), errSLS(k), errLASSO(k)] = errornorms_phis(cLS,cSLS,cLASSO);
    
    % choose the estimators with best performance to find trajectory prediction errors for training interval
    switch min([errLS(k),errSLS(k),errLASSO(k)])
            case errLS(k)
                flag(k)=1;
                temp= construct_and_compute_traj(sysInfo,idenLS,obsInfo,solverInfo, xpath_train(:,1,:));    
                TrainingIC_train(k)       = temp.train_traj_error(1);
                TrainingIC_predict(k)     = temp.prediction_traj_error(1);
            case errSLS(k)
                flag(k)=2;
                temp= construct_and_compute_traj(sysInfo,idenSLS,obsInfo,solverInfo, xpath_train(:,1,:));    
                TrainingIC_train(k)       = temp.train_traj_error(1);
                TrainingIC_predict(k)     = temp.prediction_traj_error(1);
            case errLASSO(k)
                flag(k)=3;
                temp= construct_and_compute_traj(sysInfo,idenLASSO,obsInfo,solverInfo, xpath_train(:,1,:));    
                TrainingIC_train(k)       = temp.train_traj_error(1);
                TrainingIC_predict(k)     = temp.prediction_traj_error(1);
    end

end


%% test prediction on 10 new initial conditions

newintial = zeros(sysInfo.d*sysInfo.N, num_trials);
for l=1:num_trials
    newintial(:,l)=sysInfo.mu0();
end

% choose the estimators with best performance to find trajectory prediction errors for predicting interval

switch mode(flag)
    case 1
        NewIC_traj_test = construct_and_compute_traj(sysInfo,idenLS,obsInfo,solverInfo, newintial);
    case 2
        NewIC_traj_test= construct_and_compute_traj(sysInfo,idenSLS,obsInfo,solverInfo, newintial);
    case 3
        NewIC_traj_test = construct_and_compute_traj(sysInfo,idenLASSO,obsInfo,solverInfo, newintial);
end




%% Mean and Standard deviations of trajectory errors
Train_IC_learninginterval       = [mean(TrainingIC_train)                       std(TrainingIC_train)];
Train_IC_predictinginterval     = [mean(TrainingIC_predict)                     std(TrainingIC_predict)];
Testing_IC_learninginterval     = [NewIC_traj_test.train_traj_error(1)          NewIC_traj_test.train_traj_error(2)];
Testing_IC_predictinginterval   = [NewIC_traj_test.prediction_traj_error(1)     NewIC_traj_test.prediction_traj_error(2)];




