% example of HDR
clear; clc;
% import MLpkg.*;
currentFolder = pwd;
addpath(genpath(currentFolder))
dataPath    = '/feature-selection-mRMR/matlab/exampleHDR/';
dataSet     = 'mfeat.mat';
dataFile    = [dataPath, dataSet];
load(dataSet );

rawX        = rawData;
dataC       = kron((1:10)',ones(200,1));
preDataMtd  = 'binarize';

nMRMR       = 120;
wrapper     = 'for';
classifier  = 'NB';
errThres    = 1e-1;
kFold       = 10;

tic;
HDRdataset  = MLpkg.CmptFeatureMRMR(rawX, dataC);

HDRdataset.prepareData(preDataMtd);
HDRdataset.setModelPara(nMRMR, classifier, wrapper, errThres, kFold);

HDRdataset.findCandidateFeature();

% Plot
HDRdataset.compactWrapper('for');
HDRdataset.plot('-ob');
HDRdataset.compactWrapper('back');
HDRdataset.plot('->r');
toc;
