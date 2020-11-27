function [M, dmax, Dist] = apc_simatrix_make(data,type,nrow)
%   data:    a matrix with each column representing a variable.

disp(" #### apc_simatrix_make ..")

if type == 1
    [Dist, dmax] = apc_similarity_euclid(data,2);   %  pdist(data,'type');
elseif type == 2
    Dist = 1-(1+apc_similarity_pearson(data'))/2;
    dmax = 1;
% elseif type == 3
%     Dist = 1-(1+apc_similarity_pearsonC(data'))/2;
%     dmax = 1;
else
    Dist = 1-(1+apc_similarity_pearson(data'))/2;
    dmax = 1;
end

nap = nrow*nrow-nrow;
disp(">>>> nap:" + nap)
M = zeros(nap,3);
j = 1;
for i=1:nrow
    for k = [1:i-1,i+1:nrow]
        M(j,1) = i;
        M(j,2) = k;
        M(j,3) = -Dist(i,k);
        j = j+1;
    end
end