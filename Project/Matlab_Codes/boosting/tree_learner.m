function [output, tree] = tree_learner(trainsetX, trainsetY, tree, D)
% note that if nargin == 3, trainsetY is unused
C = 0.05;
N = size(trainsetX,1);
% decide whether to directly use the tree passed in or learn one
if nargin == 2
    D = ones(N,1) / N;
    tree = DecisionTree(trainsetX, trainsetY, C, D);
end

if nargin == 4
    tree = DecisionTree(trainsetX, trainsetY, C, D);
end

% apply the decision tree to training set
output = zeros(N,1);

for i = 1:N
    row = 1;
    feat_idx = tree(1,1);
    while feat_idx~=0
        row = tree(row,3 - (trainsetX(i,feat_idx) == 1));
        feat_idx = tree(row,1);
    end
    output(i,1) = tree(row,2);
end






