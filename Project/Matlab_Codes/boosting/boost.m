function pred = boost(trainsetX,trainsetY,testsetX)

pred = zeros(size(testsetX,1),1);
pred_threshold = 0.05;
%% weak learner initialization
%------------------------- naive bayes ---------------------------%
T = 15;      % number of iteration
subsetX = trainsetX; subsetY = trainsetY;
N = size(subsetX,1);
D = ones(N,1) / N;
alpha = zeros(T,1);
y = trainsetY.*2 - 1;
F = 0.06;   % reducing factor
k = 0.5;
beta = 0.5;
C = 0.15;
%------------------------- naive bayes ---------------------------%
%------------------------- DT ---------------------------%
N_ = size(trainsetX,1);
T_ = 10;      % number of iteration
k_ = 0.5;
beta_ = 0.5;
C_ = 0.2;
alpha_ = zeros(T_,1);
D_ = ones(N_,1) / N_;
y_ = trainsetY.*2 - 1;
%------------------------- DT ---------------------------%
%% --------------------------------------  boosting  ----------------------------------%
%------------------------- naive bayes ---------------------------%
for t = 1:T
    
    % apply model
    [output, phi_y, phi_one, phi_zero] = bayes_learner(subsetX, subsetY);
    hx = output.*2 - 1;
    
    % measure the error function
    error = 0;
    error = error + sum(D.*(output ~= subsetY));
    alpha(t) = k*log(beta*(1-error)/error);
    
    % update distribution
    D = D.*exp(-C.*alpha(t).*y.*hx);
    
    % repick samples to retrain parameters using new samples 
    tmp = sort(D);
    threshold = tmp(floor(N*F));
    idx = find(D > threshold);
    dif = floor(N*(1-F)) - length(idx);
    if dif > 0
        tmp_idx = find(D <= threshold);
        tmp_idx = tmp_idx(1:dif);
        idx = [idx;tmp_idx];
    end
    subsetX = subsetX(idx,:); subsetY = subsetY(idx,:);
    N = size(trainsetX,1);
    D = D(idx);
    y = y(idx);
    
    [output_boost] = bayes_learner(testsetX,[], phi_y, phi_one, phi_zero);
    output_boost = output_boost.*alpha(t);
    pred = pred + output_boost;
end
%------------------------- naive bayes ---------------------------%
%------------------------- DT ---------------------------%
for t_ = 1:T_
    [output_, BDT] = tree_learner(trainsetX,trainsetY,[],D_);
    hx_ = output_.*2 - 1;
   
    % compute the error function     
    error_ = sum(D_.*(output_ ~= trainsetY));
    alpha_(t_) = k_*log(beta_*(1-error_)/error_);

    % update distribution
    D_ = D_.*exp(-C_*alpha_(t_).*y_.*hx_);
    D_ = D_ ./ sum(D_);
    
    [output_boost_] = tree_learner(testsetX,[], BDT);
    output_boost_ = output_boost_.*alpha_(t_);
    pred = pred + output_boost_;
end
%------------------------- DT ---------------------------%

%% give prediction
pred = pred ./ (sum(alpha)+sum(alpha_));
pred = pred > pred_threshold;