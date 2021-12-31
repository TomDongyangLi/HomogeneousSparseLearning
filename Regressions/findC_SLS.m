function c = findC_SLS(xpath_train,dxpath_train,sysInfo,psiLib,lambda)
% compute Sparse regression: sequential least squares

% modified from SLS code by Bruton et al 


c = findC_LS(xpath_train,dxpath_train,sysInfo,psiLib);  % initial guess: Least-squares

% lambda is our sparsification knob.
for k=1:10
    smallinds = (abs(c)<lambda);   % find small coefficients
    c(smallinds)=0;                % and threshold
    
    biginds = ~smallinds;
    % Regress dynamics onto remaining terms to find sparse Xi
    c(biginds) = findC_LS(xpath_train,dxpath_train,sysInfo,psiLib(biginds)); 
end

