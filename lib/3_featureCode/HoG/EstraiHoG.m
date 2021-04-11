function [hog_descriptor] = rp_CalculateHoG_V3(I, mask,num_cells_x,num_cells_y)
% Calculate histogram of oriented gradients (HoG), based on the CVPR'05
% paper by Dalal & Triggs. Some of the parameters have been altered.
%
% number of cells = 5 x 6
% normalization = L2-sqrt on the whole descriptor
% number of bins = 9, absolute values (0-180)
%
% Adaptation of rp_CalculateHoG to include an extra mask parameter. This
% allows to calculate the HoG without introduced edges due to the
% segmentation.
%
% Written by: Ronald Poppe 
% Revision:   1.0
% Date:       19/03/2007
% 

if nargin==3
    num_cells_x = 5;
    num_cells_y = 6;
end


hog_descriptor = zeros(1, num_cells_x * num_cells_y * 9);
bins = tan([-90:20:90]/180*pi);

% convert image to matrix
% use one of the two lines below
%I = ind2gray(I,map);
%I = rgb2gray(I);
%I = double(I);

% cut image one pixel wider than bounding box
[height, width] = size(I);
I = [zeros(height+2, 1), [zeros(1, width); I; zeros(1, width)], zeros(height+2, 1)];
[y, x] = size(I);

% calculate derivatives
I_r = [I(:, 2:x), zeros(y, 1)] - [zeros(y, 1), I(:, 1:x-1)];
I_c = [I(2:y, :); zeros(1, x)] - [zeros(1, x); I(1:y-1, :)];

% cut image
I_r = I_r(2:height+1, 2:width+1);
I_c = I_c(2:height+1, 2:width+1);
[y, x] = size(I_c);

% calculate orientation and magnitude of gradients
I_c(I_c == 0) = 1e-10;
I_gra = (I_r ./ I_c);
I_mag = sqrt(I_r .* I_r + I_c .* I_c);
I_bin = zeros(y, x);

% mask out all magitudes of background-pixels
I_mag(find(mask == 0)) = 0;

% place edge values in bins
for iy=1:y
    [ignore, I_bin(iy, :)] = histc(I_gra(iy, :), bins);
end
I_bin(I_bin == 9) = 0;

% calculate histograms block-wise
for iy=1:num_cells_y
    for ix=1:num_cells_x
        I_mag_patch = I_mag(floor(y / num_cells_y * (iy - 1) + 1):(floor(y / num_cells_y * iy)), floor(x / num_cells_x * (ix - 1) + 1):(floor(x / num_cells_x * ix)));
        I_bin_patch = I_bin(floor(y / num_cells_y * (iy - 1) + 1):(floor(y / num_cells_y * iy)), floor(x / num_cells_x * (ix - 1) + 1):(floor(x / num_cells_x * ix)));
        for i=0:8
            hog_descriptor(1, ((iy-1) * num_cells_x + (ix-1)) * 9 + i + 1) = sum(sum(I_mag_patch(I_bin_patch == i)));
        end
    end
end

% image-normalization
% L2-sqrt
%hog_descriptor = sqrt(hog_descriptor ./ (1e-10 + sqrt(sum(hog_descriptor .^ 2))));
% L2-norm
%cells(iy, ix, :) = cells(iy, ix, :) ./ (1e-10 + sqrt(sum(cells(iy, ix, :) .^ 2)));
% L1-sqrt
%cells(:, iy, ix) = sqrt(cells(:, iy, ix) ./ (norm(cells(:, iy, ix) + 1e-10)));

end