% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function AUC = showMyROC(ROCraw, currClassifierName, CatNames, saveDir)

    % create figure and show ROC curve
    ax = figure();
    plotroc(ROCraw.true,ROCraw.predicted');
    axisdata = get(gca, 'userdata');
    legend(axisdata.lines, 'Cytopl', 'ER', 'Gol', 'Lyso', 'Mito', ...
        'Nucl', 'Vesi','Location','northeast')
    title(strrep(currClassifierName,'_',': '));
    
    %legend(CatNames); % problem: does not conserve line colors
    
    % compute AUC
    [tpr,fpr] = roc(ROCraw.true,ROCraw.predicted');
    for i=1:numel(tpr)
        %figure(), plot(fpr{i},tpr{i})
        AUC{i} = trapz(fpr{i},tpr{i});
    end  
    
    % save figure as PNG
    print(ax,'-dpng','-r600',[saveDir,'Sup400-SVMLNRF','-ROC.png']);
    
end
