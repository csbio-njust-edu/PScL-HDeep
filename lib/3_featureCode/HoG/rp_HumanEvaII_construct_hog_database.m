%function [] = rp_HumanEva_construct_hog_database()
% Constructs a single .mat file with all hog descriptors that have valid
% associated mocap data.
%
% frame | seq | cam |  HoG  | pose c1 | pose c2 | pose c3 | pose c4 |
% 
% -----------------------------------------------------------------
%   1   |  2  |  3  | 4-273 | 274-333 | 334-393 | 394-453 | 454-513 |
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       12/4/2007

% find pose matrices
dirname = 'F:\\test_sets\\image_descriptors\\HumanEva\\poses\\';
pose_files = dir(strcat(dirname, 'PO_V0_*.*'));

% initialize database
database = [];

% loop over all sequences
tic
for FILE = 1:size(pose_files, 1)
    extension = sprintf('PO_V1II%s', pose_files(FILE).name(6:length(pose_files(FILE).name)-4));

    % preload file to find length and indices
    filename = sprintf('%s%s_(c11).mat', dirname, extension);
    load(filename);
    frames = size(pose, 1);
    mocap = zeros(frames, 180);
    indices = pose(:, 1);
    
    % load all mocap combinations and construct mocap matrix
    for cam = 1:4
        for cam_to = 1:3
            filename = sprintf('%s%s_(c%d%d).mat', dirname, extension, cam, cam_to);
            load(filename);
            mocap(((cam_to - 1) * frames + 1):(cam_to * frames), ((cam - 1) * 60 + 1):(cam * 60)) = pose(:, 3:62);
        end
    end
    
    % load hog descriptors and select valid frames
    hogmat = [];
    extension = sprintf('PO_V1%s', pose_files(FILE).name(6:length(pose_files(FILE).name)-4));
    for i = 1:3
        filename = sprintf('%sHoG_V4%s_(c%d).mat', dirname, extension(1, 6:length(extension)), i);
        load(filename);
        hogmat = [hogmat; indices FILE * ones(frames, 1) i * ones(frames, 1) hog(indices, :)];
    end
    
    % combine matrices
    database = [database; hogmat mocap];

    fprintf('Included: %s\n', pose_files(FILE).name);
end
fprintf('%d\n', toc);

% write .mat file
filename = sprintf('%sDB_V4II.mat', dirname);
save(filename, 'database');

%end