% -------------------------------------------
% The source code for the paper:
% LETRIST: Locally Encoded Transform Feature Histogram for Rotation-Invariant Texture Classification, by Tiecheng Song, Hongliang Li, Fanman Meng, Qingbo Wu, and Jianfei Cai,
% IEEE TCSVT, submitted, 
% tggwin@gmail.com  
% --------------------------------------------
close all;clear all;clc
rootpic = 'Outex_TC_00012\';
datadir = 'results';
if exist(datadir,'dir');
else
   mkdir(datadir);
end

sigmaSet = [1 2 4];
F = makeGDfilters(sigmaSet);
snr = 0; % here "0" only denotes "No noise"
K = 2;
C = 1;
Ls = 3;
Lr = 5;            
picNum = 9120; 

tic
Hist=[];
for i=1:picNum
    filename = sprintf('%s\\images\\%06d.ras', rootpic, i-1);
    display(['.... ' num2str(i) ])
    Gray = imread(filename);
    Gray = im2double(Gray);
    
    if snr~=0 % here "0" only denotes "No noise"
        Gray = awgn(Gray,10*log10(snr),'measured');
    end
        
    I = (Gray-mean(Gray(:)))/std(Gray(:)); % normalized to have zero mean and standard deviation  
    Hist(i,:) = getFeatsCodes(F, sigmaSet, I, Ls, Lr, K, C);
end

% reading data
trainTxt = sprintf('%s000\\train.txt', rootpic);
testTxt = sprintf('%s000\\test.txt', rootpic);
[trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);  
[testIDs, testClassIDs] = ReadOutexTxt(testTxt);

AP = cal_AP(Hist,trainIDs, trainClassIDs,testIDs, testClassIDs)
    
display(['Time consuming ' num2str(toc/60) ' mins'])
save(['./results/TC12t_LETRIST.mat'], 'AP');