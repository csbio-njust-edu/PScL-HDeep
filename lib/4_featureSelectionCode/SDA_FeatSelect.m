function [idx_sda sda_trainX sda_testX] = SDA_FeatSelect(train_data, test_data, trainLabels)
%% Feature Selection by SDA

u = unique(trainLabels);
feat = []; feat{length(u)} = [];
for i1=1:length(u)
    feat{i1} = train_data( trainLabels==u(i1), :);
end
writepath = 'E:\PhD\00-RESEARCH-Bioinformatics\Dataset+Coding\000-My Research\Example Testing\tmp\';
logfilename = [writepath '_sdalog.txt'];
idx_sda = ml_stepdisc( feat,logfilename);
sda_trainX = train_data(:,idx_sda);
sda_testX = test_data(:,idx_sda);