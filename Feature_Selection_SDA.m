%Feature Selection Using Stepwise discriminant analysis (SDA).

close all, clear all, clc;
currentFolder = pwd;
addpath(genpath(currentFolder))

parentFolder = 'E:\PhD\00-RESEARCH-Bioinformatics\Dataset+Coding\000-My Research\1_Paper_code\data';
sdaFolder = fullfile(parentFolder,'4_sda_features');
folder = '4_sda_features';
if ~exist( sdaFolder,'dir')
    mkdir(parentFolder, folder);
end

%% 1. Load Data
featType = {'SLF','LBP','RICLBP','LET','HoG','CLBP','AHP','CNN'};
id = 8; % specifiy the feature's type id in featType. For example id=8 is for CNN
    parm.featType = featType{id};
    [Xdata label_all] = loadData(parm);
    
    %% 2. Set multi label data
    multi_labels01 = prepare_multiLabels(label_all);
    
if strcmp(featType(id),'CNN')   % 
    %% 3. Load 10-fold cross validation indices
    % the purpose is to use the same training and testing indices for each
    % feature set.
    load tenFold_CV_indeces.mat;
%     CNN_DATA_SDA.CVO = CV.CVO;
%     CNN_DATA_SDA.All_Data = Xdata;
%     CNN_DATA_SDA.All_Labels = label_all;
%     CNN_DATA_SDA.All_Multi_Labels01 = multi_labels01;

    for i2 = 1:10
        %% 4. Preparing data
        trIdxUn=[]; teIdxUn=[]; train_x=[]; train_y=[]; test_x=[]; test_y=[];
        train_label7=[]; test_label7=[]; traindata=[]; trainLabels=[]; testdata=[];
        testLabels =[]; train_data=[]; test_data=[]; ranking = []; sda_trainX=[]; sda_testX=[];
        
        kfold = strcat('kfold',num2str(i2));
        trIdxUn = CV.(kfold).trIdxUn;
        teIdxUn = CV.(kfold).teIdxUn;
        traindata= Xdata(trIdxUn,:);
        trainLabels= label_all(trIdxUn,:);
        testdata = Xdata(teIdxUn,:);
        testLabels =label_all(teIdxUn,:);
        train_label7 = multi_labels01(:,trIdxUn);
        test_label7= multi_labels01(:,teIdxUn);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
        % Features Normalizatoin
        
            [train_data,test_data] = featnorm(traindata,testdata);
            train_data = double(train_data*2-1);
            test_data = double(test_data*2-1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SDA

        %% 5. Feature Selection by SDA
        [idx_sda sda_trainX sda_testX] = SDA_FeatSelect(train_data, test_data, trainLabels);
            

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% 6. Saving the optimal features
            % change the prefix of CNN_DATA_SDA to the name of the feature.
            CNN_DATA_SDA.(kfold).idx_sda = idx_sda;
%             CNN_DATA_SDA.(kfold).trIdxUn = trIdxUn;
%             CNN_DATA_SDA.(kfold).teIdxUn = teIdxUn;
%             SLF_DATA_SDA.(kfold).trainX = train_data;
            CNN_DATA_SDA.(kfold).sda_trainX = sda_trainX;
            CNN_DATA_SDA.(kfold).trainY = trainLabels;
            CNN_DATA_SDA.(kfold).multi_trainY = train_label7;
%             SLF_DATA_SDA.(kfold).testX = test_data;
            CNN_DATA_SDA.(kfold).sda_testX = sda_testX;
            CNN_DATA_SDA.(kfold).testY = testLabels;
            CNN_DATA_SDA.(kfold).multi_testY = test_label7;
    end
    savePath = fullfile(sdaFolder,'CNN_DATA_SDA.mat');
    save(savePath, 'CNN_DATA_SDA');
    disp('Feature selection is done.')
else 
    disp('Please choose and modify feature type in string comparison and onward');
    
end