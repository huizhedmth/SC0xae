function [  ] = myann( trainsetX,trainsetY )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% this file is used to plot the performance of training set
[my,ny] = size(trainsetY);
error_rate = ones(1,ny);
for i = 1:ny
    [error_rate(i),correct_rate(i),lost_rate(i),theta1,theta2] = ann(trainsetX,trainsetY(:,i));
 %   plot(i,error_rate(i),'*');
     plot(i,correct_rate(i),'*');
%      disp(error_rate(i));
%      disp(correct_rate(i));
%      disp(lost_rate(i));
hold on;
end
hold off;
end