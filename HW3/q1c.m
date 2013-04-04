clear all;close all;load 'iris_subset'.mat;

N = length(trainsetX);
M = size(trainsetX,2);
assert(N == length(trainsetY));

% construct arguments
H = eye(M+1); H(M+1, M+1) = 0;
f = zeros(M+1,1);
A = -diag(trainsetY)*[trainsetX,ones(N,1)];
d = -ones(N,1);

% solve the problem using QUADPROG 
result = quadprog(H,f,A,d);
w = result(1:M,:);
b = result(M+1,:);
