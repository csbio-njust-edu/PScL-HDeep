function outputs = prepareData( method, params)
% OUTPUTS = PREPAREDATA( METHOD, PARAMS)

if ~exist( 'method','var')
    errmsg = 'Please specify method: ''separate'', ''featcalc'', ''classification'', ''prediction'', or ''results''.';
    error( errmsg);
end
if ~exist( 'params','var')
    error( 'Please input simulation parameters');
end

% params = setOptions( params);
outputs.method = method;
umethod = params.separate.UMETHOD;
featset = params.featCalc.FEATSET;
% cmethod = params.classify.CMETHOD;
feattype = params.featCalc.FEATTYPE;

switch method
    case 'parse'
        classes = params.general.ANTIBODY_IDS;
        datadir_root = params.general.DATAROOT;
        writedir_root = [params.general.WRITEROOT '/dataset/'];
        readtail = 'jpg';
        writetail = 'txt';
        addFolder1 = '';
        addFolder2 = '';
    case 'separate'
        classes = params.general.ANTIBODY_IDS;
        datadir_root = params.general.DATAROOT;
        writedir_root = [params.general.WRITEROOT '/2_separatedImages/'];
        readtail = 'jpg';
        writetail = 'png';
        addFolder1 = '';
        addFolder2 = umethod;
    case 'featcalc'
        classes = params.general.ANTIBODY_IDS;
        datadir_root = [params.general.WRITEROOT '/2_separatedImages/'];
        writedir_root = [params.general.WRITEROOT '/3_features/'];
        readtail = 'png';
        writetail = 'mat';
        addFolder1 = umethod;
        addFolder2 = [feattype '/' umethod '_' featset];
    case 'classification'
        classes = params.general.CLASSLABELS;
        datadir_root = [params.general.WRITEROOT '/3_features/'];
        writedir_root = [params.general.WRITEROOT '/4_classification/'];
        readtail = 'mat';
        writetail = 'mat';
        addFolder1 = [feattype '/' umethod '_' featset];
        addFolder2 = [cmethod '/' feattype '/' umethod '_' featset];
    case 'prediction'
        datadir_root = [params.general.WRITEROOT '/3_features/'];
        classifierdir = [params.general.WRITEROOT '/4_classification/'];
        writedir_root = [params.general.WRITEROOT '/5_prediction/'];
        readtail = 'mat';
        writetail = 'mat';
        addFolder1 = ['SLFs_LBPs/' umethod '_' featset];
        addFolder2 = [umethod '_' featset];
    case 'results'
        classes = params.general.CLASSLABELS;
        datadir_root = [params.general.WRITEROOT '/5_prediction/'];
        writedir_root = [params.general.WRITEROOT '/6_biomarkerResults/'];
        readtail = 'mat';
        writetail = 'mat';
        addFolder1 = [umethod '_' featset];
        addFolder2 = '/';
    otherwise
        error( 'Please enter a valid method');
end

outputs.writedir = writedir_root;
outputs.str = addFolder2;

antibodies = params.general.ANTIBODY_IDS;
tissues = params.general.TISSUES;

datadir = [datadir_root '/' addFolder1 '/'];
writedir = [writedir_root '/' addFolder2 '/'];
outputs.writeData = [];

if (strcmp( method, 'parse') || strcmp( method, 'separate') || strcmp( method, 'featcalc'))
    conditions = {'normal'};
    if strcmp(method, 'separate')&& strcmp(umethod,'nmf')
        conditions = {'normal'};
    end
    if strcmp( method, 'featcalc')&& strcmp( feattype, 'SLFs')
        conditions = {'normal'};
    end
    if strcmp( method, 'featcalc')&& strcmp( feattype, 'SLFs_LBPs_CL')
        conditions = {'normal'};
    end
        
    counter = 0;
    for i1=1:length(antibodies)
        pathAntiID = [datadir '/' antibodies{i1}];
        writeAntiID = [writedir '/' antibodies{i1}];

        for i2=1:length(conditions)
            pathCondition = [pathAntiID '/' conditions{i2}];
            writeCondition = [writeAntiID '/' conditions{i2}];

            for i3=1:length(tissues)
                pathTissue = [pathCondition '/' tissues{i3}];
                dirData = dir([pathTissue '/*' readtail]);
                writeTissue = [writeCondition '/' tissues{i3}];

                for i4=1:length(dirData)
                    counter = counter+1;
                    outputs.pathData{counter} = [pathTissue '/' dirData(i4).name];
                    outputs.writeData{counter} = [writeTissue '/' dirData(i4).name(1:end-3) writetail];

                    outputs.writedir1{counter} = writedir;
                    outputs.writedirChild1{counter} = antibodies{i1};
                    outputs.writedir2{counter} = writeAntiID;
                    outputs.writedirChild2{counter} = conditions{i2};
                    outputs.writedir3{counter} = writeCondition;
                    outputs.writedirChild3{counter} = tissues{i3};
                end
            end
        end
    end
end

% Classification uses different structure since classifiers are trained on multiple classes

if (strcmp( method, 'classification'))
    conditions = {'normal'};
    for i1=1:length(classes)
        counter = 0;
        pathAntiID = [datadir '/' antibodies{i1}];

        for i2=1:length(conditions)
            pathCondition = [pathAntiID '/' conditions{i2}];

            for i3=1:length(tissues)
                pathTissue = [pathCondition '/' tissues{i3}];
                dirData = dir(pathTissue);

                for i4=3:length(dirData)
                    counter = counter+1;
                    outputs.pathData{i1}{counter} = [pathTissue '/' dirData(i4).name];
                    outputs.statsData{i1}{counter} = ['data/dataset/' antibodies{i1} '/' conditions{i2} '/' tissues{i3} '/' dirData(i4).name(1:end-3) 'txt'];
                    outputs.antiID{i1}{counter} = antibodies{i1};
                    outputs.tissueLabels{i1}(counter) = i3;
                    
                    cnum=cellfun('length',classes);
                        if cnum(i1)==1
                            outputs.dataclass{i1}{counter}=class_number(classes{1,i1});
                        else
                            if cnum(i1)==2
                                outputs.dataclass{i1}{counter}(1,1)=class_number(classes{1,i1}(1,1));
                                outputs.dataclass{i1}{counter}(1,2)=class_number(classes{1,i1}(1,2));
                            else
                               if cnum(i1)==3
                                outputs.dataclass{i1}{counter}(1,1)=class_number(classes{1,i1}(1,1));
                                outputs.dataclass{i1}{counter}(1,2)=class_number(classes{1,i1}(1,2));
                                outputs.dataclass{i1}{counter}(1,3)=class_number(classes{1,i1}(1,3));
                               else
                                error( 'please input the correct class.');
                               end
                            end
                        end                                
                 end
            end
        end
    end
    
    snum=0;
    for i=1:length(cnum)
        if cnum(i)==1
            snum=snum+1;
            s_protein(snum)=antibodies(i);    
        end
    end
    
    outputs.singleAntibody=s_protein;
    outputs.singleLabel=snum;
    outputs.classnumber=7;
    outputs.writeData{1}= [writedir '/classifier.mat'];
    outputs.writedir1{1} = [];
    outputs.writedirChild1{1}= [];
    outputs.writedir2{1} = [];
    outputs.writedirChild2{1} = [];
    outputs.writedir3{1}= [];
    outputs.writedirChild3{1} = [];
end


if (strcmp( method, 'prediction'))
    conditions = {'normal','cancer'};   
    counter = 0;
    for i1=1:length(antibodies)
        pathAntiID = [datadir '/' antibodies{i1}];
        writeAntiID = [writedir '/' antibodies{i1}];

        for i2=1:length(conditions)
            pathCondition = [pathAntiID '/' conditions{i2}];
            writeCondition = [writeAntiID '/' conditions{i2}];

            for i3=1:length(tissues)
                pathTissue = [pathCondition '/' tissues{i3}];
                dirData = dir([pathTissue '/*' readtail]);
                writeTissue = [writeCondition '/' tissues{i3}];
                outputs.pathClassifier = [classifierdir '/' cmethod '/' addFolder1 '/classifier.mat'];
                writeCmethod = [writeTissue '/' cmethod];  
  
                  for i4=1:length(dirData)
                    counter = counter+1;
                    outputs.pathData{counter} = [pathTissue '/' dirData(i4).name];
                    outputs.writeData{counter} = [writeCmethod '/' dirData(i4).name(1:end-3) writetail];

                    outputs.writedir1{counter} = writedir;
                    outputs.writedirChild1{counter} = antibodies{i1};
                    outputs.writedir2{counter} = writeAntiID;
                    outputs.writedirChild2{counter} = conditions{i2};
                    outputs.writedir3{counter} = writeCondition;
                    outputs.writedirChild3{counter} = tissues{i3};
                    outputs.writedir4{counter} = writeTissue;
                    outputs.writedirChild4{counter} = cmethod;
                 end
            end
        end
    end
end

if (strcmp( method, 'results'))          
  conditions = {'normal'};      
  dbs = {'db1','db2','db3','db4','db5','db6','db7','db8','db9','db10'};
  classifyMethod = {'CC','BR'};
  writeresult = 'predict_result.mat';
  
  counter1=0;
  for i1=1:length(dbs)
    normalPathDb= [datadir_root '/lin_' dbs{i1}];
    counter1=counter1+1;
    counter2=0;
    
    for i2=1:length(classifyMethod)
        counter2=counter2+1;
        counter3=0;
        
      for i3=1:length(antibodies)
        normalPathAntiID = [normalPathDb '/' antibodies{i3}];

         for i4=1:length(conditions)
            normalPathCondition = [normalPathAntiID '/' conditions{i4}];

             for i5=1:length(tissues) 
                normalPathTissue = [normalPathCondition '/' tissues{i5}];
                normalPathClassifymethod=[normalPathTissue '/' classifyMethod{i2}];
                normalDirData = dir( [ normalPathClassifymethod '/*.mat' ] ); 
                
                  for i6=1:length(normalDirData)
                    counter3=counter3+1;
                    outputs.normalPath{counter1}{counter2}{counter3}= [normalPathClassifymethod '/' normalDirData(i6).name];
                  end
                end
            end
        end
     end
  end
  
  counter1 = 0;
  conditions = {'normal','cancer'}; 
  tissuesDetect = {{'Breast','Breast cancer'},...
             {'Lung','Lung cancer'},...
             {'Pancreas','Pancreatic cancer'},...
             {'Prostate','Prostate cancer'},...
             {'Kidney','Renal cancer'},...
             {'Thyroid_gland','Thyroid cancer'},...
             {'Urinary_bladder','Urothelial cancer'}};
   for i1 = 1:length(antibodies)
      writeAntiID = [writedir '/' antibodies{i1}];
      
      for i2 = 1:length(tissuesDetect)
          counter1 = counter1+1;
          outputs.writeData{counter1} = [writeAntiID '/' tissuesDetect{counter1}{2} '/' writeresult];
          counter3 = 0;
          
          for i3 = 1:length(conditions)
              pathTissue = [antibodies{i1} '/' conditions{i3} '/' tissuesDetect{i2}{i3}];
              counter3 = counter3+1;
              counter2=0;
              
              for i4 = 1:length(dbs)
                  pathFmethod = [datadir_root '/lin_' dbs{i4} '/' pathTissue];
                  
                  for i5 = 1:length(classifyMethod)
                      pathClassifymethod = [pathFmethod '/' classifyMethod{i5}];
                      dirdata = dir( [ pathClassifymethod '/*.mat' ] );
                      
                      for i6 = 1:length(dirdata)
                          counter2 = counter2+1;
                          outputs.pathData{counter1}{counter3}{counter2} = [pathClassifymethod '/' dirdata(i6).name];
                          
                          outputs.writedir1{counter1} = writedir;
                          outputs.writedirChild1{counter1} = antibodies{i1};
                          outputs.writedir2{counter1} = writeAntiID;
                          outputs.writedirChild2{counter1} = tissuesDetect{i2}{2};
                          outputs.writedir3{counter1} = writeAntiID; 
                          outputs.writedirChild3{counter1} = tissuesDetect{i2}{2};
                      end
                  end
              end
          end
      end
  end
end

return



