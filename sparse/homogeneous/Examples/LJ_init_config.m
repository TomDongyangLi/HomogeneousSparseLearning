function y_init = LJ_init_config(L_x, d, N, kind)
%
% function y_init = LJD_init_config(L_x, d, N, kind)
%

% (c) M. Zhong, M. Maggioni

% generate the initial configuration based on kind
switch kind
    case 1
        y_init = uniform_dist(d, N, 'rectangle', [-L_x, L_x]);
        y_init = y_init(:);
    case 2
        A = randn(d,N);
        % normalize each row
        for l=1:N
            A(:,l)=A(:,l)./norm(A(:,l))*5;
        end
        y_init = A;
        y_init = y_init(:);
    otherwise
end

return
