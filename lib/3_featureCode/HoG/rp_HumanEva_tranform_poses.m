%function [] = rp_HumanEva_tranform_poses()
% Reads global pose data in .mat format and transforms these to
% translation-free poses for each camera.
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       4/4/2007

% torsal index
torsal_index = 2;

% load camera calibration matrices
load('rp_camera_cal.mat');

% find pose matrices
pose_files = dir('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V0_*.mat');

% loop over all pose matrices (correspond to movies)
for FILE=1:size(pose_files, 1)
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\%s', pose_files(FILE).name);
    load(filename);
    
    pose = [[1:size(pose, 1)]' pose];
    valid = pose(:, 2);
    pose = pose(valid == 1, :);
    
    frames = size(pose, 1);
    pose_temp = pose;
    
    % remove torsal joint
    torsal_matrix = [zeros(frames, 2) repmat(pose_temp(:, (torsal_index * 3):(torsal_index+1) * 3 - 1), 1, 20) pose_temp(:, 63:82)];
    pose = pose_temp - torsal_matrix;
    
    % write c11, c22 and c33 files
    extension = pose_files(FILE).name(6:length(pose_files(FILE).name)-4);
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c11).mat', extension);
    save(filename, 'pose');
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c22).mat', extension);
    save(filename, 'pose');
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c33).mat', extension);
    save(filename, 'pose');
    
    pose_c12 = zeros(frames, 82);
    pose_c13 = zeros(frames, 82);
    pose_c21 = zeros(frames, 82);
    pose_c23 = zeros(frames, 82);
    pose_c31 = zeros(frames, 82);
    pose_c32 = zeros(frames, 82);
    
    % loop over all valid frames
    tic
    for FRAME=1:frames
        coords = pose_temp(FRAME, 3:62);
        coords = [reshape(coords, 3, 20); ones(1, 20)];

        % c12
        coords_trans = M1_inv * M2 * coords;
        coords_trans = coords_trans(1:3, :);
        torsal_matrix = repmat(coords_trans(:, torsal_index), 1, 20);
        coords_trans = coords_trans - torsal_matrix;
        pose_c12(FRAME, :) = [pose_temp(FRAME, 1:2) reshape(coords_trans, 1, 60) pose_temp(FRAME, 63:82)];
 
        % c13
        coords_trans = M1_inv * M3 * coords;
        coords_trans = coords_trans(1:3, :);
        torsal_matrix = repmat(coords_trans(:, torsal_index), 1, 20);
        coords_trans = coords_trans - torsal_matrix;
        pose_c13(FRAME, :) = [pose_temp(FRAME, 1:2) reshape(coords_trans, 1, 60) pose_temp(FRAME, 63:82)];
 
        % c21
        coords_trans = M2_inv * M1 * coords;
        coords_trans = coords_trans(1:3, :);
        torsal_matrix = repmat(coords_trans(:, torsal_index), 1, 20);
        coords_trans = coords_trans - torsal_matrix;
        pose_c21(FRAME, :) = [pose_temp(FRAME, 1:2) reshape(coords_trans, 1, 60) pose_temp(FRAME, 63:82)];
 
        % c23
        coords_trans = M2_inv * M3 * coords;
        coords_trans = coords_trans(1:3, :);
        torsal_matrix = repmat(coords_trans(:, torsal_index), 1, 20);
        coords_trans = coords_trans - torsal_matrix;
        pose_c23(FRAME, :) = [pose_temp(FRAME, 1:2) reshape(coords_trans, 1, 60) pose_temp(FRAME, 63:82)];

        % c31
        coords_trans = M3_inv * M1 * coords;
        coords_trans = coords_trans(1:3, :);
        torsal_matrix = repmat(coords_trans(:, torsal_index), 1, 20);
        coords_trans = coords_trans - torsal_matrix;
        pose_c31(FRAME, :) = [pose_temp(FRAME, 1:2) reshape(coords_trans, 1, 60) pose_temp(FRAME, 63:82)];
 
        % c32
        coords_trans = M3_inv * M2 * coords;
        coords_trans = coords_trans(1:3, :);
        torsal_matrix = repmat(coords_trans(:, torsal_index), 1, 20);
        coords_trans = coords_trans - torsal_matrix;
        pose_c32(FRAME, :) = [pose_temp(FRAME, 1:2) reshape(coords_trans, 1, 60) pose_temp(FRAME, 63:82)];

    end

    fprintf('%s: \t%d in %d \n', pose_files(FILE).name, frames, toc);
    tic

    pose = pose_c12;
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c12).mat', extension);
    save(filename, 'pose');
    pose = pose_c13;
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c13).mat', extension);
    save(filename, 'pose');
    pose = pose_c21;
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c21).mat', extension);
    save(filename, 'pose');
    pose = pose_c23;
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c23).mat', extension);
    save(filename, 'pose');
    pose = pose_c31;
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c31).mat', extension);
    save(filename, 'pose');
    pose = pose_c32;
    filename = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V1%s_(c32).mat', extension);
    save(filename, 'pose');
end

%end
