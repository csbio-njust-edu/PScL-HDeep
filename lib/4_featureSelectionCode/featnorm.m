function [traindata,testdata] = featnorm( traindata,testdata)
% [NORMTRAIN,NORMTEST] = FEATNORM( TRAINDATA, TESTDATA)
% 
% Normalizes traindata values (by column) from -1 to 1 
% (NORMTRAIN), then uses this to normalize testdata (by 
% column) (NORMTEST). NORMTEST is finally truncate so 
% values from are bounded between 0 to 1. 

MItrain = min(traindata,[],1);
MAtrain = MItrain;
for i=1:size(traindata,2)
        traindata(:,i) = traindata(:,i) - MItrain(i);
        MAtrain(i) = max(traindata(:,i));
        traindata(:,i) = traindata(:,i) / MAtrain(i);
end

for i=1:size(testdata,2)
        testdata(:,i) = testdata(:,i) - MItrain(i);
        testdata(:,i) = testdata(:,i) / MAtrain(i);
end
testdata(testdata>1)=1;
testdata(testdata<0)=0;

