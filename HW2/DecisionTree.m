% Template for Decision Tree, NO IMPLEMENTATION NEEDED FOR THIS FILE
function [ tree ] = DecisionTree( X, Y, C )
%DECISIONTREE This function learns a decision tree from training data X&Y
%   X Nxd N d-dim traing samples (binary)
%   Y Nx1 labels for X (binary)
%   C is the upper bound stopping cricterion for the a decision region, as
%   described in the question.
%   Return: 
%   tree: Px3 the decision tree matrix

%   The data structure for the decision tree matrix:
%
%   The tree structure is a Px3 matrix, each row [s1, s2, s3]
%   is either a decision tree splitting node or a leaf.
%   For a sample x:
%   If s1>0, this row is a splitting node:
%   s1 is the decision feature for this split.
%   s2 is the next node (row number) if x_s1=1; 
%   s3 is the next node (row number) if x_s1=0.
%   
%   If s1==0, this row is a leaf:
%   s1 is always 0.
%   s2 is the label for the leaf (either 0 or 1).
%   s3 is p(y=1|x is in this leaf) for this decision leaf.
%
%   The root splitting node is row 1.


%% initialization
[N,d] = size(X); assert(length(Y) == N);
feat_idx = 1:d;         % using all the feature for the root splitting node
c= N*C;                 % max size for a leaf node
tree = zeros(2*1/C, 3); % estimate the size of the tree, 
                        % and preallocate the space.

%% run the DT_recursive algorithm

% calculating the decision tree, with the current splitting node being the
% the root node of the tree. See comments in DT_recursive() for details 
[tree, slot] = DT_recursive(X, Y, feat_idx, tree, 1, c);
tree = tree(1:(slot-1), :);
end

