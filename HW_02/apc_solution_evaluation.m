function [NC,Sil,Silmin,NCfix] = apc_solution_evaluation(data,M,labels,NC,NCfix,nrow,type,cut)

if type == 1
    type = 'euclidean';
else
    type = 'correlation';
end

dim = 0;

if dim < 0
    Ms = Ms - dim + 1;
    for i=1:nrow
        Ms(i,i) = 0;
    end
end

dim = length(NC);
Sil =[];
Sildelete = [];
for i = 1:dim
    Y = labels(:,i);
    Smax = silhouette(data, Y, type);
    dn = isfinite(Smax);
    Sil(i) = mean(Smax(dn));
    [C, Y, dmax] = apc_ind2cluster(Y);
    dmax = min(dmax);
    Sildelete(i) = dmax < cut;
    Q =[];
    for j = 1:length(C)
        R = C{j};
        R = Smax(R);
        dn = isfinite(R);
        Q(j) = mean(R(dn));
    end
    Silmin(i) = min(Q);
end

Sildelete = find(Sildelete);
if length(Sildelete) < dim
    Sil(Sildelete) = [];
    Silmin(Sildelete) = [];
    NC(Sildelete) = [];
    NCfix(Sildelete) = [];
end
