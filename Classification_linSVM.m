% By Matee Ullah
clear;
clc;

load train_Sup_400.mat;
total = 0;
acc = zeros(1,10);
decValues = cell(1,10);
predectedLabels = cell(1,10);
mTestY = [];
predL = [];
actualL = [];
psvm = [];
saveDir='./results/linSVM_400/';
CatNames = {'Cytopl', 'ER', 'Gol', 'Lyso', 'Mito', ...
        'Nucl', 'Vesi'};    
for i=1:10
kfold = strcat('kfold',num2str(i));
trainX = Sup_400.(kfold).trainX;
trainY = Sup_400.(kfold).trainY;
testX = Sup_400.(kfold).testX;
testY = Sup_400.(kfold).testY;
multi_testY = Sup_400.(kfold).multi_testY;
mTestY = [mTestY multi_testY];
c = 2.^[-5:1:10];  
acc_cv = zeros(1,length(c));
% Brute force grid search
for m=1:length(c),
    tic;   
        options = ['-s 0', ' -t 0', ' -c ' num2str(c(m)) ' -v 10'];
        accuracy_b= svmtrain( trainY, trainX, options);
        acc_cv(m)=accuracy_b;
%         model_b= svmtrain( trainY, trainX, options);
%         [predict_b, accuracy_b, dec_values_b] = svmpredict(testY, testX, model_b);
%         acc_cv(m)=accuracy_b(1);
    end
     toc
[a row] = max(acc_cv);
[a col] = max(a);
row = row(col);
str= ['-s 0 -t 0', ' -c ' num2str(c(row)) ' -b 1'];
% str=['-s 0 -t 0 -c 128 -b 1 -q'];
model = svmtrain(trainY,trainX, str);
[predict_label, accuracy, dec_values] = svmpredict(testY,testX,model, '-b 1');
acc(1,i)=accuracy(1);
psvm = [psvm;dec_values];
decValues(i) = {dec_values};
predectedLabels(i)= {predict_label};
predL = [predL;predict_label];
actualL = [actualL;testY];
end
acclast=mean(actualL==predL)
kfold_linSVM_sda_RFE.Acc = acc;
kfold_linSVM_sda_RFE.decValues = decValues;
kfold_linSVM_sda_RFE.predectedLabels = predectedLabels;
kfold_linSVM_sda_RFE.predL = predL;
kfold_linSVM_sda_RFE.actualL = actualL;
kfold_linSVM_sda_RFE.mTestY = mTestY;
save kfold_linSVM_sda_RFE400 kfold_linSVM_sda_RFE;

%% Results
for iacc=1:length(acc)
    total = total+acc(iacc);
end
av_accuracy = total/10;
ROCraw.true =mTestY; ROCraw.predicted = psvm;
ConfMat = confusionmat(actualL, predL);
% create and save ROC plot for last experiment
showMyConfusionMatrix(ConfMat, 'SVM', CatNames, saveDir);
AUC = showMyROC(ROCraw,  'SVM', CatNames,  saveDir); 
meanAUC = mean(cell2mat(AUC))
stdAUC = std(cell2mat(AUC))
Myresult = [av_accuracy meanAUC stdAUC];
save MyFinalResult400.mat Myresult;