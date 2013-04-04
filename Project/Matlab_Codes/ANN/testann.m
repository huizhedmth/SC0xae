function [trainerror_rate,traincorrect_rate,trainlost_rate,testerror_rate,testcorrect_rate,testlost_rate] = testann(  )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%this file is used to test the neural network
load dataX.mat;
load dataY.mat;
trainerror_rate = zeros(1,28);
traincorrect_rate = zeros(1,28);
trainlost_rate = zeros(1,28);
testerror_rate = zeros(1,28);
testcorrect_rate = zeros(1,28);
testlost_rate = zeros(1,28);
for num = 1:28
trainX = trainsetX(1:500,:);
trainY = trainsetY(1:500,num);
testX = trainsetX(501:596,:);
testY = trainsetY(501:596,num);
[trainerror_rate(num),traincorrect_rate(num),trainlost_rate(num),theta1,theta2] = ann(trainX,trainY);
[m,n] = size(testX);
    error = 0;
    pre = zeros(m,1);
    correct = 0;
    lost = 0;
    for j=1:m
        L2 = 1./(1+exp(-(theta1*testX(j,:)')));
        out = 1./(1+exp(-(theta2*L2)));
        if(out >0.5)
            pre(j) = 1;
        else
            pre(j) = 0;
        end
        if(pre(j) ~= testY(j))
            error=error+1;
        end
        if(pre(j) == 1 && testY(j) ==1)
            correct = correct+1;
        end
        if(pre(j) == 0 && testY(j) ==1)
            lost = lost+1;
        end
    end
%     disp(sum(pre));
%     disp(sum(testY));
testerror_rate(num) = error/m;
if(sum(pre)~=0)
    testcorrect_rate(num) = correct/sum(pre);
    disp('test correct rate is');
    disp(testcorrect_rate(num));
else
    testcorrect_rate(num) = 0;
        disp('test correct rate is 0');
end
if(sum(testY)~=0)
    testlost_rate(num) = lost/sum(testY);
        disp('test lost rate is');
        disp(testlost_rate(num));
else
    testlost_rate(num) = 0;
        disp('test lost rate is0 ');
end
% disp(error_rate);
% disp(correct_rate);
% disp(lost_rate);
end
% plot(testcorrect_rate,'-g*');
%  hold on;
%  plot(testerror,'-ro');
%  hold on;
%  plot(testlose,'-b.');
%  hold on;
end

