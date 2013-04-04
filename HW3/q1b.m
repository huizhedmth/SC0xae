clear all;
close all;
load 'iris_subset.mat';

MAP = [254/255,127/255,0;254/255,0,254/255];
COLORMAP(MAP);

scatter(trainsetX(:,1), trainsetX(:,2),5, trainsetY);
