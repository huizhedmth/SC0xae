function [ output ] = boundary_3(input,alpha,y,x,b)
T = [x;input];
N = size(input,1);
output = zeros(N,1);
for j = 1:N
    kx = [T;input(j,:)];
    for i = 1:length(alpha)
        output(j) = output(j) + alpha(i).*y(i).*kij_3(kx,i,length(kx));
    end
    output(j) = output(j) + b;
end
end

