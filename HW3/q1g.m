clear all;close all;load 'iris_subset'.mat;

C = 0.05;
N = length(trainsetX);
M = size(trainsetX,2);
assert(N == length(trainsetY));

% construct arguments
H = diag([ones(M,1);zeros(N+1,1)]);
f = C.*[zeros(M,1);ones(N,1);0];
A = -diag(trainsetY)*[trainsetX,diag(1./trainsetY),ones(N,1)];
d = -ones(N,1);
LB = [-100*ones(M,1);zeros(N,1);-100];
UB = [];
options = optimset('LargeScale', 'off');

% solve the problem using QUADPROG 
[result,FVAL,EXITFLAG,OUTPUT,LAMBDA] = QUADPROG(H,f,A,d,[],[],LB,UB,[],options);
w = result(1:M,:);
ksi = result(M+1:N+M,:);
b = result(N+M+1,:);

% plot figure
figure(1);
MAP = [254/255,127/255,0;0,0,0];
COLORMAP(MAP);
scatter(trainsetX(:,1), trainsetX(:,2),20, trainsetY,'filled'); hold on;

% decision boundary
x = [4,7];
y = - (b + w(1)*x) / w(2); 
plot(x,y,'-r'); hold on;
title('q1g: C=0.05 on training set');

% margin lines
ksi = abs(ksi);
ksi = ksi .* (ksi > 0.00001);
T = find(ksi==0);
idx= find(LAMBDA.ineqlin > 0);

for i = 1:length(idx)
    x = trainsetX(idx(i),1);
    y = trainsetX(idx(i),2);
    plot(x,y,'b*');
    if(isempty(find(T==idx(i), 1)))
        continue;
    end
    k = - w(1) / w(2);
    B = y - k.*x;

    x = [4,7];
    y = k*x + B;
    plot(x,y);hold on 
end

figure(2);
MAP = [254/255,127/255,0;0,0,0];
COLORMAP(MAP);
scatter(testsetX(:,1), testsetX(:,2),20, testsetY,'filled'); hold on;

% decision boundary
x = [4,7];
y = - (b + w(1)*x) / w(2); 
plot(x,y,'-r'); hold on;
title('q1g: C=0.05 on test set');