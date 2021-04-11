% function DemoCodesOutex
% This demo codes shows the basic operations of CLBP

% images and labels folder
% please download Outex Database from http://www.outex.oulu.fi, then
% extract Outex_TC_00010 to the "rootpic" folder
rootpic = 'Outex_TC_00010\';
% picture number of the database
picNum = 4320;

% Radius and Neighborhood
R=3;
P=24;

% genearte CLBP features
patternMappingriu2 = Getmapping(P,'riu2');
for i=1:picNum;
    filename = sprintf('%s\\images\\%06d.ras', rootpic, i-1);
    Gray = imread(filename);
    Gray = im2double(Gray);
    Gray = (Gray-mean(Gray(:)))/std(Gray(:))*20+128; % image normalization, to remove global intensity
    
    [CLBP_S,CLBP_M,CLBP_C] = clbp(Gray,R,P,patternMappingriu2,'x');
    
    % Generate histogram of CLBP_S
    CLBP_SH(i,:) = hist(CLBP_S(:),0:patternMappingriu2.num-1);
    
    % Generate histogram of CLBP_M
    CLBP_MH(i,:) = hist(CLBP_M(:),0:patternMappingriu2.num-1);    
    
    % Generate histogram of CLBP_M/C
    CLBP_MC = [CLBP_M(:),CLBP_C(:)];
    Hist3D = hist3(CLBP_MC,[patternMappingriu2.num,2]);
    CLBP_MCH(i,:) = reshape(Hist3D,1,numel(Hist3D));
    
    % Generate histogram of CLBP_S_M/C
    CLBP_S_MCH(i,:) = [CLBP_SH(i,:),CLBP_MCH(i,:)];
    
    % Generate histogram of CLBP_S/M
    CLBP_SM = [CLBP_S(:),CLBP_M(:)];
    Hist3D = hist3(CLBP_SM,[patternMappingriu2.num,patternMappingriu2.num]);
    CLBP_SMH(i,:) = reshape(Hist3D,1,numel(Hist3D));
    
    % Generate histogram of CLBP_S/M/C
    CLBP_MCSum = CLBP_M;
    idx = find(CLBP_C);
    CLBP_MCSum(idx) = CLBP_MCSum(idx)+patternMappingriu2.num;
    CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
    Hist3D = hist3(CLBP_SMC,[patternMappingriu2.num,patternMappingriu2.num*2]);
    CLBP_SMCH(i,:) = reshape(Hist3D,1,numel(Hist3D));
end

% read picture ID of training and test samples, and read class ID of
% training and test samples
trainTxt = sprintf('%s000\\train.txt', rootpic);
testTxt = sprintf('%s000\\test.txt', rootpic);
[trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);
[testIDs, testClassIDs] = ReadOutexTxt(testTxt);

% classification test using CLBP_S, original LBP
trains = CLBP_SH(trainIDs,:);
tests = CLBP_SH(testIDs,:);
trainNum = size(trains,1);
testNum = size(tests,1);
DistMat = zeros(P,trainNum);
DM = zeros(testNum,trainNum);
for i=1:testNum;
    test = tests(i,:);        
    DM(i,:) = distMATChiSquare(trains,test)';
end
CP=ClassifyOnNN(DM,trainClassIDs,testClassIDs)

% classification test using CLBP_M
trains = CLBP_MH(trainIDs,:);
tests = CLBP_MH(testIDs,:);
trainNum = size(trains,1);
testNum = size(tests,1);
DistMat = zeros(P,trainNum);
DM = zeros(testNum,trainNum);
for i=1:testNum;
    test = tests(i,:);        
    DM(i,:) = distMATChiSquare(trains,test)';
end
CP=ClassifyOnNN(DM,trainClassIDs,testClassIDs)

% classification test using CLBP_M/C
trains = CLBP_MCH(trainIDs,:);
tests = CLBP_MCH(testIDs,:);
trainNum = size(trains,1);
testNum = size(tests,1);
DistMat = zeros(P,trainNum);
DM = zeros(testNum,trainNum);
for i=1:testNum;
    test = tests(i,:);        
    DM(i,:) = distMATChiSquare(trains,test)';
end
CP=ClassifyOnNN(DM,trainClassIDs,testClassIDs)

% classification test using CLBP_S_M/C
trains = CLBP_S_MCH(trainIDs,:);
tests = CLBP_S_MCH(testIDs,:);
trainNum = size(trains,1);
testNum = size(tests,1);
DistMat = zeros(P,trainNum);
DM = zeros(testNum,trainNum);
for i=1:testNum;
    test = tests(i,:);        
    DM(i,:) = distMATChiSquare(trains,test)';
end
CP=ClassifyOnNN(DM,trainClassIDs,testClassIDs)

% classification test using CLBP_S/M
trains = CLBP_SMH(trainIDs,:);
tests = CLBP_SMH(testIDs,:);
trainNum = size(trains,1);
testNum = size(tests,1);
DistMat = zeros(P,trainNum);
DM = zeros(testNum,trainNum);
for i=1:testNum;
    test = tests(i,:);        
    DM(i,:) = distMATChiSquare(trains,test)';
end
CP=ClassifyOnNN(DM,trainClassIDs,testClassIDs)

% classification test using CLBP_S/M/C
trains = CLBP_SMCH(trainIDs,:);
tests = CLBP_SMCH(testIDs,:);
trainNum = size(trains,1);
testNum = size(tests,1);
DistMat = zeros(P,trainNum);
DM = zeros(testNum,trainNum);
for i=1:testNum;
    test = tests(i,:);        
    DM(i,:) = distMATChiSquare(trains,test)';
end
CP=ClassifyOnNN(DM,trainClassIDs,testClassIDs)