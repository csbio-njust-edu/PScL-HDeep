clc;
clear;
load all_labels;
CVO = cvpartition(label_all', 'k', 10);
CV.CVO = CVO;
for i=1:10
    kfold = strcat('kfold',num2str(i));
    trIdxUn = CVO.training(i);
    teIdxUn = CVO.test(i);
    CV.(kfold).trIdxUn = trIdxUn;
    CV.(kfold).teIdxUn = teIdxUn;
end

save tenFold_CV_indeces CV