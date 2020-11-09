% programs for adaptive Affinity Propagation clustering; an improvement
% of Affinity Propagation clusteirng (see Frey & Dueck, Science, Feb. 2007)
% Note: Statistics Toolbox of Matlab needs to be installed
% WANG Kaijun: wangkjun@yahoo.com, July, Sept. 2007.

clear;
nrun2 = 2000;   % max iteration times for original AP
nconv = 50;     % convergence condition, default 50
lam = 0.5;      % damping factor, default 0.5
cut = 3;        % after clustering, drop an cluster with number of samples < cut
%splot = 'plot'; % observing a clustering process when it is on
splot = 'noplot';

sw='similarity_matrix.txt';   

% initialization
% type = 1;       % 1: Euclidean distances
type = 2;       % 2: Similarity Pearson
% type = 3;       % 3: Similarity Pearson Coefficients (TBD)
simatrix = 0;   % 0: data as input; 1: similarity matrix as input
data_load      % loading a data file or similarity matrix


disp(' '); disp(['==> Clustering is running on ' sw ', please wait ...']);
tic;
% M = apc_simatrix_make(data,type,nrow);
M = apc_simatrix_make(data,type,nrow);
dn = find(M(:,3)>-realmax);
p = median(M(dn,3));         % Set preference to similarity median
[labels,netsim,iend,unconverged] = apc_apcluster(M,p,'convits',...
    nconv,'maxits',nrun2,'dampfact',lam,splot);
trun = toc;
fprintf('\n## Running time = %g seconds \n', trun);
fprintf('## Running iterations = %g \n', iend);

% finding an clustering solution
apc_solution_findK
