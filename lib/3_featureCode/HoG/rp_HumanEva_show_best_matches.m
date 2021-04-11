%function [] = rp_HumanEva_show_best_matches()
% Show best matches for n=1 on the HumanEva-I data set
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       11/4/2007

clear all
close all

% load database
dirname = 'F:\\test_sets\\image_descriptors\\HumanEva\\';
load(strcat(dirname, 'DB_V4.mat'));

use_norm = 1; % 1 = entire vector, 2 = block

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
db_hog_train = database(:, 4:273);
database_train = database(:, 1:3);
clear database

% load test sequence
load(strcat(dirname, 'HoG_V4II_S4_Combo_4_(c1).mat'));
hog_test = hog;
clear hog

% number of best matches
matches = 5;
rows = 8;
samples = size(hog_test, 1);

% select random samples
row = randperm(samples)';
row = row(1:rows, 1);

% directories
image_dir = 'F:\\test_sets\\image_descriptors\\HumanEva_I\\frames\\train\\';
test_dir = 'F:\\test_sets\\image_descriptors\\HumanEva_II\\frames\\test\\';
sequences = dir(image_dir);

% loop over all images
for i=1:rows
    subplot(rows, matches + 2, (i-1) * (matches + 2) + 1);

    frame = row(i);
    seq = 1;
    cam = 1;
    %seq = (seq - 1) * 3 + cam
    frames = dir(strcat(test_dir, 'V0II_S4_Combo_4_(c1)', '\\'));
    
    % select sample image
    img = imread(strcat(test_dir, 'V0II_S4_Combo_4_(c1)', '\\', frames(frame+2).name), 'BackgroundColor', [1 1 1]);
    imshow(img);

    % select best match
    hog = hog_test(row(i), :);
    distances = rp_histogram_distance_manhattan(hog, db_hog_train);
    matrix = sortrows([distances [1:size(distances, 1)]']);
    matrix = matrix(1:matches, 2);

    for j=1:matches
        frame = database_train(matrix(j, 1), 1);
        seq = database_train(matrix(j, 1), 2);
        cam = database_train(matrix(j, 1), 3);
        seq = (seq - 1) * 3 + cam;
        frames = dir(strcat(image_dir, sequences(seq+2).name, '\\'));
        
        % select match image
        subplot(rows, matches + 3, (i-1) * (matches + 3) + 2 + j);
        img = imread(strcat(image_dir, sequences(seq+2).name, '\\', frames(frame+2).name), 'BackgroundColor', [1 1 1]);
        imshow(img);
    end
end