%function [] = rp_HumanEva_write_avi_file()
% Write AVI file from combined frame and filmstrip images
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       24/4/2007

clear all
close all

frame_dir = dir('F:\test_sets\image_descriptors\HumanEva_I\frames\test\V0_S1_Walking_2_(c1)\\*.png');
filmstrip_dir = dir('F:\\test_sets\\image_descriptors\\HumanEva_I\\filmstrip\\HoG_V4_S1_Walking_2_(c1)\\*.png');
frames = size(frame_dir, 1);

%Open aviobject and write to file
avi_file = avifile('C:\\Ronald\\combined_results_xvid_5_HumanEva-I_S1_Walking_2.avi', 'compression', 'xvid', 'quality', 20, 'colormap', 'jet', 'FPS', 3);
for i=1:5:frames
    tic
   
    % read image from frames
    frame = imread(strcat('F:\test_sets\image_descriptors\HumanEva_I\frames\test\V0_S1_Walking_2_(c1)\\', frame_dir(i).name));
    
    % read image from filmstrip
    filmstrip = imread(strcat('F:\\test_sets\\image_descriptors\\HumanEva_I\\filmstrip\\HoG_V4_S1_Walking_2_(c1)\\', filmstrip_dir(i).name));
    
    % merge images
    combined = [imresize(frame, [480,640], 'bicubic') filmstrip];
    
    % write frame
    avi_file = addframe(avi_file, im2frame(combined, 'jet'));
    fprintf('%d\t%d\n', i, toc);
end
avi_file = close(avi_file);

%end

