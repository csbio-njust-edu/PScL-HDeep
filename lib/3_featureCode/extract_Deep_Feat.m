function [feat_L39 feat_L42 scores] = extract_Deep_Feat(net, img)
%By Matee Ullah

% load('imagenet-vgg-verydeep-19.mat') ;
% net.layers=layers;
% net.normalization=meta.normalization;


% Obtain and preprocess an image.
% im = imread('pepper.jpg') ;

IMG = single(img) ; % note: 255 range

im_ = imresize(IMG, net.normalization.imageSize(1:2)) ;
for banda=1:3
    im_(:,:,banda)= im_(:,:,banda)- net.normalization.averageImage(banda);
end
% Run the CNN.
res = vl_simplenn(net, im_) ;

% Show the classification result.
scores = squeeze(gather(res(end).x)) ;
feat_L39 = res(39).x;
feat_L42 = res(42).x;
feat_L39 = feat_L39(:);
feat_L42 = feat_L42(:);
