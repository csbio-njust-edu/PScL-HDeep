%function [] = rp_HumanEva_test_on_training_set_multicam()
% Calculate error on training set with leave-one-out approach
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       6/4/2007

clear all
close all

n = 25;
use_norm = 1; % 1 = whole vector, 2 = block
dirname = 'F:\\test_sets\\image_descriptors\\HumanEva\\';

% load database
load(strcat(dirname, 'DB_V4_multicam.mat'));

if (use_norm == 1)
    % normalization of whole vector
    normmat = repmat(sum(database(:, 3:812)')', 1, 810);
    database(:, 3:812) = database(:, 3:812) ./ normmat;
else
    % block normalization
    for i=0:29
        normmat = repmat(sum(database(:, 4+(i*9):12+(i*9))')', 1, 9);
        normmat(normmat == 0) = 1;
        database(:, 4+(i*9):12+(i*9)) = database(:, 4+(i*9):12+(i*9)) ./ normmat;
    end
end
clear normmat

% remove sequence (leave-one-out) and limit sequence length
remove_seq = 5;
hog = database(database(:, 2) == remove_seq, 3:812);
pose = database(database(:, 2) == remove_seq, 813:872);
database = database(database(:, 2) ~= remove_cam, :);
frames = size(hog, 1);

% reduce computation time
%frames = 100;
%hog = hog(1:frames, :);
%pose = pose(1:frames, :);

% split database and clean up memory
db_indices = database(:, 1:2);
db_hog = database(:, 3:812);
db_pose = database(:, 813:872);
clear database

% initialize pose matrix
pose_guessed = zeros(frames, 60);
poses_selected = zeros(n, 60);

% loop over all frames
tic
for FRAME = 1:frames
    % obtain distances and ranking
    distances = rp_histogram_distance_manhattan(hog(FRAME, :), db_hog);
    result_matrix = sortrows([distances [1:size(db_hog, 1)]']);
    result_matrix = result_matrix(1:n, :);
    
    % select poses according to camera
    for i=1:n
        poses_selected(i, :) = db_pose(result_matrix(i, 2), :);
    end
    
    % interpolate poses and place pose in pose matrix
    distances = result_matrix(:, 1);
    distances(distances == 0, :) = 1e-8;
    distances = (ones(n, 1) ./ distances);
    distances = distances ./ sum(distances);
   
    pose_guessed(FRAME, :) = sum(poses_selected .* repmat(distances, 1, 60));
    
    if (mod(FRAME, 10) == 0)
        fprintf('frame: %d    time: %d\n', FRAME, toc);
        tic
    end
end

% calculate mean error per pose
error2 = zeros(frames, 20);
for i=1:frames
    error2(i, :) = sqrt(sum(reshape((pose_guessed(i, :) - pose(i, :)) .^ 2, 3, 20)));
end
error2 = mean(error2')';

fprintf('vali  mean: %3.5f\nvali  std:  %3.5f\ntrain mean: %3.5f\ntrain std:  %3.5f\ntotal mean: %3.5f\ntotal std:  %3.5f\n', mean(error2(1:563, :)), std(error2(1:563, :)), mean(error2(564:1176, :)), std(error2(564:1176)), mean(error2), std(error2));

%end