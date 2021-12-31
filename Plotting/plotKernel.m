function [idenLS,idenSLS,idenLASSO] = plotKernel(phi,cLS,cSLS,cLASSO,psiLib,rspan)
% plots the kernel function as well as the approximated kernel function using c and the psi library


n = length(psiLib);


%% for least square kernel
x = linspace(rspan(1), rspan(2), 100);

idenLS =@(r) construct_estimators(cLS,psiLib,r);
idenSLS =@(r) construct_estimators(cSLS,psiLib,r);
idenLASSO =@(r) construct_estimators(cLASSO,psiLib,r);


% if min(phi(rspan(1):0.01:rspan(2))) ~= max(phi(rspan(1):0.01:rspan(2)))
%     rspan = [rspan(1) rspan(2) min(phi(rspan(1):0.01:rspan(2))) max(phi(rspan(1):0.01:rspan(2)))];  % [left right bottom top] bounds
% else
%     rspan = [rspan(1) rspan(2) min(phi(rspan(1):0.01:rspan(2)))-1 min(phi(rspan(1):0.01:rspan(2)))+1];
% end

scrsz                 = [1, 1, 1920, 1080];
 figure('Name', 'kernel: True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
  [scrsz(3)*1/8, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);

subplot(1,3,1)
True = plot(x,phi(x),'k-','Linewidth',2);
hold on
Approx1 = plot(x,idenLS(x),'b-x','Linewidth',2);
legend([True, Approx1],{'True Kernel', 'LS'})
set(gca,'FontSize',30);
subplot(1,3,2)
True = plot(x,phi(x),'k-','Linewidth',2);
hold on;
Approx2 = plot(x,idenSLS(x),'r-+','Linewidth',1);
set(gca,'FontSize',30);

legend([True, Approx2],{'True Kernel', 'SLS'})
set(gca,'FontSize',30);
subplot(1,3,3)
True = plot(x,phi(x),'k-','Linewidth',2);
hold on;
Approx3 = plot(x,idenLASSO(x),'c-o','Linewidth',1);
legend([True, Approx3],{'True Kernel', 'LASSO'});
set(gca,'FontSize',30);
hold off





end 