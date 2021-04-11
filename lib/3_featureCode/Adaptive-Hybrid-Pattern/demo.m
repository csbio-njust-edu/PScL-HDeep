%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        This is a demo for AHP algorithm          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is a texture classification demo based on AHP algorithm
% To run this demo, the Outex 10 texture dataset should be placed in the
% same folder with the demo file


clear;clc;

% Dataset information
class = 24;         % The number of class
all_samples = 180;  % The number of samples in each class

% Define the train set and test set for testing
train_set = 1:20;
test_set = 21:all_samples;
train_set_size = length(train_set);
test_set_size = length(test_set);


% Define the quantization level for AHP algorithm and Calculate the 
% quantization thresholds for AHP algorithm

quantization_level = 5;
parameter = get_ahp_parameter(quantization_level);

% Define the radius and neighboring patterns for AHP algorithm
P=8;
R=1;

mapping = getmapping(P,'riu2');

% Calculate the train feature set

train_feasum=[];

for i=1:class
	for j=1:train_set_size
        I=imread(strcat('.\Outex_TC_00010\s',num2str(i),'\',num2str(train_set(j)),'.ras')); 
        final_fea=ahp(I,P,R,mapping,parameter);           
        train_feasum=[train_feasum;final_fea];
    end
end

dis=zeros((class*train_set_size),1);
acc=0;
for i=1:class
    for j=1:test_set_size
        I=imread(strcat('.\Outex_TC_00010\s',num2str(i),'\',num2str(test_set(j)),'.ras')); 
        final_fea=ahp(I,P,R,mapping,parameter);
        for k=1:(class*train_set_size)  
            dis(k)=lbp_dis2(final_fea,train_feasum(k,:));
        end
        [dis,index]=sort(dis);
        if(ceil(index(1)/train_set_size)==i)
            acc=acc+1;
        end
	end
end

acc=acc/class/test_set_size;