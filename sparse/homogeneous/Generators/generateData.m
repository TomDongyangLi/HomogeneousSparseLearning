function [N,d,tspan,L,M,phi,IC] = generateData()
% generates the data needed to construct our system

%%
% parameters
N = input('N = ');                       % # of agents
d = input('d = ');                       % dimensions
tf = input('tf = ');                     % final time
L = input('L = ');                       % # of timesteps
M = input('M = ');                       % # of systems
tspan = [0:tf/(L-1):tf];                 % set tspan
phi = choosePhi(N);                      % choose phi kernel

%%
% IC parameters

IC.d = d;
IC.N = N;
switch d
    case 1
        disp("Input bounds of a line:");
        IC.x1 = input('left bound = ');
        IC.x2 = input('right bound = ');
        IC.rmax = abs(IC.x2-IC.x1);
    case 2
        disp("Enter:")
        disp("1 for a rectangular domain");
        disp("2 for a circular domain");
        disp("3 for an annular domain");
        
        shape = input('');
        IC.shape = shape;
        switch shape
            case 1 
                disp("Input bounds of a rectangle:");
                IC.x1 = input('x-axis left bound = ');
                IC.x2 = input('x-axis right bound = ');
                IC.y1 = input('y-axis lower bound = ');
                IC.y2 = input('y-axis upper bound = ');
                IC.rmax = sqrt(((IC.x2-IC.x1)^2)+((IC.y2-IC.y1)^2));
            case 2
                disp("Input bounds of a circle:");
                IC.centerx = input('input x-center of circle = ');
                IC.centery = input('input y-center of circle = ');
                IC.radius = input('radius of circle = ');
                IC.rmax = 2*IC.radius;
            case 3
                disp("input bounds of a annulus")
                IC.centerx = input('input x-center of annulus = ');
                IC.centery = input('input y-center of annulus = ');
                IC.radius1 = input('inner radius = ');
                IC.radius2 = input('outer radius = ');
                IC.rmax = 2*IC.radius2;
        end
    case 3
        disp("Enter:");
        disp("1 for a cuboid domain");
        disp("2 for a spherical domain");
        
        shape = input('');
        IC.shape = shape;
        switch shape
            case 1
                disp("input bounds of a cuboid")
                IC.x1 = input('left xaxis bound = ');
                IC.x2 = input('right xaxis bound = ');
                IC.y1 = input('lower yaxis bound = ');
                IC.y2 = input('upper yaxis bound = ');
                IC.z1 = input('bottom zaxis bound = ');
                IC.z2 = input('top zaxis bound = ');
                IC.rmax = sqrt(((IC.x2-IC.x1)^2)+((IC.y2-IC.y1)^2)+((IC.z2-IC.z1)^2));
            case 2
                disp("input bounds of a sphere")
                IC.centerx = input('input x-center of sphere = ');
                IC.centery = input('input y-center of sphere = ');
                IC.centerz = input('input z-center of sphere = ');
                IC.radius = input('radius of sphere = ');
                IC.rmax = 2*IC.radius;
        end
end

end

