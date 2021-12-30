function Startup_AddPaths()
home_path = [pwd filesep];

addpath([home_path '/Generators/']);
addpath([home_path '/Regressions/']);
addpath([home_path '/Plotting/']);
addpath([home_path '/Examples/']);
addpath([home_path '/Utils/']);
addpath([home_path '/Results/']);

end