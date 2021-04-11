function out=ahp(I,neighbors,radius,mapping,parameter)

% Loading thresholdsl parameters
parameter_local = parameter.parameter_local;
parameter_global = parameter.parameter_global;

d_image=double(I);
spoints=zeros(neighbors,2);
a = 2*pi/neighbors; 


for i = 1:neighbors
    spoints(i,1) = -radius*sin((i-1)*a);
    spoints(i,2) = radius*cos((i-1)*a);
end

[ysize, xsize] = size(d_image);

miny=min(spoints(:,1));
maxy=max(spoints(:,1));
minx=min(spoints(:,2));
maxx=max(spoints(:,2));

% Block size, each LBP code is computed within a block of size bsizey*bsizex
bsizey=ceil(max(maxy,0))-floor(min(miny,0))+1;
bsizex=ceil(max(maxx,0))-floor(min(minx,0))+1;

% Coordinates of origin (0,0) in the block
origy=1-floor(min(miny,0));
origx=1-floor(min(minx,0));

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
  error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% Fill the center pixel matrix C.
C = d_image(origy:origy+dy,origx:origx+dx);
d_C = double(C);

% Calculate the global mean and standard deviation for calculating the thresholds 
global_stdvar_image = var(d_image(:))^0.5;
global_mean_image = mean(d_image(:));


% Calculate the local mean and standard deviation for calculating the thresholds 
for i = 1:neighbors
    y = spoints(i,1)+origy;
    x = spoints(i,2)+origx;
    % Calculate floors, ceils and rounds for the x and y.
    fy = floor(y); cy = ceil(y); 
    fx = floor(x); cx = ceil(x); 
    % Check if interpolation is needed.
    % Interpolation needed, use double type images 
    ty = y - fy;
    tx = x - fx;

    % Calculate the interpolation weights.
    w1 = (1 - tx) * (1 - ty);
    w2 =      tx  * (1 - ty);
    w3 = (1 - tx) *      ty ;
    w4 =      tx  *      ty ;
    % Compute interpolated pixel values    
    N{i} = w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
        w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx);
end

[N_width, N_hight] = size(N{1});

local_mean_image = zeros(N_width, N_hight);
local_stdvar_image = zeros(N_width, N_hight);

for i = 1:neighbors
   local_mean_image = local_mean_image + N{i}./neighbors;
end

for i = 1:neighbors
   local_stdvar_image = local_stdvar_image + ((N{i} - local_mean_image).^2)./neighbors;
end

hist_number = length(parameter_local) * 3;  
[N_width, N_hight] = size(N{1});
result = cell(hist_number,1);
for result_cnt = 1:hist_number
    result{result_cnt,1} = zeros(N_width,N_hight);
end
D = cell(hist_number,1);


for i = 1:neighbors
        
	for D_cnt = 1:hist_number
        D{D_cnt,1} = zeros(N_width,N_hight);
    end
    
    D_cnt = 1;
    for cnt = 1:length(parameter_local)
        D{D_cnt,1} = N{i} >= d_C-parameter_local(cnt)*local_stdvar_image;
        D_cnt = D_cnt + 1;
    end

    for cnt = 1:length(parameter_local)
        D{D_cnt,1} = N{i} >= d_C-parameter_local(cnt)*global_stdvar_image;
        D_cnt = D_cnt + 1;
    end
    
    for cnt = 1:length(parameter_global)
        D{D_cnt,1} = N{i} >= global_mean_image-parameter_global(cnt)*global_stdvar_image;
        D_cnt = D_cnt + 1;
    end    
    
  % Update the result matrix.
    v = 2^(i-1);
    for result_cnt = 1:hist_number
        result{result_cnt,1} = result{result_cnt,1} + v*D{result_cnt,1};
    end
end

if isstruct(mapping)
    bins=mapping.num;
    for result_cnt = 1:hist_number
        result_test = result{result_cnt,1};
        for i = 1:N_width-2*radius
            for j = 1:N_hight-2*radius
%                 result{result_cnt,1}(i,j) = mapping.table(result{result_cnt,1}(i,j)+1);
                result_test(i,j) = mapping.table(result_test(i,j)+1);
            end
        end
        result{result_cnt,1} = result_test;
    end
end


fea = cell(hist_number,1);

for fea_cnt = 1:hist_number
    temp = result{fea_cnt,1};
    fea{fea_cnt,1} = hist(temp(:),0:(bins-1));
    fea{fea_cnt,1}=fea{fea_cnt,1}/sum(fea{fea_cnt,1});
end


out = [];

for fea_cnt = 1:hist_number
    out = [out fea{fea_cnt,1}];
end

end


     