function imageStats( readpath, writepath)
% IMAGESTATS( READPATH, WRITEPATH)  calculates a few basic image statistics 
%   for the purpose of identifying badly stained images

THR=0.4;
if exist( writepath,'file')
    return
end

prp = writepath;
prp((prp == '/') | (prp == '.')) = '_';
pr = ['tmp/processing_' prp '.txt'];
if ~exist( pr,'file')
    fr = fopen( pr, 'w');
else
    return
end

% Load image
I = imread( readpath);
S = size(I);

% Calculate CY feat
load Wbasis;
W (3,:) = [244 144 153];

V = reshape( 255-I, [S(1)*S(2) S(3)]);
H = findH( V, W);
for i=1:size(H,2)
    [c b] = imhist(H(:,i));
    [a ind] = max(c);
    H(:,i) = H(:,i)-b(ind);
    ma(i) = max(H(:,i));
end
H = (255/max(H(:)))*H;
H = reshape( H, [S(1) S(2) size(H,2)]);
H = H(:,:,3);
thr = 255*graythresh( H);
cyfeat = mean(H(H>thr));
clear W V H

% Calculate total stain feat
J = sum(255-I,3);
J = J / (255*3);
stfeat = sum(J(:)>THR)/(S(1)*S(2));

% and background stain feat
bgfeat = sum(J(J<THR))/(S(1)*S(2));

fiddle = fopen( writepath, 'w');
fwrite( fiddle, [ num2str(cyfeat) ',' num2str(stfeat) ',' num2str(bgfeat) char(10)]);
fclose(fiddle);

fclose(fr);
delete(pr);

return
