function CP = cal_AP(CLBP_SMCH,trainIDs, trainClassIDs, testIDs, testClassIDs)
% Z. Guo, L. Zhang, and D. Zhang, "A Completed Modeling of Local Binary Pattern Operator for Texture Classification,"
% IEEE Trans. on Image Processing, vol. 19, no. 6, pp. 1657-1663, June 2010

    trains = CLBP_SMCH(trainIDs,:);
    tests = CLBP_SMCH(testIDs,:);
    trainNum = size(trains,1);
    testNum = size(tests,1);
    
    DM = zeros(testNum,trainNum);
    for i=1:testNum;
        test = tests(i,:);        
        DM(i,:) = distMATChiSquare(trains,test)';
    end
    CP=ClassifyOnNN(DM,trainClassIDs,testClassIDs);