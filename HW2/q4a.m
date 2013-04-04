clear all;
close all;
load 'parkinsons.mat';


distance = zeros(146,1); % the euclidean distances from an input to 
                         % each sample
class = zeros(49,1);     % result of kNN classification

% -- begin
for n = 1:49    % for each line(input)
    for m = 1:146 % for each sample
         % calculate eucilead distances between current input
         % and each sample
         distance(m,1) = sqrt(sum((trainsetX(m,:) - testsetX(n, :)).^2));
    end;
    % label current input with the class of the nearest sample
    class(n,1) = trainsetY(find(distance == min(distance)), 1);
end

% find misclassifications
error = sum(xor(class, testsetY));
error_rate = error / length(testsetY);

