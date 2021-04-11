% This is the source code for the paper: 
% Adaptive Hybrid Pattern for Noise Robust Texture Analysis


% Version 0.2, updated Jan 21, 2015
% Corrected some minor mistakes, revised the code to reduce the time cost

% Version 0.1, pubished on July 24, 2014


% The content of the source code:
% texture.ras ---- Demo texture image for test
% demo.m ---- Demo script for AHP algorithm
% ahp.m ---- The function for AHP algorithm
% get_ahp_parameter.m ---- Calculate the thresholds parameters for AHP algorithm
% getmapping.m ---- The mapping function for the LBP algorithm 
% lbp_dis2.m ---- Calculate chi-square distance between feature histograms

% Outex 10 texture dataset is used for the demo
% To reduce the size of the source code, the texture database is not
% included. The texture dataset can be downloaded from
% http://www.outex.oulu.fi/index.php?page=classification#Outex_TC_00010

% Unzip the Outex_TC_00010.tar.gz and put the dataset at the same folder
% with the demo for testing.

