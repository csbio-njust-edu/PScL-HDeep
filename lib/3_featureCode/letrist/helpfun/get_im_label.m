function [imlabel, impath] = get_im_label(imdir)
% generate the image paths and the corresponding image labels
% written by Liefeng Bo on 01/04/2011 in University of Washington

% directory
subdir = dir_bo(imdir);
it = 0;
for i = 1:length(subdir)
    datasubdir{i} = [imdir '/' subdir(i).name];
    dataname = dir_bo(datasubdir{i});
    for j = 1:size(dataname,1)
        
	% generate image paths
    if ~strcmp(dataname(j).name(end-1:end),'db') % ??
        it = it + 1;
        impath{1,it} = [datasubdir{i} '/' dataname(j).name];    
        imlabel(1,it) = i;    
    end
    
    end
end

