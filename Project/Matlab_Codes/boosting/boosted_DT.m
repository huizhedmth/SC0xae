function result_ = boosted_DT(trainsetX,trainsetY,testsetX)

%% initialization
N_ = size(trainsetX,1);
T_ = 10;      % number of iteration
k_ = 0.5;
beta_ = 0.5;
C_ = 0.2;
alpha_ = zeros(T_,1);
result_ = zeros(size(testsetX,1),1);
threshold = 0.3;
%% weak learner initialization
D_ = ones(N_,1) / N_;
y_ = trainsetY.*2 - 1;


%% -----------------  boosting  -----------------%
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
    result_ = result_ + output_boost_;
end
result_ = (result_ ./ sum(alpha_))>threshold;


