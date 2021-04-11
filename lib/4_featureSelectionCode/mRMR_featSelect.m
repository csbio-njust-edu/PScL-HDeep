function [ranking mRMR_trainX mRMR_testX] = mRMR_featSelect(train_data, test_data, trainLabels)
%% Feature Selection by mRMR
[mRMRdataset] =mRMRfeatureSelect( train_data, trainLabels);
ranking=mRMRdataset.mrmrFea;
mRMR_trainX = train_data(:,ranking);
mRMR_testX = test_data(:,ranking);