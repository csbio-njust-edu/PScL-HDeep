function [imgfeat] = load_feature(imagenetsiftpath)

datasize = length(imagenetsiftpath);
load(imagenetsiftpath{1});
dims = size(featH,2);
imgfeat = zeros(datasize,dims);

for n = 1:datasize
    load(imagenetsiftpath{n});
    imgfeat(n,:) = featH;
end
            
