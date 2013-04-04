function [y] = plot_likelihood( m, H )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
u = 0:0.01:1;
y = (u.^H).*((1-u).^(m-H));
plot(u,y),title('Likelihood Function');
end

