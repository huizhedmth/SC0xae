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
        H(i,j) = trainsetY(i).*trainsetY(j).*kij_3(trainsetX,i,j);
    end
end
options = optimset('LargeScale','off');

% solve the problem using QUADPROG 
[Z,FVAL,EXITFLAG,OUTPUT,LAMBDA] = quadprog(H,f,A,d,Aeq,beq,LB,UB,[],options);
Z = Z.*(abs(Z)>0.00001);    % threshold Z with 10^-5

% compute decision boundry
x = trainsetX(Z>0,:);
y = trainsetY(find(Z>0));
alpha = Z(Z>0);
Ns = length(alpha);

b = 0;
for i = 1:Ns
    for j = 1:Ns
        b = b + (-1).*alpha(j).*y(j).*kij_3(x,i,j);
    end
    b = b + y(i);
end
b = b / Ns;

figure(1);
MAP = [254/255,127/255,0;254/255,0,254/255];
COLORMAP(MAP);
scatter(trainsetX(:,1), trainsetX(:,2),20, trainsetY,'filled'); hold on;

[X,Y] = meshgrid(4:.01:7,2:.01:4.5);
num_of_points = 1;
z = zeros(size(X));
boundary_x = 100*ones(50,1);
boundary_y = 100*ones(50,1);
for i = 1:size(X,1)
    for j = 1:size(X,2)
        input = [X(i,j),Y(i,j)];
        z(i,j) = boundary_3(input,alpha,y,x,b); 
        if abs(z(i,j)) < 0.001
            boundary_x(num_of_points) = X(i,j);
            boundary_y(num_of_points) = Y(i,j);
            num_of_points = num_of_points + 1;
        end
    end
end
boundary_x = boundary_x(boundary_x~=100);
boundary_y = boundary_y(boundary_y~=100);
plot(boundary_x,boundary_y);
title('q1k');