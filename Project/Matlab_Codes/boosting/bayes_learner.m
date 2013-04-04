function [output, phi_y, phi_one, phi_zero] = bayes_learner(trainsetX, trainsetY, phi_y, phi_one, phi_zero)
% note that when model parameters are given, trainsetY is unused in this
% function.
N = size(trainsetX,1);
M = size(trainsetX,2);
output = zeros(N,1);
threshold = 0.5;

% decide whether to directly use external parameters or to learn the parameters 
if nargin == 2
    % model parameters
    phi_zero = zeros(M,1); % p(x_i = 1 | y = 0)
    phi_one = zeros(M,1);  % p(x_i = 1 | y = 1)
    % learn the parameters from training set, using Laplacian smoothing
    phi_y = sum(trainsetY) / N;
    for i = 1:M
     phi_one(i,1) = (1+sum(and(trainsetX(:,i),trainsetY))) / (2+sum(trainsetY));
     phi_zero(i,1) = (1+sum(and(trainsetX(:,i),not(trainsetY)))) / (2+sum(not(trainsetY)));
    end
end

% apply this model on training set
for n = 1:N
    temp = zeros(M,1);
    for i = 1:M
        if trainsetX(n,i) == 1
            temp(i,1) = phi_one(i,1);
        else
            temp(i,1) = 1 - phi_one(i,1);
        end
    end
    numerator = phi_y * prod(temp);
    denominator_1 = numerator;
    for i = 1:M
        if trainsetX(n,i) == 1
            temp(i,1) = phi_zero(i,1);
        else
            temp(i,1) = 1 - phi_zero(i,1);
        end
    end
    denominator_2 = (1 - phi_y) * prod(temp);
    posterior = numerator / (denominator_1 + denominator_2);
    output(n,1) = posterior > threshold;
end






