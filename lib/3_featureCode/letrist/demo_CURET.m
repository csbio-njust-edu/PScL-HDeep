% -------------------------------------------
% The source code for the paper:
% LETRIST: Locally Encoded Transform Feature Histogram for Rotation-Invariant Texture Classification, by Tiecheng Song, Hongliang Li, Fanman Meng, Qingbo Wu, and Jianfei Cai,
% IEEE TCSVT, submitted, 
% tggwin@gmail.com  
% --------------------------------------------
close all;clear all;clc
addpath('./helpfun');
imdir = './CURET/';
savedir = ['./_features/CURET']; % save features 
mkdir_bo(savedir);
datadir = 'results'; % save classification accuracy
mkdir_bo(datadir);     

%% feature extraction
sigmaSet = [1 2 4]; 
F = makeGDfilters(sigmaSet);
snr = 0; % here "0" only denotes "No noise"
K = 2;
C = 1;
Ls = 3;
Lr = 5;  
imageDatasetLabel = get_im_label(imdir);
imageDatasetFeatPath = get_feature_path(savedir); 

tic;
fprintf('\n..................extracting image descriptors\n')   
calculate_LETRIST_features(imdir, savedir, 'png', F, sigmaSet, Ls, Lr, K, C, snr);
imageDatasetFeatPath = get_feature_path(savedir);  

%% classification
trail = 100; % results averaged over 100 runs
trainnum = 46;% trainning number per class  
imageDatasetfea = load_feature(imageDatasetFeatPath);  

rand('state',0);
randn('state',0);     

for i = 1:trail
    % generate training and test partitions
    indextrain = [];
    indextest = [];
    labelnum = unique(imageDatasetLabel);
    for j = 1:length(labelnum)
        index = find(imageDatasetLabel == j);
        perm = randperm(length(index));
        indextrain = [indextrain index(perm(1:trainnum))];
        indextest = [indextest index(perm(trainnum+1:end))];
    end

    trainfeatures = imageDatasetfea(indextrain,:);
    trainlabel = imageDatasetLabel(:,indextrain);
    testfeatures = imageDatasetfea(indextest,:);
    testlabel = imageDatasetLabel(:,indextest);

    trainNum = size(trainfeatures,1);
    testNum = size(testfeatures,1);
    DM = zeros(testNum,trainNum);
    for j=1:testNum
        test = testfeatures(j,:);
        DM(j,:) = distMATChiSquare(trainfeatures,test)';
    end
    % Nearest-neighborhood classifier
    CP=ClassifyOnNN(DM,trainlabel,testlabel);
    cp_avg(1,i) = CP;
    clear trainfeatures testfeatures DM
end
disp(['Total running time is ' num2str(toc/60) ' mins']);

AP=mean(cp_avg)
save(['.\results\CURET_LETRIST.mat'], 'AP');







