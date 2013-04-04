clear all;
close all;
load 'spamdata.mat';

% learn the tree from sample data
C = [0.005,0.01,0.05,0.1];
error_rate_train = zeros(4,1);
error_rate_test = zeros(4,1);

for j = 1:4
    tree = DecisionTree(trainsetX, trainsetY, C(j));
    
    % apply the decision tree to test set
    result = zeros(length(testsetX),1);

    for i = 1:length(testsetX)
        row = 1;
        feat_idx = tree(1,1);
        while feat_idx~=0
            if testsetX(i,feat_idx) == 1
                row = tree(row,2);
            else
                row = tree(row,3);
            end
        feat_idx = tree(row,1);
        end
    result(i,1) = tree(row,2);
    end
    error_rate_test(j) = sum(xor(result,testsetY)) / length(testsetY);
    
    % apply the decision tree to training set
    result = zeros(length(trainsetX),1);

    for i = 1:length(trainsetX)
        row = 1;
        feat_idx = tree(1,1);
        while feat_idx~=0
            if trainsetX(i,feat_idx) == 1
                row = tree(row,2);
            else
                row = tree(row,3);
            end
        feat_idx = tree(row,1);
        end
    result(i,1) = tree(row,2);
    end
    error_rate_train(j) = sum(xor(result,trainsetY)) / length(trainsetY);
end

figure(1);
plot(C,error_rate_train,'-ob');
hold on;
plot(C,error_rate_test,'-or');
title('error rate as a function of C');
xlabel('C');
ylabel('error rate');
text(0.05, 0.1,'test set');
text(0.05, 0.075, 'train set');
grid on;
hold off;

