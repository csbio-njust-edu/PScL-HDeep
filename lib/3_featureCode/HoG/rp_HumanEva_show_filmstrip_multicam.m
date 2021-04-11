%function [] = rp_HumanEva_show_filmstrip_multicam()
% Calculate single best match and stores all frames in a separate directory
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       14/4/2007

clear all
close all

use_norm = 1; % 1 = entire vector, 2 = block

% load database
dirname = 'F:\\test_sets\\image_descriptors\\HumanEva\\';
load(strcat(dirname, 'DB_V4_multicam.mat'));

if (use_norm == 1)
    % entire vector normalisation
    normmat = repmat(sum(database(:, 4:273)')', 1, 270);
    database(:, 4:273) = database(:, 4:273) ./ normmat;
else
    % block normalisation
    for i=0:29
        normmat = repmat(sum(database(:, 4+(i*9):12+(i*9))')', 1, 9);
        normmat(normmat == 0) = 1;
        database(:, 4+(i*9):12+(i*9)) = database(:, 4+(i*9):12+(i*9)) ./ normmat;
    end
end
clear normmat

% split database and free up memory
db_hog_train = database(:, 3:812);
database_train = database(:, 1:2);
clear database

% load test sequence
action_name = 'HoG_V4_S2_Combo_2_(c1)'
load(strcat(dirname, action_name, '.mat'));
hog_test = hog;
action_name = 'HoG_V4_S2_Combo_2_(c2)'
load(strcat(dirname, action_name, '.mat'));
hog_test = [hog_test hog];
action_name = 'HoG_V4_S2_Combo_2_(c3)'
load(strcat(dirname, action_name, '.mat'));
hog_test = [hog_test hog];
normmat = repmat(sum(hog_test')', 1, 810);
hog_test = hog_test ./ normmat;
samples = size(hog_test, 1);
clear hog normmat

% directories
image_dir = 'F:\\test_sets\\image_descriptors\\HumanEva_I\\frames\\train\\';
filmstrip_dir = 'F:\\test_sets\\image_descriptors\\HumanEva_I\\filmstrip\\';
sequences = dir(image_dir);

% make new dir
mkdir(filmstrip_dir, action_name);

% loop over all images
for i=1:3:samples
    % select best match
    hog = hog_test(i, :);
    distances = rp_histogram_distance_manhattan(hog, db_hog_train);
    matrix = sortrows([distances [1:size(distances, 1)]']);
    matrix = matrix(1, 2);

    frame = database_train(matrix, 1);
    seq = database_train(matrix, 2);
    seq = (seq - 1) * 3 + 1;
    frames = dir(strcat(image_dir, sequences(seq+2).name, '\\'));
    
    % copy image to filmstrip dir
    filename = sprintf('%04d.png', i);
    copyfile(strcat(image_dir, sequences(seq+2).name, '\\', frames(frame+2).name), strcat(filmstrip_dir, action_name, '\\', filename));
end

%end