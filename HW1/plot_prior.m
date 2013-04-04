function [ y ] = plot_prior( Z, a )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
u = 0:0.01:1;
y = (1/Z) * ( u.^(a-1).*(1-u).^(a-1) );
plot(u,y),title('Prior');
end

