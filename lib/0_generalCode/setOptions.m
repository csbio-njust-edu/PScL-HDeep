function options = setOptions(inputs)
% OPTIONS = SETOPTIONS( INPUTS)


if ~exist( 'inputs','var')
	inputs = [];
end

% 0. Set inputs
inputs = setInputs( inputs);

% 1. Setting general parameters
options.general = setGeneral( inputs.general);

% 2. Setting unmixing parameters
options.separate = setUnmix(inputs.separate);

% 3. Setting feature calculation parameters
options.featCalc = setFeatCalc( inputs.featCalc);

% 4. Classification parameters
% inputs.classify.FEATSET = options.featCalc.FEATSET;
%options.classify = setClassify( inputs.classify);

% 5. Prediction parametersy
% inputs.predict = options.classify;
%options.predict = setPrediction(inputs.predict);

% 6. Results parametersy
% inputs.getResults = options.setPrediction;
%options.getResults = setResults( inputs.getResults);

return


function options = setInputs(inputs)
options.general = [];
options.separate = [];
options.featCalc = [];
options.classify = [];
options.predict = [];
options.getResults = [];

checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch
    end
end

return


function options = setGeneral(inputs)
options.ANTIBODY_IDS = {'2384','4125','29804','2321','3901',...
                '2645','7912','35593','11929','35866','6964',...
                '1467','41690','4480','26533','53891','54422',...
                '28136','43912','17964','23099','19025','22012', ...
               };


% 
options.CLASSLABELS = {'Cytoplasm','Cytoplasm','Cytoplasm','Cytoplasm',...
                       'ER','ER','ER',...
                       'Golgi_apparatus','Golgi_apparatus','Golgi_apparatus',...
                       'Lysosome','Lysosome',...
                       'Mitochondria','Mitochondria','Mitochondria',...
                       'Nucleus','Nucleus','Nucleus','Nucleus',...
                       'Vesicles','Vesicles','Vesicles','Vesicles'};
%      struct2cell(struct('A','Cytoplasm','B','Nucleus')),...
%      struct2cell(struct('A','Cytoplasm','B','Nucleus')),...
%     struct2cell(struct('A','ER','B','Vesicles')),... 
%     struct2cell(struct('A','Lysosome','B','Vesicles')),...
%     struct2cell(struct('A','Cytoplasm','B','Nucleus')),...  
%     struct2cell(struct('A','Cytoplasm','B','Mitochondria')),...
%     struct2cell(struct('A','Golgi_apparatus','B','Vesicles','C','Lysosome'))};
options.DATAROOT = 'data/dataset/';
options.WRITEROOT = './data/';
% options.TISSUES = {...
% 	'Cervix_uterine','Epididymis','Fallopian_tube','Ovary','Prostate','Seminal_vesicle','Testis','Uterus','Vagina'};
options.TISSUES = {...
	'Breast cancer','Lung cancer','Pancreatic cancer','Prostate cancer',...
    'Renal cancer','Thyroid cancer','Urothelial cancer',...
	...
	'Adrenal_gland','Anal_skin','Appendix','Bone_marrow','Breast','Bronchus','Caudate',...
	'Cerebellum','Cerebral_cortex','Cervix__uterine','Colon','Duodenum',...
	'Endometrium_1','Endometrium_2','Epididymis','Esophagus','Fallopian_tube','Gallbladder',...
	'Heart_muscle','Hippocampus','Kidney','Liver','Lung','Lymph_node',...
	'Nasopharynx','Oral_mucosa','Ovary','Pancreas','Parathyroid_gland',...
	'Placenta','Prostate','Rectum','Salivary_gland','Seminal_vesicle',...
	'Skeletal_muscle','Skin','Small_intestine','Smooth_muscle','Soft_tissue_1','Soft_tissue_2',...
	'Spleen','Stomach_1','Stomach_2','Testis','Thyroid_gland','Tonsil','Urinary_bladder',...
	'Vagina'};
checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return


function options = setUnmix( inputs)
options.UMETHOD = 'lin';
options.ITER = 5000;
options.INIT = 'truncated';
options.RSEED = 13;
options.RANK = 2;
options.STOPCONN = 40;
options.VERBOSE = 1;

bf = 'lib/2_separationCode/Wbasis.mat';
load( bf);
options.W = W;

checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return


function options = setFeatCalc( inputs)
options.FEATSET = 'db5';
options.NLEVELS = 10;
options.FEATTYPE = 'SLFs';
options.sigmaSet = [1 2 4];
sigmaSet = [1 2 4];
options.F = makeGDfilters(sigmaSet);
options.snr = 0; % here "0" only denotes "No noise"
options.K = 2;
options.C = 1;
options.Ls = 3;
options.Lr = 5;
options.M = getMap();
if ~isempty(inputs)
    if strcmp(inputs.FEATTYPE, 'CNN')
       load('imagenet-vgg-verydeep-19.mat') ;
       net.layers=layers;
       net.normalization=meta.normalization;
       options.net = net; 
    end
end

checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return


function options = setClassify( inputs)
options.CMETHOD = 'BR';

checker.options = fieldnames(options);
if exist('inputs','var')
    try
        checker.inputs = fieldnames(inputs);
        for i=1:length(checker.inputs)
            checker.type = checker.inputs{i};
            checker.value = getfield( inputs,checker.inputs{i});
            options = setfield( options, checker.type, checker.value);
        end
    catch

    end
end

return

function options = setPrediction( inputs)
    options.CLASS = 7;

    checker.options = fieldnames(options);
    if exist('inputs','var')
        try
            checker.inputs = fieldnames(inputs);
            for i=1:length(checker.inputs)
                checker.type = checker.inputs{i};
                checker.value = getfield( inputs,checker.inputs{i});
                options = setfield( options, checker.type, checker.value);
            end
        catch

        end
    end
return
   

function options = setResults( inputs)
    options.T = 0.8897; 
    checker.options = fieldnames(options);
    if exist('inputs','var')
        try
            checker.inputs = fieldnames(inputs);
            for i=1:length(checker.inputs)
                checker.type = checker.inputs{i};
                checker.value = getfield( inputs,checker.inputs{i});
                options = setfield( options, checker.type, checker.value);
            end
        catch

        end
    end
return

