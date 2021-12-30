function c = findC_LS(xpath_train,dxpath_train,sysInfo,psiLib)
% taken from derivation of least squares to find C by Dongyang
% Least squares solution

% xpath_train - training data: dN x L x M
% dxpath_train - training derivative data: dN x L x M
% psiLib - dictionary of the basis functions

N =sysInfo.N;
d= sysInfo.d;
L= size(xpath_train,2);
M= size(xpath_train,3);

right = 0;
left = 0;

for m = 1:M
    rtemp = 0;
    ltemp = 0;
    for l = 1:L
        Theta = generateTheta(0,xpath_train(:,l,m),psiLib,d,N); % d*N x n
        rtemp = rtemp + Theta'*dxpath_train(:,l,m);
        ltemp = ltemp + Theta'*Theta;
    end
    
    right = right + rtemp;
    left = left + ltemp;
end
    
c = left\right;

end