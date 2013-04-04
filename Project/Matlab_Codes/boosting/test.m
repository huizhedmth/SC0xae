clear all;close all;

load 'dataX.mat';
load 'dataY.mat';

testsetX = trainsetX(500:596,:);
testsetY = trainsetY(500:596,:);
trainsetX = trainsetX(1:499,:);
trainsetY = trainsetY(1:499,:);

N_users = size(trainsetY,2);
N_feat = size(trainsetX,2);
N_sample = size(trainsetX,1);

err_rate_bayes = zeros(N_users,1);
accuracy_bayes = zeros(N_users,1);
miss_rate_bayes = zeros(N_users,1);

err_rate_DT = zeros(N_users,1);
accuracy_DT = zeros(N_users,1);
miss_rate_DT = zeros(N_users,1);

err_rate_BNB = zeros(N_users,1);
accuracy_BNB = zeros(N_users,1);
miss_rate_BNB = zeros(N_users,1);

err_rate_BDT = zeros(N_users,1);
accuracy_BDT = zeros(N_users,1);
miss_rate_BDT = zeros(N_users,1);

err_rate_BOOST = zeros(N_users,1);
accuracy_BOOST = zeros(N_users,1);
miss_rate_BOOST = zeros(N_users,1);

for i = 1:N_users
    u_trainsetY = trainsetY(:,i);
    
    result_bayes = bayes_learner(trainsetX,u_trainsetY);
    err_rate_bayes(i) = sum(result_bayes ~= u_trainsetY) / length(u_trainsetY);
    accuracy_bayes(i) = sum(and(result_bayes,u_trainsetY)) / sum(result_bayes);
    miss_rate_bayes(i) = 1 - sum(and(result_bayes,u_trainsetY)) / sum(u_trainsetY);

    result_BNB = boosted_bayes(trainsetX,u_trainsetY,trainsetX);
    err_rate_BNB(i) = sum(result_BNB ~= u_trainsetY) / length(u_trainsetY);
    accuracy_BNB(i) = sum(and(result_BNB,u_trainsetY)) / sum(result_BNB);
    miss_rate_BNB(i) = 1 - sum(and(result_BNB,u_trainsetY)) /     sum(u_trainsetY);
    
    result_DT = tree_learner(trainsetX,u_trainsetY);
    err_rate_DT(i) = sum(result_DT ~= u_trainsetY) / length(u_trainsetY);
    accuracy_DT(i) = sum(and(result_DT,u_trainsetY)) / sum(result_DT);
    miss_rate_DT(i) = 1 - sum(and(result_DT,u_trainsetY)) / sum(u_trainsetY);
  
    result_BDT = boosted_DT(trainsetX,u_trainsetY,trainsetX);
    err_rate_BDT(i) = sum(result_BDT ~= u_trainsetY) / length(u_trainsetY);
    accuracy_BDT(i) = sum(and(result_BDT,u_trainsetY)) / sum(result_BDT);
    miss_rate_BDT(i) = 1 - sum(and(result_BDT,u_trainsetY)) / sum(u_trainsetY);
   
    result_BOOST = boost(trainsetX,u_trainsetY,trainsetX);
    err_rate_BOOST(i) = sum(result_BOOST ~= u_trainsetY) / length(u_trainsetY);
    accuracy_BOOST(i) = sum(and(result_BOOST,u_trainsetY)) / sum(result_BOOST);
    miss_rate_BOOST(i) = 1 - sum(and(result_BOOST,u_trainsetY)) / sum(u_trainsetY);
    
    disp('********************');disp(i);
    disp('bayes:');disp(accuracy_bayes(i));disp(miss_rate_bayes(i));
    disp('BNB:');disp(accuracy_BNB(i));disp(miss_rate_BNB(i));
    disp('DT:');disp(accuracy_DT(i));disp(miss_rate_DT(i));
    disp('BDT:');disp(accuracy_BDT(i));disp(miss_rate_BDT(i));
    disp('BOOSTING:');disp(accuracy_BOOST(i));disp(miss_rate_BOOST(i));
end

