clear all;close all;load 'iris_subset'.mat;

N = length(trainsetX);
M = size(trainsetX,2);
assert(N == length(trainsetY));

% construct arguments
H = eye(M+1); H(M+1, M+1) = 0;
f = zeros(size(trainsetX,2)+1,1);
A = -diag(trainsetY)*[trainsetX,ones(N,1)];
d = -ones(N,1);

% solve the problem using QUADPROG 
[Z,FVAL,EXITFLAG,OUTPUT,LAMBDA] = QUADPROG(H,f,A,d);

% count non-zero elements to obtain the number of support vectors
num_of_SV = sum(LAMBDA.ineqlin ~= 0);
