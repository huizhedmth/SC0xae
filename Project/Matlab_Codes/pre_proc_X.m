load 'data\data.txt';


N = size(data,1);
M = size(data,2);
LOW = 10;
HIGH = N/2;

count = zeros(M,1);
for i = 1:M
    count(i) = sum(data(:,i));
end

% eliminate isolated words
idx1 = find(count > LOW);

% eliminate spam words
idx2 = find(count > HIGH);

idx = setdiff(idx1,idx2);
idx = sort(idx);

trainsetX = data(:,idx);

savefile = 'dataX.mat';
save(savefile,'trainsetX');





