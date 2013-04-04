function [ y ] = plot_posterior( m, H, Z, a )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
u = 0:0.01:1;
y = ((u.^H).*((1-u).^(m-H))).*((1/Z) .* ( u.^(a-1).*(1-u).^(a-1) ));
plot(u,y),title('Posterior');

end

