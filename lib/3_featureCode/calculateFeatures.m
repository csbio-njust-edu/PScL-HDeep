function calculateFeatures(readpath, writepath, dbtype, NLEVELS, params)
feattype=params.featCalc.FEATTYPE;
sigmaSet=params.featCalc.sigmaSet;
F=params.featCalc.F;
snr=params.featCalc.snr;
K=params.featCalc.K;
C=params.featCalc.C;
Ls=params.featCalc.Ls;
Lr=params.featCalc.Lr;
M = params.featCalc.M;
% net = params.featCalc.net;
load Map.mat
load numbers number
labels_name=params.general.CLASSLABELS{number}
if strcmp(labels_name,'Cytoplasm')
    labels=1;
end
 if strcmp(labels_name,'ER')
    labels=2;
end   
if strcmp(labels_name,'Golgi_apparatus')
    labels=3;
end
if strcmp(labels_name,'Lysosome')
    labels=4;
end
if strcmp(labels_name,'Mitochondria')
    labels=5;
end
if strcmp(labels_name,'Nucleus')
    labels=6;
end
if strcmp(labels_name,'Vesicles')
    labels=7;
end

if strcmp(feattype, 'SLFs_LBPs')
   if exist( writepath,'file')
        load (writepath);
        if length(features)==1097
            return
        end
   end
      
    I = imfinfo( readpath);
    H = imread( readpath);
    J = reconIH( imread(I.Comment), H);
   [DNAF HaralickF lbpF] = tissueFeatures( J(:,:,2), J(:,:,1), dbtype, NLEVELS, feattype);
    
    features = [DNAF HaralickF lbpF];
    save( writepath, 'features');
    path2char = char(writepath);
    dnatail = '_dna_feat.mat';
    htail = '_haralick_feat.mat';
    lbptail = '_lbp_feat.mat';
    dnapath = [path2char(1:end-4) dnatail];
    hpath = [path2char(1:end-4) htail];
    lbppath = [path2char(1:end-4) lbptail];
    save( dnapath, 'DNAF');
    save( hpath, 'HaralickF');
    save( lbppath, 'lbpF');
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    writepath2 ='./data//features_21.mat';
%      save writepath2  features_all
     
      load all_features_SLFs_LBPs SLFs_LBPs 
     SLFs_LBPs=[ SLFs_LBPs; features];
     save all_features_SLFs_LBPs SLFs_LBPs 

    writepath3 ='./data//label_21.mat';
    %      save writepath2  features_all 
     load all_labels  label_all 
     label_all=[ label_all; labels];
     save all_labels  label_all 

end 
 
 %% LET features calculation
 
 if strcmp(feattype, 'LET')
    if exist( writepath,'file')
        load (writepath);
        if length(LETfeat)==413
            return
        end
   end 
    I = imfinfo( readpath);
    H = imread( readpath);
    J = reconIH( imread(I.Comment), H);
    prot = J(:,:,2);
    % BG subtraction by most-common-pixel
    [c b] = imhist(prot);
    [a i] = max(c);
    prot = prot - b(i);
    
    prot=single(prot);
    prot = (prot-mean(prot(:)))/std(prot(:));
    LETfeat = getFeatsCodes(F, sigmaSet, prot, Ls, Lr, K, C);
    save( writepath, 'LETfeat');
    
    load LET_all_feat  LET 
    LET=[ LET; LETfeat];
    save LET_all_feat  LET
     
    load all_labels  label_all 
    label_all=[ label_all; labels];
    save all_labels  label_all 
     
 end 
 
 %% AHP2 features calculation
 if strcmp(feattype, 'AHP2')
     if exist( writepath,'file')
        load (writepath);
        if length(AHP_feat)==84
            return
        end
   end 
    I = imfinfo( readpath);
    H = imread( readpath);
    J = reconIH( imread(I.Comment), H);
    prot = J(:,:,2);
    % BG subtraction by most-common-pixel
    [c b] = imhist(prot);
    [a i] = max(c);
    prot = prot - b(i);
    
    quantization_level = 2;
    parameter = get_ahp_parameter(quantization_level);
    AHP2_feat=[ahp(prot,8,1,map1riu,parameter) ahp(prot,16,2,map2riu,parameter)];
    
    save( writepath, 'AHP2_feat');
    
    load AHP2_all_feat AHP2
    AHP2=[ AHP2; AHP2_feat];
    save AHP2_all_feat AHP2
     
    load all_labels  label_all 
    label_all=[ label_all; labels];
    save all_labels  label_all 
 end
 %% AHP5 features calculation
 if strcmp(feattype, 'AHP5')
     if exist( writepath,'file')
        load (writepath);
        if length(AHP_feat)==336
            return
        end
   end 
    I = imfinfo( readpath);
    H = imread( readpath);
    J = reconIH( imread(I.Comment), H);
    prot = J(:,:,2);
    % BG subtraction by most-common-pixel
    [c b] = imhist(prot);
    [a i] = max(c);
    prot = prot - b(i);
    
    quantization_level = 5;
    parameter = get_ahp_parameter(quantization_level);
    AHP5_feat=[ahp(prot,8,1,map1riu,parameter) ahp(prot,16,2,map2riu,parameter)];
    
    save( writepath, 'AHP5_feat');
    
    load AHP5_all_feat AHP5
    AHP5=[ AHP5; AHP5_feat];
    save AHP5_all_feat AHP5
     
    load all_labels  label_all 
    label_all=[ label_all; labels];
    save all_labels  label_all 
 end
 
 %% RICLBP features calculation
 if strcmp(feattype, 'RICLBP')
     if exist( writepath,'file')
        load (writepath);
        if length(RICLBP_feat)==408
            return
        end
   end 
    I = imfinfo( readpath);
    H = imread( readpath);
    J = reconIH( imread(I.Comment), H);
    prot = J(:,:,2);
    % BG subtraction by most-common-pixel
    [c b] = imhist(prot);
    [a i] = max(c);
    prot = prot - b(i);
	
    %AC2= [cvtRICLBP(prot,1,2,M); cvtRICLBP(prot,2,4,M); cvtRICLBP(prot,4,8,M);];
    AC2= [cvtRICLBP(prot,1,2,M) cvtRICLBP(prot,2,4,M) cvtRICLBP(prot,4,8,M);];
    AC2(find(isnan(AC2)))=0;
    RICLBP_feat=AC2;
    
    save( writepath, 'RICLBP_feat');
    
    load RICLBP_all_feat  RICLBP 
    RICLBP=[ RICLBP; RICLBP_feat];
    save RICLBP_all_feat  RICLBP 
     
    load all_labels  label_all 
    label_all=[ label_all; labels];
    save all_labels  label_all 
 end
 
  %% HoG features calculation
 if strcmp(feattype, 'HoG')
     if exist( writepath,'file')
        load (writepath);
        if length(HoG_feat)==270
            return
        end
   end 
    I = imfinfo( readpath);
    H = imread( readpath);
    J = reconIH( imread(I.Comment), H);
    prot = J(:,:,2);
    % BG subtraction by most-common-pixel
    [c b] = imhist(prot);
    [a i] = max(c);
    prot = prot - b(i);
    
    HoG_feat=[EstraiHoG(single(prot),[],5,6)];
    
    save( writepath, 'HoG_feat');
    
    load HoG_all_feat HoG 
    HoG=[ HoG; HoG_feat];
    save HoG_all_feat HoG
     
    load all_labels  label_all 
    label_all=[ label_all; labels];
    save all_labels  label_all 
 end
 
 %% CLBP features calculation
 if strcmp(feattype, 'CLBP')
	if exist( writepath,'file')
        load (writepath);
        if length(CLBP_feat)==906
            return
        end
     end 
    I = imfinfo( readpath);
    H = imread( readpath);
    J = reconIH( imread(I.Comment), H);
    prot = J(:,:,2);
    % BG subtraction by most-common-pixel
    [c b] = imhist(prot);
    [a i] = max(c);
    prot = prot - b(i);
    
    if size(prot,1)<5
    prot(5,:)=0;
    end
    if size(prot,2)<5
    prot(:,5)=0;
    end
    [CLBP_S,CLBP_M,CLBP_C] = clbp(prot,1,8,map1,'x');
    CLBP_SH = hist(CLBP_S(:),0:map1.num-1);
    CLBP_MH = hist(CLBP_M(:),0:map1.num-1);
    CLBP_MC = [CLBP_M(:),CLBP_C(:)];
    Hist3D = hist3(CLBP_MC,[map1.num,2]);
    CLBP_MCH = reshape(Hist3D,1,numel(Hist3D));
    CLBP_S_MCH1 = [CLBP_SH,CLBP_MCH];

    [CLBP_S,CLBP_M,CLBP_C] = clbp(prot,2,16,map2,'x');
    CLBP_SH = hist(CLBP_S(:),0:map2.num-1);
    CLBP_MH = hist(CLBP_M(:),0:map2.num-1);
    CLBP_MC = [CLBP_M(:),CLBP_C(:)];
    Hist3D = hist3(CLBP_MC,[map2.num,2]);
    CLBP_MCH = reshape(Hist3D,1,numel(Hist3D));
    CLBP_S_MCH2 = [CLBP_SH,CLBP_MCH];
    CLBP_feat=[CLBP_S_MCH1 CLBP_S_MCH2];
    
    save( writepath, 'CLBP_feat');
    
    load CLBP_all_feat CLBP
    CLBP=[ CLBP; CLBP_feat];
    save CLBP_all_feat CLBP
     
    load all_labels  label_all 
    label_all=[ label_all; labels];
    save all_labels  label_all 
 end
 
  %% CNN features calculation
 if strcmp(feattype, 'CNN')
     if exist( writepath,'file')
        load (writepath);
        if length(CNN_feat)==3
            return
        end
     end 
   
    I = imfinfo( readpath);
    img = imread(I.Comment);

    [feat_L39 feat_L42 scores]=extract_Deep_Feat(net, img);
    CNN_feat{1} = feat_L39;
    CNN_feat{2} = feat_L42;
    CNN_feat{3} = scores;
    save( writepath, 'CNN_feat');
    
    load CNN_all_feat CNN
    CNN=[ CNN; CNN_feat];
    save CNN_all_feat CNN
     
    load all_labels  label_all 
    label_all=[ label_all; labels];
    save all_labels  label_all 
 end
end
    
 