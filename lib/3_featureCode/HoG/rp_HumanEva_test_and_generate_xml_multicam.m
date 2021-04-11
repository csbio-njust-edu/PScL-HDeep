%function [] = rp_HumanEva_test_and_generate_xml_multicam()
% Loads test data, calculates pose estimates, exports the pose vector to
% XML and writes this in a file.
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       14/4/2007

clear all
close all

% parameters
n = 25;
use_norm = 1; % 1 = whole vector, 2 = block
savedir = 'F:\\test_sets\\image_descriptors\\HumanEva_I\\results\\original\\';

% initialize dataset
dset = dataset('HumanEvaI', 'Test');

% load database
dirname = 'F:\\test_sets\\image_descriptors\\HumanEva\\';
load(strcat(dirname, 'DB_V4_multicam.mat'));

% remove Walking S1
%database = database(database(:, 2) ~= 5, :);
%database = database(database(:, 2) ~= 10, :);
%database = database(database(:, 2) ~= 15, :);

if (use_norm == 1)
    % normalization of whole vector
    normmat = repmat(sum(database(:, 3:272)')', 1, 270);
    database(:, 3:272) = database(:, 3:272) ./ normmat;
    normmat = repmat(sum(database(:, 273:542)')', 1, 270);
    database(:, 273:542) = database(:, 273:542) ./ normmat;
    normmat = repmat(sum(database(:, 543:812)')', 1, 270);
    database(:, 543:812) = database(:, 543:812) ./ normmat;
else
    % block normalization
    for i=0:89
        normmat = repmat(sum(database(:, 3+(i*9):11+(i*9))')', 1, 9);
        normmat(normmat == 0) = 1;
        database(:, 3+(i*9):11+(i*9)) = database(:, 3+(i*9):11+(i*9)) ./ normmat;
    end
end
clear normmat

% split database and clean up memory
db_indices = database(:, 1:2);
db_hog = database(:, 3:812);
db_pose = database(:, 813:872);
clear database

for SEQ = 1:length(dset)
    action = sprintf('HoG_V4_%s_%s_%s', char(get(dset(SEQ, 1), 'SubjectName')), char(get(dset(SEQ, 1), 'ActionType')), char(get(dset(SEQ, 1), 'Trial')));
    
    % load test hogs
    sq_hog = [];
    for cam = 1:3
        filename = sprintf('%s%s_(c%d).mat', dirname, action, cam);
        load(filename);
        sq_hog = [sq_hog hog];
    end
    clear hog

    if (use_norm == 1)
        % normalization of whole vector
        normmat = repmat(sum(sq_hog(:, 1:270)')', 1, 270);
        sq_hog(:, 1:270) = sq_hog(:, 1:270) ./ normmat;
        normmat = repmat(sum(sq_hog(:, 271:540)')', 1, 270);
        sq_hog(:, 271:540) = sq_hog(:, 271:540) ./ normmat;
        normmat = repmat(sum(sq_hog(:, 541:810)')', 1, 270);
        sq_hog(:, 541:810) = sq_hog(:, 541:810) ./ normmat;
    else
        % block normalization
        for i=0:89
            normmat = repmat(sum(sq_hog(:, 1+(i*9):9+(i*9))')', 1, 9);
            normmat(normmat == 0) = 1;
            sq_hog(:, 1+(i*9):9+(i*9)) = sq_hog(:, 1+(i*9):9+(i*9)) ./ normmat;
        end
    end
    clear normmat
    
    % initialize body_pose
    frames = size(sq_hog, 1);
    clear body_poses
    body_poses(1:frames) = body_pose;

    % initialize pose matrix
    clear pose_guessed
    pose_guessed = zeros(frames, 60);
    poses_selected = zeros(n, 60);

    % loop over all frames
    fprintf('%s:\t%d\n', action, frames);
    tic
    for FRAME = 1:frames
        % obtain distances and ranking
        distances = rp_histogram_distance_manhattan(sq_hog(FRAME, :), db_hog);
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
        pose_formatted = reshape(pose_guessed(FRAME, :), 3, 20);

        % make body_pose object
        body_poses(FRAME) = body_pose(  'torsoProximal', pose_formatted(:, 1),...
                                        'torsoDistal', pose_formatted(:, 2),...
                                        'upperLArmProximal', pose_formatted(:, 3),...
                                        'upperLArmDistal', pose_formatted(:, 4),...
                                        'lowerLArmProximal', pose_formatted(:, 5),...
                                        'lowerLArmDistal', pose_formatted(:, 6),...
                                        'upperRArmProximal', pose_formatted(:, 7),...
                                        'upperRArmDistal', pose_formatted(:, 8),...
                                        'lowerRArmProximal', pose_formatted(:, 9),...
                                        'lowerRArmDistal', pose_formatted(:, 10),...
                                        'upperLLegProximal', pose_formatted(:, 11),...
                                        'upperLLegDistal', pose_formatted(:, 12),...
                                        'lowerLLegProximal', pose_formatted(:, 13),...
                                        'lowerLLegDistal', pose_formatted(:, 14),...
                                        'upperRLegProximal', pose_formatted(:, 15),...
                                        'upperRLegDistal', pose_formatted(:, 16),...
                                        'lowerRLegProximal', pose_formatted(:, 17),...
                                        'lowerRLegDistal', pose_formatted(:, 18),...
                                        'headProximal', pose_formatted(:, 19),...
                                        'headDistal', pose_formatted(:, 20));

        if (mod(FRAME, 10) == 0)
            fprintf('frame: %d    time: %d\n', FRAME, toc);
            tic
        end
    end

    % export to XML
    filename = sprintf('%s_(c123,n%d,t1)', action, use_norm);
    result = exportXML(body_poses, 1:frames, '', dset(SEQ), strcat(savedir, filename));
end
%end