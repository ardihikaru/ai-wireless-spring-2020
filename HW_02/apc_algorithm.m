% programs for adaptive Affinity Propagation clustering; an improvement
% of Affinity Propagation clusteirng (see Frey & Dueck, Science, Feb. 2007)
% Note: Statistics Toolbox of Matlab needs to be installed
% WANG Kaijun: wangkjun@yahoo.com, July, Sept. 2007.

function cluster_center = apc_algorithm(sim_matrix)

% clear;
cluster_center = [];
nrun2 = 20000;   % max iteration times for original AP
nconv = 80;     % convergence condition, default 50
lam = 0.8;      % damping factor, default 0.5
cut = 3;        % after clustering, drop an cluster with number of samples < cut
%splot = 'plot'; % observing a clustering process when it is on
splot = 'noplot';

% initialization
type = 1;       % 1: Euclidean distances
%type = 2;       % 2: Similarity Pearson
% type = 3;       % 3: Similarity Pearson Coefficients (TBD)
% simatrix = 1;   % 0: data as input; 1: similarity matrix as input

% Loading similarity matrix data
p = [];
data = sim_matrix;
[nrow, dim] = size(data);
% M = [];
% taking true class labels from a data file
truelabels = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12];

disp(' '); disp(['==> Clustering is running on Similarity Matrix, please wait ...']);
tic;

% create row based similarity matrix
nap = nrow*nrow-nrow;
M = zeros(nap,3);
m_idx = 0;
for row = 1:nrow
    for col = 1:nrow
        if col ~= row
            m_idx = m_idx + 1;
            M(m_idx,:) = [ row; col; data(row, col) ];
        end
    end
end
% M = apc_simatrix_make(data,type,nrow);

dn = find(M(:,3)>-realmax);
p = median(M(dn,3));         % Set preference to similarity median
[labels,netsim,iend,unconverged] = apc_apcluster(M,p,'convits',...
    nconv,'maxits',nrun2,'dampfact',lam,splot);
trun = toc;
fprintf('\n## Running time = %g seconds \n', trun);
fprintf('## Running iterations = %g \n', iend);

% finding an clustering solution
apc_solution_findK

% cluster_center = [1 3 5];


