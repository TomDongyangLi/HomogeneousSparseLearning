function phihat = construct_estimators(c,psiLib,r)
%



n = length(psiLib);
phihat = zeros(size(r));
for i = 1:n
  phihat=phihat+ c(i).*psiLib{i}(r);
end

end

