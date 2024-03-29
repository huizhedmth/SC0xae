clear all;
close all;
load 'spamdata.mat'

% model parameters
phi_y = 0;              % p(y = 1)
phi_zero = zeros(48,1); % p(x_i = 1 | y = 0)
phi_one = zeros(48,1);  % p(x_i = 1 | y = 1)
result = zeros(48,1);

% -- begin
% learn the parameters from training set, using Laplacian smoothing

phi_y = sum(trainsetY) / 1500;
for i = 1:48
    phi_one(i,1) = (1+sum(and(trainsetX(:,i),trainsetY))) / (2+sum(trainsetY));
    phi_zero(i,1) = (1+sum(and(trainsetX(:,i),not(trainsetY)))) / (2+sum(not(trainsetY)));
end

result(:,1) = (1-phi_y).*phi_zero(:,1) ./ ( phi_y.*phi_one(:,1) + (1-phi_y).*(phi_zero(:,1)) );
temp = sort(result);
k1 = temp(6,1);
k2 = temp(43,1);
spam_words = find(result <= k1);
ham_words = find(result >= k2);


% by looking at spambase_names.txt, the 6 words that are most indicative of
% a message being "spam" are:
% remove(7), addresses(15), free(16), credit(20), 000(23) and money(24).
% and a message being "ham" are:
% george(27), lab(29), telnet(31), 857(32), cs(41) and meeting(42).