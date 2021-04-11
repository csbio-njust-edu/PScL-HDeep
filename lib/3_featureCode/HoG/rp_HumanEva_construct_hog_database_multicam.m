%function [] = rp_HumanEva_construct_hog_database_multicam()
% Constructs a single .mat file with all hog descriptors that have valid
% associated mocap data.
%
% frame | seq | HoG c1  |  HoG c2   |  HoG c3   |    pose   |
% -----------------------------------------------------------
%   1   |  2  | 3 - 272 | 273 - 542 | 543 - 812 | 813 - 872 |
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       14/4/2007

% find pose matrices
dirname = 'F:\\test_sets\\image_descriptors\\HumanEva\\poses\\';
pose_files = dir(strcat(dirname, 'PO_V1_*_(c11).mat'));

% initialize database
database = [];

% loop over all sequences
tic
for FILE = 1:size(pose_files, 1)
    % load pose file
    load(strcat(dirname, pose_files(FILE).name));
    frames = size(pose, 1);
    mocap = pose(:, 3:62);
    indices = pose(:, 1);
    
    % load hog descriptors and select valid frames
    hogmat = [];
    for i = 1:3
        filename = sprintf('%sHoG_V4%s_(c%d).mat', dirname, pose_files(FILE).name(1, 6:length(pose_files(FILE).name)-10), i);
        load(filename);
        hogmat = [hogmat hog(indices, :)];
    end
    
    % combine matrices
    database = [database; indices FILE * ones(frames, 1) hogmat mocap];

    fprintf('Included: %s\n', pose_files(FILE).name);
end
fprintf('%d\n', toc);

% write .mat file
filename = sprintf('%sDB_V4_multicam.mat', dirname);
save(filename, 'database');

%end