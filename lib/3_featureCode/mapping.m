clc;
clear;

%% LBP mapping
map1=getmapping(8,'u2');
map2=getmapping(16,'u2');
map1riu=getmapping(8,'riu2');
map2riu=getmapping(16,'riu2');
save ('Map', 'map1','map2','map1riu','map2riu');