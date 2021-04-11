function [Xdata label_all] = loadData(parm);
%% LoadData

featType = parm.featType;
 %% Load Particular data.
    if (strcmp(featType,'SLF'))
        % Load Har data.
        load all_features_SLFs_LBPs.mat;
        load all_labels.mat;
        data = SLFs_LBPs;
        DNAraw = data(:,[1:5]);
        %% Remove bad features
        % !!warning: only for SLFs
        DNA_Feat = DNAraw(:,[2:end]);
        save all_features_DNA DNA_Feat
        %%
        Xdata = data(:,[6:841]);
        LBP = data(:,[842:end]);
        save all_features_LBP LBP;
    elseif (strcmp(featType,'LBP'))
        % Load LBP data
        load all_features_LBP.mat;
        load all_labels_LBP.mat;
        Xdata = LBP;
    elseif (strcmp(featType,'RICLBP'))
        % Load RICLBP data
        load RICLBP_all_feat.mat;
        load all_labels_RICLBP.mat;
        Xdata = RICLBP;
    elseif (strcmp(featType,'LET'))
        % Load LET data
        load LET_all_feat.mat;
        load all_labels_LET.mat;
        Xdata = LET;
    elseif (strcmp(featType,'HoG'))
        % Load HoG data
        load HoG_all_feat.mat;
        load all_labels_HoG.mat;
        Xdata = HoG;
    elseif (strcmp(featType,'CLBP'))
        % Load CLBP data
        load CLBP_all_feat.mat;
        load all_labels_CLBP.mat;
        Xdata = CLBP;
    elseif (strcmp(featType,'AHP'))
        % Load AHP data
        load AHP5_all_feat.mat;
        load AHP2_all_feat.mat;
        load all_labels_AHP5.mat;
        Xdata = [AHP2 AHP5];
    elseif (strcmp(featType, 'CNN'))
        % Load CNN data
        load CNN_all_feat.mat;
        load all_labels_CNN.mat;
        data = CNN(:,1)';
        Xdata = cell2mat(data)';
    end