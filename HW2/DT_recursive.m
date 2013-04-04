function [ new_tree, new_slot ] = DT_recursive(X, Y, feat_idx, tree, slot, c)
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
%
%   Return
%   new_tree Sx3 (S>=Q+1) holding all previous parts in the tree matrix
%                         and the sub-tree rooting at the current splitting 
%                         node.
%   new_slot 1x1 the row number of the next unused row in new_tree



%% Termination condition
N = length(Y);
% >>> if %todo: YOUR IMPLEMENTATION HERE:% termination condition matches (this node is a leaf node).
% check if we have all samples with the same label
tmp = sum(Y) / length(Y);
if (tmp==1) || (tmp==0)
    flag = 1;
else
    flag = 0;
end
disp('size(X,1):');disp(size(X,1));
disp('Y:');disp(Y);
if (size(X,1) < c) || flag    % stop if the number of samples is less than c (that is, C * m)
                                 % or the samples have the same label
    new_tree = tree;
    % >>>create a new row in new_tree(slot, :), and fill in this row.
    % >>>todo: YOUR IMPLEMENTATION HERE
    
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
    % >>>Return new_tree and new_slot, which is slot+1;
    new_slot = slot + 1;
    return; 
end;

%% Find the best split

% >>>calculate the entropy impurity measurements for all the features that 
% >>>are in feat_idx, and find the best splitting feature that decreases the 
% >>>impurity most. Assign this feature to feat_selected

% >>>todo: YOUR IMPLEMENTATION HERE
% calcultate entropy for each feature choice

region_1 = zeros(size(X,1),1);
region_2 = zeros(size(X,1),1);
delta_i = zeros(length(feat_idx),1);

for i = 1:length(feat_idx)
    
    cur_idx = feat_idx(i);  % current feature index
    j1 = 1; j2 = 1; % iterater for region 1 and region 2
    % split
    for n = 1:size(X,1);
%         disp('X(n,cur_idx)');disp(X(n,cur_idx));
        
        if (X(n,cur_idx) == 1)
            region_1(j1,1) = Y(n); j1 = j1+1;
        else 
            region_2(j2,1) = Y(n); j2 = j2+1;
        end   
    end
    region_1 = region_1(1:j1-1, 1);
    region_2 = region_2(1:j2-1, 1);
    if ( (size(region_1,1)==0) || (size(region_2,1)==0) )     % bad split. drop this feature
        delta_i(i,1) = 0;   % assign to this feature a value that is small enough
        disp('size_1:');disp(size(region_1,1));
        disp('size_2:');disp(size(region_2,1));
        continue;
    end

    % calculate delta_i (for each feature) according to the formula
    % given in class
    
    % i_tao
    pc_one = sum(Y) / length(Y);
    pc_zero = sum(not(Y)) / length(Y);
    
    % wipe out class that does not exist
    if (pc_one >0) log_pc_one = log(pc_one);
    else log_pc_one = 0;
    end
    if (pc_zero >0) log_pc_zero = log(pc_zero);
    else log_pc_zero = 0;
    end
    
    i_tao = (-1) * (pc_one*log_pc_one + pc_zero*log_pc_zero);
    disp('i_tao');disp(i_tao);
    % p_tao_s and p_tao_not_s
    p_tao_s = (j1-1) / length(Y);
    p_tao_not_s = (j2-1) / length(Y);
    
    % i_tao_s
    pc_one = sum(region_1) / length(region_1);
    pc_zero = sum(not(region_1)) / length(region_1);
%     disp('pc_one:');disp(pc_one);
%     disp('pc_zero:');disp(pc_zero);
    if (pc_one >0) log_pc_one = log(pc_one);
    else log_pc_one = 0;
    end
    if (pc_zero >0) log_pc_zero = log(pc_zero);
    else log_pc_zero = 0;
    end
    
    i_tao_s = (-1) * (pc_one*log_pc_one + pc_zero*log_pc_zero);
%     disp('i_tao_s'); disp(i_tao_s);
    % i_tao_not_s
    pc_one = sum(region_2) / length(region_2);
    pc_zero = sum(not(region_2)) / length(region_2);
    
    if (pc_one >0) log_pc_one = log(pc_one);
    else log_pc_one = 0;
    end
    if (pc_zero >0) log_pc_zero = log(pc_zero);
    else log_pc_zero = 0;
    end
    
    i_tao_not_s = (-1) * (pc_one*log_pc_one + pc_zero*log_pc_zero);

%     disp('i_tao_not_s');disp(i_tao_not_s);
    % now we able to cauculate delta_i
    delta_i(i,1) = i_tao - p_tao_s.*i_tao_s - p_tao_not_s.*i_tao_not_s;
    
end

%%  sum(delta_i) == 0 means that we cannot further split samples by current
%%  features, so just make this node a leaf.
if sum(delta_i) == 0    
    disp('test!!!!!!!!!!!!!!!!!!!!');
    new_tree = tree;
    % >>>create a new row in new_tree(slot, :), and fill in this row.
    % >>>todo: YOUR IMPLEMENTATION HERE
    
    new_tree(slot, 1) = 0;  % this is a leaf node
    count_one = sum(Y);  % number of ones
    count_zero = N - count_one;   % number of zeros
    new_tree(slot, 2) = count_one > count_zero;   % assign a label
    new_tree(slot, 3) = count_one / N;   % probability of y = 1
    % >>>Return new_tree and new_slot, which is slot+1;
    new_slot = slot + 1;
    return; 
end;

%% end test


% now select the feature that yielded the maximum decrease of impurity,
% that is, delta_i
% disp('***************************************************');
disp('delta_i:');disp(delta_i);
feat_selected = feat_idx(find(delta_i == max(delta_i)));
feat_selected = feat_selected(1);   % multiple choices may exist, just pick the 1st
disp('feat_selected:');disp(feat_selected);
% disp(feat_idx);
% disp(length(delta_i));
% disp('feature selected:');disp(feat_selected);
% disp(delta_i);
% disp(feat_selected);

%% Create a new splitting node and recursively (NO IMPLEMENTATION NEEDED)
% creating this new node
% disp('size(X,1)');disp(size(X,1));
% disp('size(Y,1)');disp(size(Y,1));
% disp('sum(Y)');disp(sum(Y));
tree(slot, 1) = feat_selected;
% since this feat is used in this split, it is not feasible to use this
% feature again in children nodes.
feat_idx = feat_idx(feat_idx ~= feat_selected);
% disp('new feat_idx');disp(feat_idx);
% recursively calculating its left child tree
tree(slot, 2) = slot+1;
[tree, new_slot] = DT_recursive(X(X(:, feat_selected)==1, :), Y(X(:, feat_selected)==1), ...
    feat_idx, tree, slot+1, c);
tree(slot, 3) = new_slot;
% recursively calculating its right child tree  
[new_tree, new_slot] = DT_recursive(X(X(:, feat_selected)==0, :), Y(X(:, feat_selected)==0), ...
    feat_idx, tree, new_slot, c);
return;

end

