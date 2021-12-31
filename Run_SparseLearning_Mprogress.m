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
num_trials=100;

errLS       = zeros(num_trials,1);
errSLS      = zeros(num_trials,1);
errLASSO    = zeros(num_trials,1);
flag        = zeros(num_trials,1);

for k=1:num_trials

    [dxpath_test,xpath_test,dxpath_train, xpath_train]=Generate_training_data(sysInfo,obsInfo,solverInfo);
    
    rho_emp = rho_empirical(xpath_train,sysInfo,obsInfo,saveON,plotON);% empirical pairwise distance
    
    obsInfo.obs_noise = 0;
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
    
    
    % plot the kernel and compute the error metric
    
    rspan= [rho_emp.edgesSupp(1),rho_emp.edgesSupp(end)];
    [idenLS,idenSLS,idenLASSO]=plotKernel(sysInfo.phi{1},cLS,cSLS,cLASSO,psiLib,rspan);
    [errLS(k), errSLS(k), errLASSO(k)] = errornorms_phis(cLS,cSLS,cLASSO);

    switch min([errLS(k),errSLS(k),errLASSO(k)])
        case errLS(k)
            flag(k)=1;
        case errSLS(k)
            flag(k)=2;
        case errLASSO(k)
            flag(k)=3;
    end

end

%% Succesful Rate
pLasso1 = length(find(errLASSO<1e-4));
pLasso2 = length(find(errLASSO<0.01));


pLS1 = length(find(errLS<1e-4));
pLS2 = length(find(errLS<0.01));


pSLS1 = length(find(errSLS<1e-4));
pSLS2 = length(find(errSLS<0.01));


%% Means and standard deviations of kernel reconstruction errors of the method with best performance
switch mode(flag)
    case 1
        kernel_recon_error=[mean(errLS) std(errLS)];
    case 2
        kernel_recon_error=[mean(errSLS) std(errSLS)];
    case 3
        kernel_recon_error=[mean(errLASSO) std(errLASSO)];
end





filename = strcat(sysInfo.name, 'M',num2str(obsInfo.M),'L',num2str(length(obsInfo.time_vec)));
save(filename,'pLasso1','pLasso2','pLS1','pLS2','pSLS1','pSLS2','errLASSO','errLS','errSLS','kernel_recon_error');

