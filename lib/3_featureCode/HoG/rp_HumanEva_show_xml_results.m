%function [] = rp_HumanEva_show_xml_results()
% Parse validated XML file and shows the mean error and standard deviation
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       14/4/2007

clear all
close all

% read directory contents
savedir = 'F:\\test_sets\\image_descriptors\\HumanEva_I\\results\\validated\\';
result_files = dir(strcat(savedir, '*.xml'));

% loop over all result files
for i = 1:size(result_files)
    filename = strcat(savedir, result_files(i).name);
    fprintf('%s\n', result_files(i).name);

    [poses, frames, cam, dset, errors] = importXML(body_pose, filename);
    clear poses frames cam dset
   
    % remove all invalid frames
    errors = errors(1, 6:size(errors, 2));
    errors_valid = errors(errors ~= -1);
    fprintf('%3.5f (%3.5f)\n', mean(errors_valid), std(errors_valid));
    fprintf('%3.2f (%3.2f)\n\n', mean(errors_valid), std(errors_valid));
end

%end