function calculate_LETRIST_features(rt_img_dir, rt_data_dir, imtype, F, sigmaSet, Ls, Lr, K, C, snr)

subfolders = dir(rt_img_dir);
database = [];

database.imnum = 0; % total image number of the database
database.cname = {}; % name of each class
database.label = []; % label of each class
database.path = {}; % contain the pathes for each image of each class
database.nclass = 0;

it = 0;
for ii = 1:length(subfolders),
    subname = subfolders(ii).name;    
    if ~strcmp(subname, '.') && ~strcmp(subname, '..'),
        database.nclass = database.nclass + 1;        
        database.cname{database.nclass} = subname;        
        frames = dir(fullfile(rt_img_dir, subname, ['*.' imtype]));
        
        c_num = length(frames);           
        database.imnum = database.imnum + c_num;
        database.label = [database.label; ones(c_num, 1)*database.nclass];
        
        siftpath = fullfile(rt_data_dir, subname);        
        if ~isdir(siftpath),
            % mkdir(siftpath);
        end;
        
        for jj = 1:c_num,
            imgpath = fullfile(rt_img_dir, subname, frames(jj).name);            
            I = imread(imgpath);
            if ndims(I) == 3,
                I = im2double(rgb2gray(I)); 
            else
                I = im2double(I);
            end;
            
            if snr~=0
                I = awgn(I,10*log10(snr),'measured');
            end
            
            I = (I-mean(I(:)))/std(I(:));
            disp(['__' imgpath]);
            
            featH = getFeatsCodes(F, sigmaSet, I, Ls, Lr, K, C);

            it = it + 1;
            save([rt_data_dir '/' sprintf('%06d',it)], 'featH');
        end;    
    end;
end; 

