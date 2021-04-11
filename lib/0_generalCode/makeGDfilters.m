function F = makeGDfilters(sigmaSet)
    for s=1:length(sigmaSet)
            sigma = sigmaSet(s);
            Wx =  floor(3*sigma);
            x = [-Wx:Wx];
            [xx,yy] = meshgrid(x,x);
            g0 = -exp(-(xx.^2+yy.^2)/(2*sigma^2))/(2*pi*sigma^4);
            
            F{s}.Gx = xx.*g0;
            F{s}.Gy = yy.*g0;
            F{s}.Gxx = (1-xx.^2/sigma^2).*g0;  
            F{s}.Gxy =  -(xx.*yy/sigma^2).*g0; 
            F{s}.Gyy = (1-yy.^2/sigma^2).*g0; 
    end
    
