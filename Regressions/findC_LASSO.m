function c = findC_LASSO(xpath_train,dxpath_train,sysInfo,psiLib)
% LASSO

% Stack thetas and dotX_l for each time step and system
d = sysInfo.d;
N = sysInfo.N;
L = size(xpath_train,2);
M = size(xpath_train,3);
Theta = [];
dotX_stack = [];
for m = 1:M
    for l = 1:L
        dotX_stack = [dotX_stack; dxpath_train(:,l,m)]; % d*N*M*L x 1
        Theta = [Theta; generateTheta(0,xpath_train(:,l,m),psiLib,d,N)]; % d*N*M*L x n
    end
end

% perform lasso algorithm
[C FitInfo] = lasso(Theta,dotX_stack,'CV',2); 
c_hat = C(:,FitInfo.Index1SE);

debiasedc = pinv(Theta(:,abs(c_hat)>0))*dotX_stack;

ind = 1;
for i = 1:length(c_hat)
    if abs(c_hat(i))>0
        c_hat(i) = debiasedc(ind);
        ind = ind + 1;
    end
end

c = c_hat;

end