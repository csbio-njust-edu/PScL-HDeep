function save_features(featType)

if (strcmp(featType,'SLFs_LBPs'))
    SLFs_LBPs = [];
    save all_features_SLFs_LBPs SLFs_LBPs

elseif (strcmp(featType,'LET'))
    LET = [];
    save LET_all_feat LET;
elseif (strcmp(featType,'RICLBP'))
    RICLBP = [];
    save RICLBP_all_feat RICLBP;
elseif (strcmp(featType,'HoG'))
    HoG = [];
    save HoG_all_feat HoG;
elseif (strcmp(featType,'CLBP'))
    CLBP = [];
    save CLBP_all_feat CLBP;
elseif (strcmp(featType,'AHP2'))
    AHP2 = [];
    save AHP2_all_feat AHP2;
elseif (strcmp(featType,'AHP5'))
    AHP5 = [];
    save AHP5_all_feat AHP5;
elseif (strcmp(featType, 'CNN'))
    CNN = [];
    save CNN_all_feat CNN;
end
end