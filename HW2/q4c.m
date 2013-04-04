clear all;
close all;
load 'parkinsons.mat';


distance = zeros(145,1); % the euclidean distances from an input to 
                         % each sample
class = zeros(1,1);      % result of kNN classification
error = zeros(146,1);      
score = zeros(7,1);      % leave-one-out cross validation score

% -- begin
for k = 1:2:13
    % 5-fold cross validation
    for f = 1:146    % leave-one-out
        % build train and test matrix
        trainX = [trainsetX(1:f-1,:); trainsetX(f+1:146, :)];
        testX = trainsetX(f,:);
        trainY = [trainsetY(1:f-1,:); trainsetY(f+1:146, :)];
        testY = trainsetY(f,:);
 
        for m = 1:145 % for each sample
            % calculate eucilead distances between current input
            % and each sample
            distance(m,1) = sqrt(sum((trainX(m,:) - testX(1, :)).^2));
            
            % label current input according to labels of the nearest k
            % samples
            temp1 = sort(distance);
            tmp2 = temp1(k,1);    % the k-th smallest value
            labels = trainY(find(distance <= tmp2));
            one_count = size(find(labels),1);
            zero_count = k - one_count;
            class = one_count > zero_count;
        end
        % record error
        error(f,1) = xor(class, testY);
    end
    % calculate score
    score((k+1)/2,1) = sum(error) / 146; 
end
  
% plot
x = [1,3,5,7,9,11,13];
plot(x,score,'-o');
title('leave-one-out');
xlabel('k');
ylabel('error rate');