function handleData( data, params,features_all)
% PROCESSDATA( PROCPARMS, SIMUPARMS)

if ~exist( 'data','var')
    error( 'Please input processing parameters');
end
if ~exist( 'params','var')
    error( 'Please input simulation parameters');
end

if isempty(data.writeData)
    return
end

method = data.method;
[success wrnmsg wrnmsgID] = mkdir(data.writedir,data.str);

for i2=1:length(data.writeData)

    [success wrnmsg wrnmsgID] = mkdir(data.writedir1{i2}, data.writedirChild1{i2});
    [success wrnmsg wrnmsgID] = mkdir(data.writedir2{i2}, data.writedirChild2{i2});
    [success wrnmsg wrnmsgID] = mkdir(data.writedir3{i2}, data.writedirChild3{i2});

    switch method
        case 'separate'
            processImage( data.pathData{i2}, data.writeData{i2}, params.separate);
        case 'featcalc'
            calculateFeatures( data.pathData{i2}, data.writeData{i2}, params.featCalc.FEATSET, params.featCalc.NLEVELS, params);
        case 'classification'
            classifyPatterns(data,params.classify.CMETHOD,params.featCalc.FEATSET,params.featCalc.FEATTYPE,params.separate.UMETHOD);
        case 'prediction'
            [success wrnmsg wrnmsgID] = mkdir(data.writedir4{i2}, data.writedirChild4{i2});
            predict( data.pathData{i2}, data.writeData{i2}, data.pathClassifier,params.classify.CMETHOD,params.predict.CLASS);
        case 'results'
            results( data.pathData{i2},data.writeData{i2},params.predict.CLASS,params.getResults.T);
        case 'parse'
            imageStats( data.pathData{i2}, data.writeData{i2});
        otherwise
            error( 'not supported yet');
    end
end
