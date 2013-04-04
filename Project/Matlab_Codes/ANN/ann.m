function [error_rate,correct_rate,lost_rate,theta1,theta2] = ann(trainX,trainY)
%UNTITLED3 Summary of this function goes here
%this file is used to build the network
%tic;
%learning rate
d = 0.1;
%number of neurons in hidden layer 
hid = 100;
[m,n] = size(trainX);
%theta1 = 0.001*rand(hid, n);
%random value from -sigma to sigma
theta1 = 2*(2*rand(hid,n)-1);
theta2 = (2*rand(1,hid)-1);
%flag = 0;
for i = 1:10
    sumerror = 0;
    for j=1:m
        %calculate the hidden layer
        L2 = 1./(1+exp(-(theta1*trainX(j,:)')));
        %calculate the predict out layer
        Lout = 1/(1+exp(-(theta2*L2)));
%        erroro = Lout*(1-Lout)*(trainY(j)-Lout);
        %error in output layer
        erroro = (trainY(j)-Lout);
        %calculate sum error
        sumerror = sumerror + abs(erroro);
%          if(erroro == 0)
%             flag = 1;
%             break;
%         end
        errorh = L2.*(1-L2).*(theta2'*erroro);
        %feed back
        theta2 = theta2 + d*erroro*(L2');
        theta1 = theta1 + d.*errorh*(trainX(j,:));
    end
    %if converge then stop
    if sumerror < 10
        disp(i);
        disp('hello world');
        break;
    end
%     if(flag == 1)
%         disp(j);
%         flag = 0;
%     end
end
    error = 0;
    pre = zeros(m,1);
    correct = 0;
    lost = 0;
    for j=1:m
        %predict, calculate the error,lost and correct rate
        L2 = 1./(1+exp(-(theta1*trainX(j,:)')));
        out = 1./(1+exp(-(theta2*L2)));
        if(out >0.5)
            pre(j) = 1;
        else
            pre(j) = 0;
        end
        if(pre(j) ~= trainY(j))
            error=error+1;
        end
        if(pre(j) == 1 && trainY(j) ==1)
            correct = correct+1;
        end
        if(pre(j) == 0 && trainY(j) ==1)
            lost = lost+1;
        end
    end
%     disp(sum(pre));
%     disp(sum(trainY));
error_rate = error/m;
if(sum(pre)~=0)
    correct_rate = correct/sum(pre);
else
    correct_rate = 0;
end
if(sum(trainY)~=0)
    lost_rate = lost/sum(trainY);
else
    lost_rate = 0;
end

% disp('train correct rate is');
% disp(correct_rate);
% disp('train lost rate is');
% disp(lost_rate);
% disp('train error rate is');
% disp(error_rate);
% plot(i,error_rate,'*');
% hold on;
% end
%toc;
end
