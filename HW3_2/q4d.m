clear all;close all;load 'spamXY.mat'

T = 50;

N = size(X,1);
M = size(X,2);

log_gamma = zeros(N,1);
l_1 = log_gamma;
l_0 = l_1;
loglik_prev = -10000000*ones(T,1);
loglik_new = ones(T,1);
it = 1;
loglik = zeros(3,1);

labels = zeros(T,N);
error_rate = zeros(T,1);

for t = 1:T
    phi_z = rand();
phi_j_0 = rand(M,1);     % phi_j_0 and phi_j_1
phi_j_1 = rand(M,1);
while abs(loglik_new(t) - loglik_prev(t)) > 0.1*10^4

    % E-step
    log_joint_1 = zeros(N,1);
    log_joint_0 = zeros(N,1);
    for i = 1:N
        tmp1 = 0; tmp2 = 0;
        pi_1 = log(phi_z);
        pi_0 = log(1-phi_z);
        l_1(i) = 0; 
        l_0(i) = 0;
        for j = 1:M
            l_1(i) = l_1(i) + X(i,j).*log(phi_j_1(j)) + (1-X(i,j)).*log(1-phi_j_1(j));
            l_0(i) = l_0(i) + X(i,j).*log(phi_j_0(j)) + (1-X(i,j)).*log(1-phi_j_0(j));      
        end
        log_joint_1(i) = log(exp(l_1(i)).*phi_z);
        log_joint_0(i) = log(exp(l_0(i)).*phi_z); 
        b_1 = pi_1 + l_1(i);
        b_0 = pi_0 + l_0(i);
        b_max = max(b_0,b_1);
        f = b_max + log(exp(b_1-b_max) + exp(b_0-b_max));
        log_gamma(i) = pi_1 + l_1(i) - f;
    end

    % compute new log-likelihood
    loglik_prev(t) = loglik_new(t);
    loglik_new(t) = 0;
    for i = 1:N
        loglik_new(t) = loglik_new(t) + exp(log_gamma(i)).*(log_joint_1(i)-log_gamma(i))+ ...
            (1-exp(log_gamma(i))).*(log_joint_0(i)-log(1-exp(log_gamma(i))));
    end
    loglik(it) = loglik_new(t);
    it = it + 1;
    
    % M-step
    phi_z = 0;
    for i = 1:N
        phi_z = phi_z + exp(log_gamma(i));
    end
    phi_z = phi_z / N;
    
    tmp1_1 = 0;tmp0_1 = 0;
    tmp1_2 = 0;tmp0_2 = 0;
    for j = 1:M
        for i = 1:N
            tmp1_1 = tmp1_1 + exp(log_gamma(i)).*X(i,j);
            tmp1_2 = tmp1_2 + exp(log_gamma(i));
            
            tmp0_1 = tmp0_1 + (1-exp(log_gamma(i))).*X(i,j);
            tmp0_2 = tmp0_2 + 1 - exp(log_gamma(i));
        end
        phi_j_1(j) = tmp1_1 / tmp1_2;
        phi_j_0(j) = tmp0_1 / tmp0_2;
    end
end
labels(t,:) = (exp(log_gamma)) > 0.5;
error_rate(t) = min(sum(xor(labels(t,:),Y')) / N,sum(xor(~labels(t,:),Y')) / N);
end

k = 1 / (max(loglik_new) - min(loglik_new));
b = -k*min(loglik_new);
loglik_norm = k.*loglik_new + b;
tmp = sortrows([loglik_norm, error_rate]);
plot(tmp(:,1),tmp(:,2));
title('error rate vs. loglik');

