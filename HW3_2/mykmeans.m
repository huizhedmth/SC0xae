function [ labels,distortion ] = mykmeans(X,flag,k)
% by default, k = 2 and plot distortion as a function of iterations
if nargin <= 2
    k = 2;
end;
if nargin <= 1
    flag = 1;
end

N = size(X,1);  % number of samples
M = size(X,2);  % number of features of ealabelsh sample
u = rand(k,M); % cluster centroid
% u = zeros(k,M); % cluster centroid
% u(1,:) = X(1,:);    u(2,:) = X(2,:);

labels = zeros(N,1); % assigned labels
J_prev = -10; J_new = 0;    % distortionf

it = 1;
J = zeros(3,1);
while( abs(J_prev - J_new) > 0.01)
    for i = 1:N
        labels(i) = (dist2(X(i,:),u(1,:))) > (dist2(X(i,:),u(2,:)));
    end
    for j = 1:k
        idx = labels==(j-1);
        t = sum(X(idx,:));
        u(j,:) = t / sum(labels==(j-1));
    end
    J_prev = J_new;
    J_new = 0;
    for i = 1:N
       J_new = J_new + dist2(X(i,:),u(labels(i)+1,:));
    end
    J(it) = J_new;
    it = it + 1;
end
distortion = J_new;
x = (1:it-1);
if flag == 1
    plot(x,J);
end
end

