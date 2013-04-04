clear all;
close all;
load 'spamdata.mat'

% model parameters
phi_y = 0;              % p(y = 1)
phi_zero = zeros(48,1); % p(x_i = 1 | y = 0)
phi_one = zeros(48,1);  % p(x_i = 1 | y = 1)

% result
class_test = zeros(3101,1);
class_train = zeros(1500,1);

% -- begin
% learn the parameters from training set, using Laplacian smoothing
phi_y = sum(trainsetY) / 1500;
for i = 1:48
    phi_one(i,1) = (1+sum(and(trainsetX(:,i),trainsetY))) / (2+sum(trainsetY));
    phi_zero(i,1) = (1+sum(and(trainsetX(:,i),not(trainsetY)))) / (2+sum(not(trainsetY)));
end

% apply this model on training set
for n = 1:1500
    temp = zeros(48,1);
    for i = 1:48
        if trainsetX(n,i) == 1
            temp(i,1) = phi_one(i,1);
        else
            temp(i,1) = 1 - phi_one(i,1);
        end
    end
    numerator = phi_y * prod(temp);
    denominator_1 = numerator;
    for i = 1:48
        if trainsetX(n,i) == 1
            temp(i,1) = phi_zero(i,1);
        else
            temp(i,1) = 1 - phi_zero(i,1);
        end
    end
    denominator_2 = (1 - phi_y) * prod(temp);
    posterior = numerator / (denominator_1 + denominator_2);
    class_train(n,1) = posterior > 0.5;
end
% calculate error rate
error_rate_train = sum(xor(class_train,trainsetY)) / 1500;

% apply this model on test set
for n = 1:3101
    temp = zeros(48,1);
    for i = 1:48
        if testsetX(n,i) == 1
            temp(i,1) = phi_one(i,1);
        else
            temp(i,1) = 1 - phi_one(i,1);
        end
    end
    numerator = phi_y * prod(temp);
    denominator_1 = numerator;
    for i = 1:48
        if testsetX(n,i) == 1
            temp(i,1) = phi_zero(i,1);
        else
            temp(i,1) = 1 - phi_zero(i,1);
        end
    end
    denominator_2 = (1 - phi_y) * prod(temp);
    posterior = numerator / (denominator_1 + denominator_2);
    class_test(n,1) = posterior > 0.5;
end

% calculate error rate
error_rate_test = sum(xor(class_test,testsetY)) / 3101;


