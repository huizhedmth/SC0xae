clear all;
close all;
load 'parkinsons.mat';


distance = zeros(117,1); % the euclidean distances from an input to 
                         % each sample
class = zeros(29,1);     % result of kNN classification
error = zeros(5,1);      
score = zeros(7,1);      % 5-fold cross validation score

% -- begin
for k = 1:2:13
    % 5-fold cross validation
    for f = 1:5    % 5-fold
        % build train and test matrix
        trainX = [trainsetX(1:29*(f-1),:); trainsetX(29*f+1:end, :)];
        testX = trainsetX(29*(f-1)+1:29*f,:);
        trainY = [trainsetY(1:29*(f-1),:); trainsetY(29*f+1:end, :)];
        testY = trainsetY(29*(f-1)+1:29*f,:);
        for n = 1:29    % for each line(input)
            for m = 1:117 % for each sample
                % calculate eucilead distances between current input
                % and each sample
                distance(m,1) = sqrt(sum((trainX(m,:) - testX(n, :)).^2));
            end;
            
            % label current input according to labels of the nearest k
            % samples
            temp1 = sort(distance);
            tmp2 = temp1(k,1);    % the k-th smallest value
            labels = trainY(find(distance <= tmp2));
            one_count = size(find(labels),1);
            zero_count = k - one_count;
            class(n,1) = one_count > zero_count;
        end
        % record error
        error(f,1) = sum(xor(class, testY));
    end
    % calculate score
    score((k+1)/2,1) = sum(error) / (29*5); 
end
  
% plot
x = [1,3,5,7,9,11,13];
plot(x,score,'-o');
title('5-fold');
xlabel('k');
ylabel('error rate');