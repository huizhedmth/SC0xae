function result = boosted_bayes(trainsetX,trainsetY,testsetX)

%% initialization
T = 10;      % number of iteration

%% weak learner initialization
subsetX = trainsetX; subsetY = trainsetY;
N = size(subsetX,1);
D = ones(N,1) / N;
alpha = zeros(T,1);
y = trainsetY.*2 - 1;
F = 0.1;   % reducing factor
result = zeros(size(testsetX,1),1);
k = 0.5;
beta = 0.5;
C = 0.15;
threshold = 0.3;

%% -----------------  boosting  -----------------%
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
    N = size(subsetX,1);
    D = D(idx);
    y = y(idx);
    
    [output_boost] = bayes_learner(testsetX,[], phi_y, phi_one, phi_zero);
    output_boost = output_boost.*alpha(t);
    result = result + output_boost;
end
result = (result ./ sum(alpha))>threshold;
