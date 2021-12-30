

Mset=[1:4 5:5:50];
for j=1:length(Mset)
    filename=strcat('ODM', num2str(Mset(j)),'L3.mat');
    load(filename);
    LS(1,j)=pLS2;
    SLS(1,j) =pSLS2;
    LASSO(1,j) = pLasso2;
end


% for j=1:length(MsetLASSO)
%     filename=strcat('ODM', num2str(MsetLASSO(j)),'L3.mat');
%     load(filename);
%     LASSO(1,j) = pLasso1;
% end

close all;
plot(Mset,LS,'LineWidth',4,'Color',[79,129,189]./256,'Marker','o');
hold on;
plot(Mset,SLS,'LineWidth',4,'Color',[128,100,162]./256,'Marker','s');
hold on;
plot(Mset,LASSO,'LineWidth',4,'Color',[155,187,89]./256,'Marker','diamond');
legend('LS','SLS','LASSO','FontSize',20,'Location','southeast');
xlim([0 50]);
xlabel('M');
ylabel('Probability');
set (gca,'fontsize',30);
