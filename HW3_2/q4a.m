clear all;close all;load 'spamXY.mat';

[labels, distortion] = mykmeans(X);

error = min(sum(xor(labels,Y)),sum(xor(labels,~Y)));




