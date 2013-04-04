function [ new_tree, new_slot ] = DT_recursive(X, Y, feat_idx, tree, slot, c, D)
% DT_RECURSIVE A recursive decision tree algorithm
% This function calculates the sub tree of the whole decision tree rooted 
% at the current splitting node

%   X  Txd  the traing samples that fall to the current splitting node (binary)   
%   Y  Tx1  the labels for X (binary)
%   feat_idx Rx1(R<=d) idx for features that can be used by this current 
%                      splitting node 
%   tree Qx3 the tree matrix (see. DecisionTree.m) holding all the part 
%            of the tree that is already calculated
%   slot 1x1 the row number pointing to the next unused row in the tree matrix
%   c 1x1 the max size for a leaf
%   D Distribution over X
%   
%   Return
%   new_tree Sx3 (S>=Q+1) holding all previous parts in the tree matrix
%                         and the sub-tree rooting at the current splitting 
%                         node.
%   new_slot 1x1 the row number of the next unused row in new_tree



%% Termination condition
N = length(Y);
% check if we have all samples with the same label
tmp = sum(Y) / length(Y);
if (tmp==1) || (tmp==0)
    flag = 1;
else
    flag = 0;
end
if (size(X,1) < c) || flag    % stop if the number of samples is less than c (that is, C * m)
                                 % or the samples have the same label
    new_tree = tree;
    new_tree(slot, 1) = 0;  % this is a leaf node
    % do counting to decide the lable to be assigned to this leaf
    if flag == 1 % then tmp = 1 or tmp = 0
        new_tree(slot, 2) = tmp;
        new_tree(slot, 3) = tmp;  % since this is a perfect split
    else
        count_one = sum(Y);  % number of ones
        count_zero = N - count_one;   % number of zeros
        new_tree(slot, 2) = count_one > count_zero;   % assign a label
        new_tree(slot, 3) = count_one / N;   % probability of y = 1
    end
    new_slot = slot + 1;
    return; 
end;


assert(size(X,1) == length(D));
%% Find the best split
% calcultate entropy for each feature choice

delta_i = zeros(length(feat_idx),1);

for i = 1:length(feat_idx)
    
    cur_idx = feat_idx(i);  % current feature index
    % split 
    idx_left = find(X(:,cur_idx) == 1);
    idx_right = find(X(:,cur_idx) == 0);
    assert((length(idx_left)+length(idx_right)) == size(X,1));
    if ( (isempty(idx_right)) || (isempty(idx_left)) )     % bad split. drop this feature
        delta_i(i,1) = 0;   % assign to this feature a value that is small enough
        continue;
    end
    % calculate delta_i (for each feature) according to the formula
    % given in class
    
    % i_tao
    pc_one = sum(Y.*D) / sum(D);
    pc_zero = sum(not(Y).*D) / sum(D);
%     assert(abs(pc_one+pc_zero-1) < 10^-3);
    i_tao = (-1) * (pc_one*log(pc_one) + pc_zero*log(pc_zero));

    % p_tao_s and p_tao_not_s
    p_tao_s = sum(D(idx_left)) / sum(D);
    p_tao_not_s = sum(D(idx_right)) / sum(D);
%     assert(abs(p_tao_not_s+p_tao_s-1) < 10^-3);
    
    % i_tao_s
    pc_one = sum(Y(idx_left).*D(idx_left)) / sum(D(idx_left));
    pc_zero = sum(not(Y(idx_left)).*D(idx_left)) / sum(D(idx_left));
%     assert(abs(pc_one+pc_zero-1) < 10^-3);
    
    if (pc_one >0) log_pc_one = log(pc_one);
    else log_pc_one = 0;
    end
    if (pc_zero >0) log_pc_zero = log(pc_zero);
    else log_pc_zero = 0;
    end 
    i_tao_s = (-1) * (pc_one*log_pc_one + pc_zero*log_pc_zero);
    
    % i_tao_not_s
    pc_one = sum(Y(idx_right).*D(idx_right)) / sum(D(idx_right));
    pc_zero = sum(not(Y(idx_right)).*D(idx_right)) / sum(D(idx_right));
%     assert(abs(pc_one+pc_zero-1) < 10^-3);
    
    if (pc_one >0) log_pc_one = log(pc_one);
    else log_pc_one = 0;
    end
    if (pc_zero >0) log_pc_zero = log(pc_zero);
    else log_pc_zero = 0;
    end  
    i_tao_not_s = (-1) * (pc_one*log_pc_one + pc_zero*log_pc_zero);
    
    % now we able to cauculate delta_i
    delta_i(i,1) = i_tao - p_tao_s.*i_tao_s - p_tao_not_s.*i_tao_not_s;
    
end

%  sum(delta_i) == 0 means that we cannot further split samples by current
%  features, so just make this node a leaf.
if sum(delta_i) == 0    
    new_tree = tree; 
    new_tree(slot, 1) = 0;  % this is a leaf node
    count_one = sum(Y);  % number of ones
    count_zero = N - count_one;   % number of zeros
    new_tree(slot, 2) = count_one > count_zero;   % assign a label
    new_tree(slot, 3) = count_one / N;   % probability of y = 1
    new_slot = slot + 1;
    return; 
end;

% now select the feature that yielded the maximum decrease of impurity,
% that is, delta_i
feat_selected = feat_idx(delta_i == max(delta_i));
feat_selected = feat_selected(1);   % multiple choices may exist, just pick the 1st
%% Create a new splitting node and recursively (NO IMPLEMENTATION NEEDED)
% creating this new node
tree(slot, 1) = feat_selected;
% since this feat is used in this split, it is not feasible to use this
% feature again in children nodes.
feat_idx = feat_idx(feat_idx ~= feat_selected);
% recursively calculating its left child tree
tree(slot, 2) = slot+1;
[tree, new_slot] = DT_recursive(X(X(:, feat_selected)==1, :), Y(X(:, feat_selected)==1), ...
    feat_idx, tree, slot+1, c, D(X(:, feat_selected)==1));
tree(slot, 3) = new_slot;
% recursively calculating its right child tree  
[new_tree, new_slot] = DT_recursive(X(X(:, feat_selected)==0, :), Y(X(:, feat_selected)==0), ...
    feat_idx, tree, new_slot, c, D(X(:, feat_selected)==0));
return;

end

