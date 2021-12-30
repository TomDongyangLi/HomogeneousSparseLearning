function f = LJ_influence(r)
%
% function f = LJ_influence(r, epsilon, sigma)
%
% The Lennard Jones Potential:
% \Phi_LJ = 4 * epsilon * [(sigma/r)^12 - (sigma/r)^6)]
% epsilon: depth of the potential well
% sigma: finite distance at which the inter-particle potential is zero
% distance at which the potential reaches its mininum: r_m = 2^(1/6) * sigma
% Corresponding to influence function:
% phi(r) = \Phi_LJ(r)'/r = 24 * epsilon/(sigma^2) * [-2*(sigma/r)^14 + (sigma/r)^8]
% source: wikipedia, https://en.wikipedia.org/wiki/Lennard-Jones_potential


%
%  (c) Sui Tang (UCSB)

%  PHI(r)=p*epsilon/(p-q)[ q/p(sigma/r)^p-(sigma/r)^q]
%  phi(r)=pq*epsilon/(p-q)sigma^2[ (sigma/r)^(q+2)-(sigma/r)^(p+2)]
%  phi'(r)=pq*epsilon/(p-q)sigma^3[(sigma/r)^(p+3)(p+2)-(sigma/r)^(q+3)(q+2)]
%  phi''(r)=pq*epsilon/(p-q)sigma^4[(sigma/r)^(q+4)(q+2)(q+3)-(sigma/r)^(p+2)(p+2)(p+3)]
sigma   = 0.8; % distance that the potential reach a minimum
q =1; % repulsion power  
p =2; % attraction power
epsilon = 0.1; % force at the minimum
r_trunc = 0; % truncation location
f       = zeros(size(r));        
       
%ind     = (r>0);

ind     = r>r_trunc;
rinv    = sigma./r(ind);
f(ind)  = p*q* epsilon * (rinv.^(q+2) -rinv.^(p+2))./((p-q)*sigma^2);

ind  =  r<=r_trunc;


f(ind) = -inf;

f=reshape(f,size(r));


return


