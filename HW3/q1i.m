clear all;close all;load 'iris_subset'.mat;

N = length(trainsetX);
M = size(trainsetX,2);
assert(N == length(trainsetY));

C = 100;

% construct arguments
A = [];
d = [];
Aeq = trainsetY';
beq = 0;
f = (-1).*ones(N,1);
LB = zeros(N,1);
UB = C.*ones(N,1);

H = zeros(N,N);
for i = 1:N
    for j = 1:N
        H(i,j) = trainsetY(i).*trainsetY(j).*kij(trainsetX,i,j);
    end
end
options = optimset('LargeScale','off');

% solve the problem using QUADPROG 
[Z,FVAL,EXITFLAG,OUTPUT,LAMBDA] = quadprog(H,f,A,d,Aeq,beq,LB,UB);
Z = Z.*(abs(Z)>0.00001);    % threshold Z with 10^-5

% compute decision boundry
x = trainsetX(Z>0,:);
y = trainsetY(find(Z>0));
alpha = Z(Z>0);
Ns = length(alpha);

b = 0;
for i = 1:Ns
    for j = 1:Ns
        b = b + (-1).*alpha(j).*y(j).*kij(x,i,j);
    end
    b = b + y(i);
end
b = b / Ns;

disp('number of SVs:');disp(sum(Z~=0)); 