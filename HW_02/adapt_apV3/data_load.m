p = [];
data = load(sw);
[nrow, dim] = size(data);
M = [];

% taking true class labels from a data file
% truelabels = ones(nrow,1);
truelabels = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12];
% if id < 11 || (id > 20 && id < 30)  % when 1st column is class labels
%     truelabels = data(:,1);
%     data = data(:,2:dim);
%     dim = dim-1;
% end
