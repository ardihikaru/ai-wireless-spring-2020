NCs = unique(labels);
NCopt = length(NCs);
Sid = 1;

cluster_center = unique(labels(:,Sid));
disp(" ---- >>>> cluster_center) ...")
disp(cluster_center)
disp("----------------------")

[C, labels] = apc_ind2cluster(labels);
[NC,Sil,Silmin] = apc_solution_evaluation(data,M,labels,NCopt,...
    iend,nrow,type,cut);
fprintf('$$ Clustering solution by original Affinity Propagation:\n');
fprintf('  Optimal number of clusters is %d, Silhouette = %g,\n',NCopt,Sil);
fprintf('  where min Silhouette of single cluster is %g.\n',Silmin);
fprintf('  The optimal solution (class labels) is in labels(:,Sid)');
% if id == 14
%     [TP,FP] = solution_positive(refseq_exon,refseq_intron,labels,labels(end),Sid);
%     fprintf('\n## exon identification: true positive rate %g, false positive rate %g\n',TP,FP);
% end