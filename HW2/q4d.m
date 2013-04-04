clear all;
close all;
load 'parkinsons.mat';


distance = zeros(146,1); % the euclidean distances from an input to 
                         % each sample
class = zeros(49,1);     % result of kNN classification
error = zeros(7,1);      

% -- begin
for k = 1:2:13
    for n = 1:49    % for each line(input)
        for m = 1:146 % for each sample
            % calculate eucilead distances between current input
            % and each sample
            distance(m,1) = sqrt(sum((trainsetX(m,:) - testsetX(n, :)).^2));
        end;
        % label current input according to labels of the nearest k samples
        temp1 = sort(distance);
        tmp2 = temp1(k,1);    % the k-th smallest value
        labels = trainsetY(find(distance <= tmp2));
        one_count = size(find(labels),1);
        zero_count = k - one_count;
        class(n,1) = one_count > zero_count;
    end
    % find misclassifications
    error((k+1)/2,1) = sum(xor(class, testsetY)) / 49;
end

% plot
x = [1,3,5,7,9,11,13];
plot(x,error,'-o');
title('test');
xlabel('k');
ylabel('error rate');