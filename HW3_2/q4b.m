clear all;close all;load 'spamXY.mat';

it = 1000;

d = zeros(it,1);
error = d;

for i = 1:it
    [labels, d(i)] = mykmeans(X,0);
    error(i) = min(sum(xor(labels,Y)),sum(xor(labels,~Y)));
end
    
err_rate = error /length(Y);
k = 1 / (max(d) - min(d));
b = -k*min(d);
d_norm = k.*d + b;
tmp = sortrows([d_norm,err_rate]);
plot(tmp(:,1),tmp(:,2));
title('error rate vs. distortion');

