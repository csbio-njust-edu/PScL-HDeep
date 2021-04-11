%function [] = rp_HumanEvaII_show_xml_results()
% Parse validated XML results and shows mean error and standard deviation
%
% Should be placed in the HumanEva-II release code directory
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       22/4/2007

clear all
close all

% read directory contents
savedir = 'F:\\test_sets\\image_descriptors\\HumanEva_II\\results\\validated\\';
result_files = dir(strcat(savedir, '*.xml'));

% loop over all result files
for i = size(result_files):-1:1
    filename = strcat(savedir, result_files(i).name);
    fprintf('%s\n', result_files(i).name);

    [poses, frames, cam, dset, errors] = importXML(body_pose, filename);
    clear poses frames cam dset
    errors = errors';
    
    % select trial
    if (result_files(i).name(28) == '2')
        % subject 2
        set1 = errors(1:350, 1);
        set2 = errors(1:700, 1);
        set3 = errors(1:1202, 1);
        set1 = set1(set1 ~= -1);
        set2 = set2(set2 ~= -1);
        set3 = set3(set3 ~= -1);
    else
        % subject 4
        errors = [errors(1:297, 1); errors(338:1258, 1)];
        set1 = errors(2:310, 1);
        set2 = errors(2:660, 1);
        set3 = errors(2:1218, 1);
        set1 = set1(set1 ~= -1);
        set2 = set2(set2 ~= -1);
        set3 = set3(set3 ~= -1);
    end

    % report
    fprintf('set1 mean: %3.5f\nset1 std:  %3.5f\nset2 mean: %3.5f\nset2 std:  %3.5f\nset3 mean: %3.5f\nset3 std:  %3.5f\n\n', mean(set1), std(set1), mean(set2), std(set2), mean(set3), std(set3));
end

%end
