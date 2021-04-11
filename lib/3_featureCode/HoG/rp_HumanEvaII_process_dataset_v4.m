%function [] = rp_HumanEvaII_process_dataset_v4()
% Processes the HumanEva-II data set and writes bounding boxes and HoG
% descriptors for each frame of each sequence.
%
% Backgrounds are obtained by applying background subtraction and shadow
% removal.
%
% Syntax: 
%       [] = rp_HumanEvaII_process_dataset_v4();
%
% Variables:    
%   min_area   - this positive integer parameter will ensure that all 
%                connected components that are < min_area in pixels are 
%                filtered out (by default 10).
%
% Written by: Leonid Sigal, Ronald Poppe
% Revision:   1.0
% Date:       5/12/2006

clear all
close all

min_area = 600;
%fast_risk = 1/(256^3*10^12);
%fast_risk = 1/(256^3);
fast_risk = 1/(256*256*256*10^80);
%val_thresh = 10 / 255; % CAM 2 & 3
val_thresh = 25 / 255; % CAM 1

% Add paths to the toolboxes
addpath('./TOOLBOX_calib/');
addpath('./TOOLBOX_common/');
addpath('./TOOLBOX_dxAvi/');
addpath('./TOOLBOX_readc3d/'); 

frame_dir = 'F:\\test_sets\\image_descriptors\\HumanEva_II\\frames\\test\\';
background_dir = 'F:\\test_sets\\image_descriptors\\HumanEva_II\\background_V4\\test\\';
mat_dir = 'F:\\test_sets\\image_descriptors\\HumanEva\\';

movie_dir = dir(frame_dir);

% Perform background subtraction
for SEQ = 1:size(movie_dir, 1)
    if (movie_dir(SEQ).isdir == 1 && ~strcmp(movie_dir(SEQ).name, '.') && ~strcmp(movie_dir(SEQ).name, '..'))
        % Path for backgound images
        BG_PATH = strcat('F:\test_sets\HumanEva_II\\S', movie_dir(SEQ).name(7), '\\Background\\');

        % Load background statistics
        for CAM = 1:4
            fprintf('Loading background statistics for CAM %d.\n', CAM)    
            loadfilename = [BG_PATH 'Background_(C' num2str(CAM) ').mat'];
            load(loadfilename);
            background(CAM).CameraName          = sprintf('C%d', CAM);
            background(CAM).BackgroundMeans     = bg_means;
            background(CAM).BackgroundVariances = bg_vars;     
        end
        
        new_dir = strcat('V4', movie_dir(SEQ).name(3:length(movie_dir(SEQ).name)));
        mkdir(background_dir, new_dir);

        d = dir(strcat(frame_dir, movie_dir(SEQ).name,'\\*.png'));
        Nframes = size(d, 1);
        hog = zeros(Nframes, 270);
        fprintf('%s  %d\n', new_dir, Nframes);
                
        % extract camera number
        CAM = movie_dir(SEQ).name(length(movie_dir(SEQ).name)-1)-48;
        bg1_hsv = rgb2hsv(cell2mat(background(CAM).BackgroundMeans));

        bbox = zeros(Nframes, 4);
        tic
        for FRAME = 1:Nframes
            % Load image from the video stream
            image = imread(strcat(frame_dir, movie_dir(SEQ).name, '\\', d(FRAME).name), 'Background', [1 1 1]);
            image = double(image) ./ 255;

            % Compute per-pixel probability that it belongs to
            % background
            bg_prob = zeros(size(image,1), size(image,2));
            for M = 1:length(background(CAM).BackgroundMeans)       
                bg_prob = bg_prob ...
                            + 1/length(bg_means) ...
                            * prod(normpdf(image, ...
                                           background(CAM).BackgroundMeans{M}, ...
                                      sqrt(background(CAM).BackgroundVariances{M})),3);     
            end
            % Classify pixel based on the assumption that foreground
            % is distributed according to uniform distribution.
            bg_img = double(bg_prob < fast_risk);

            % Filter out all connected component area of which is less
            % then min_area
            [L] = bwlabel(bg_img, 4);
            reg = regionprops (L,'Area','BoundingBox');
            L_selected = find([reg.Area] >= min_area);
            bbox_temp = zeros(size(L_selected, 2),4);
            for i=1:size(L_selected, 2)
                bbox_temp(i, :) = reg(L_selected(i),1).BoundingBox;
            end
            bbox_temp(:, 3:4) = bbox_temp(:, 1:2) + bbox_temp(:, 3:4);
            bounding_box = [min(bbox_temp(:, 1)) min(bbox_temp(:, 2)) max(bbox_temp(:, 3)) max(bbox_temp(:, 4))];
            bounding_box(:, 3:4) = bounding_box(:, 3:4) - bounding_box(:, 1:2);

            % crop image
            image_crop = imcrop(image, bounding_box);
            bg_img_crop = imcrop(bg_img, bounding_box);
            [y, x] = size(image_crop);

            % find shadows
            im_hsv = rgb2hsv(image_crop);
            % TODO: bounding box could be placed here to speed up
            % conversion
            bg1_hsv_crop = imcrop(bg1_hsv, bounding_box);
            bg_img_crop_old = bg_img_crop;
            bg_img_crop(find(abs(im_hsv(:, :, 2) - bg1_hsv_crop(:, :, 2)) <= val_thresh)) = 0;
            start_y = floor(4*y/5);
            bg_img_crop(1:start_y, :) = bg_img_crop_old(1:start_y, :);

            % Filter out all connected component area of which is less
            % then min_area
            [L] = bwlabel(bg_img_crop, 4);
            reg = regionprops (L,'Area','BoundingBox');
            L_selected = find([reg.Area] >= min_area);
            bbox_temp = zeros(size(L_selected, 2),4);
            for i=1:size(L_selected, 2)
                bbox_temp(i, :) = reg(L_selected(i),1).BoundingBox;
            end
            bbox_temp(:, 3:4) = bbox_temp(:, 1:2) + bbox_temp(:, 3:4);
            bounding_box2 = [min(bbox_temp(:, 1)) min(bbox_temp(:, 2)) max(bbox_temp(:, 3)) max(bbox_temp(:, 4))];
            bounding_box2(:, 3:4) = bounding_box2(:, 3:4) - bounding_box2(:, 1:2);

            % overlay BG mask on image, make it grayscale and crop it
            image_crop = imcrop(image_crop, bounding_box2);
            image_crop = rgb2gray(image_crop);
            image_crop = double(image_crop);
            bg_img_crop = imcrop(bg_img_crop, bounding_box2);

            % calculate HoG descriptor
            hog(FRAME, :) = rp_CalculateHoG_V3(image_crop, bg_img_crop);
            bbox(FRAME, :) = bounding_box2 + [bounding_box(1, 1:2) 0 0];

            % save background image
            file_name = sprintf('%s%s\\%04d.png', background_dir, new_dir, FRAME);
            imwrite(bg_img_crop, file_name);

            if (mod(FRAME, 10) == 0)
                fprintf('frame: %d    time: %d\n', FRAME, toc);
                file_name = sprintf('%s%s\\%04d.png', background_dir, new_dir, FRAME);
                imwrite(bg_img_crop, file_name);
                tic
            end

        end
        file_name = sprintf('%sBB_%s.mat', mat_dir, new_dir);
        save(file_name, 'bbox');
        file_name = sprintf('%sHoG_%s.mat', mat_dir, new_dir);
        save(file_name, 'hog');
    end
   
end
%end