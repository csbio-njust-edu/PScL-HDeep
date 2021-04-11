% example of HDR
function [ HDRdataset ] =mRMRfeatureSelect( rawData,label )

rawX        = rawData;
dataC       =label;
preDataMtd  = 'binarize';

nMRMR       = 100;
wrapper     = 'for';
classifier  = 'NB';
errThres    = 5e-2;
kFold       = 10;

tic;
HDRdataset  = MLpkg.CmptFeatureMRMR(rawX, dataC);

HDRdataset.prepareData(preDataMtd);
HDRdataset.setModelPara(nMRMR, classifier, wrapper, errThres, kFold);

HDRdataset.findCandidateFeature();

% Plot

toc;
end
