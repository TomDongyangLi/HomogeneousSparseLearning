function [eLS, eSLS, eLASSO] = errornorms_phis(cLS,cSLS,cLASSO)

% compute error norm for coefficient differemce

% (c)Sui Tang
%% load the parameters

ctrue = zeros (806,1);
ctrue(2)=1;
ctrue(7)=2;
ctrue(408)=-4;

%% compute the error norms for phis

% compute the coefficient error

eLASSO = norm(ctrue-cLASSO)/norm(ctrue);
eLS = norm(ctrue-cLS)/norm(ctrue);
eSLS = norm(ctrue-cSLS)/norm(ctrue);
% if eSLS > 5
%     disp('big error')
% end
