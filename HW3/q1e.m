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
w = Z(1:2); b = Z(3);

% plot figure
figure(1);
MAP = [254/255,127/255,0;254/255,0,254/255];
COLORMAP(MAP);
scatter(trainsetX(:,1), trainsetX(:,2),5, trainsetY); hold on;

% decision boundary
x = [4,7];
y = - (b + w(1)*x) / w(2); 
plot(x,y); hold on;
title('q1e');

% margin lines
idx= find(LAMBDA.ineqlin > 0);

for i = 1:length(idx)
    x = trainsetX(idx(i),1);
    y = trainsetX(idx(i),2);
    k = - w(1) / w(2);
    B = y - k.*x;

    x = [4,7];
    y = k*x + B;
    plot(x,y);hold on 
end

% mark SV
x = trainsetX(idx,1);
y = trainsetX(idx,2);
plot(x,y,'b*');