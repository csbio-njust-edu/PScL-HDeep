% Calculate chi-square distance between feature histograms

function dis=lbp_dis2(X1,X2)
    [dim1 dim2] = size(X1);
    EPS = eps * ones(dim1,dim2);
    DIS = (X1 - X2).^2./(X1+X2+EPS);
    dis = sum(DIS(:));
end

