clear;
clc;
% 
currentFolder = pwd;
addpath(genpath(currentFolder))
%% 1. Please load all the features. 
load DNA_DATA_kFold.mat; % Remember to normalize the DNA features set before using it.
load SLF_DATA_SDA.mat;
load LBP_DATA_SDA.mat;
load RICLBP_DATA_SDA.mat;
load CLBP_DATA_SDA.mat;
load AHP_DATA_SDA.mat;
load HoG_DATA_SDA.mat;
load LET_DATA_SDA.mat;
load CNN_DATA_SDA.mat;
for i=1:10
kfold = strcat('kfold',num2str(i));
%% 2. Load train data and pass it to ftSel_SVMRFECBR() to rank the training features.
trDNA_feat = DNA_DATA.(kfold).trainX;
trSLF_feat = SLF_DATA_SDA.(kfold).sda_trainX;
trLBP_feat = LBP_DATA_SDA.(kfold).sda_trainX;
trRICLBP_feat = RICLBP_DATA_SDA.(kfold).sda_trainX;
trCLBP_feat = CLBP_DATA_SDA.(kfold).sda_trainX;
trAHP_feat = AHP_DATA_SDA.(kfold).sda_trainX;
trHoG_feat = HoG_DATA_SDA.(kfold).sda_trainX;
trLET_feat = LET_DATA_SDA.(kfold).sda_trainX;
trCNN_feat = CNN_DATA_SDA.(kfold).sda_trainX;
trfeatures = [trDNA_feat trSLF_feat trLBP_feat trRICLBP_feat trCLBP_feat trAHP_feat trHoG_feat trLET_feat trCNN_feat];
trlabels = SLF_DATA_SDA.(kfold).trainY;
trMultiLbls = SLF_DATA_SDA.(kfold).multi_trainY;

%% 3. Ranking using SVM_RFE_CBR.
[ftRank,ftScore] = ftSel_SVMRFECBR(trfeatures,trlabels);

%% 4. Load test data
teDNA_feat = DNA_DATA.(kfold).testX;
teSLF_feat = SLF_DATA_SDA.(kfold).sda_testX;
teLBP_feat = LBP_DATA_SDA.(kfold).sda_testX;
teRICLBP_feat = RICLBP_DATA_SDA.(kfold).sda_testX;
teCLBP_feat = CLBP_DATA_SDA.(kfold).sda_testX;
teAHP_feat = AHP_DATA_SDA.(kfold).sda_testX;
teHoG_feat = HoG_DATA_SDA.(kfold).sda_testX;
teLET_feat = LET_DATA_SDA.(kfold).sda_testX;
teCNN_feat = CNN_DATA_SDA.(kfold).sda_testX;
tefeatures = [teDNA_feat teSLF_feat teLBP_feat teRICLBP_feat teCLBP_feat teAHP_feat teHoG_feat teLET_feat teCNN_feat];
telabels = SLF_DATA_SDA.(kfold).testY;
teMultiLbls = SLF_DATA_SDA.(kfold).multi_testY;

%% 5. Rank features according to SVM_RFE_CBR ranking.
Sup_400.(kfold).trainX = trfeatures(:,ftRank(1:400));
Sup_400.(kfold).trainY = trlabels;
Sup_400.(kfold).multi_trainY = trMultiLbls;
Sup_400.(kfold).testX = tefeatures(:,ftRank(1:400));
Sup_400.(kfold).testY = telabels;
Sup_400.(kfold).multi_testY = teMultiLbls;
end
%% 6. Save the final Super feature set.
save train_Sup_400 Sup_400;