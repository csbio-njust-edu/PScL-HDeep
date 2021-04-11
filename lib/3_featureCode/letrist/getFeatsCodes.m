function H = getFeatsCodes(F, sigmaSet, I, Ls, Lr, K, Coef)
        
    for s =1:length(F) % multiple scales
       % filtering
        sij = sigmaSet(s); 
        Ix = sij*imfilter(I, F{s}.Gx, 'same', 'replicate'); 
        Iy = sij*imfilter(I, F{s}.Gy, 'same', 'replicate');        
        Ixx = sij^2*imfilter(I, F{s}.Gxx, 'same', 'replicate');  
        Ixy = sij^2*imfilter(I, F{s}.Gxy, 'same', 'replicate');  
        Iyy = sij^2*imfilter(I, F{s}.Gyy, 'same', 'replicate');  

        g = sqrt(Ix.*Ix + Iy.*Iy); 
        d =  sqrt( (Ixx-Iyy).^2+ 4*Ixy.^2 ); 

       % shpae index codes
        SI = 0.5-1/pi*atan((-Ixx-Iyy)./sqrt((Ixx-Iyy).^2+ 4*Ixy.^2)); % SI:[0,1]  
        SI_label= atan_vq(SI, Ls);   
        SI_code(:,s) = SI_label(:);        
       
        C(:,s) =  g(:); 
        C(:,s + 1*length(F)) =  d(:);
    end
   %% ==================== other quantization codes ================ 
    % H1 H2
    C_code = gen_binary_codes(C, K);

    BINsi=Ls;         
    Wsi=BINsi.^(1:-1:0); % weights
    BINc =2;    
    Wc=BINc.^(3:-1:0);   
    
    II=[1 2];JJ=[1 2 4 5]; 
    SIcode = SI_code(:,II);
    Ccode = C_code(:,JJ);
    featW = SIcode*Wsi' + (Ccode*Wc')*BINsi^2;  
    H1=hist(featW, 0:(BINsi^2*BINc^4-1));   
    
    II=II+1; JJ=JJ+1;  
    SIcode = SI_code(:,II);
    Ccode = C_code(:,JJ);
    featW = SIcode*Wsi' + (Ccode*Wc')*BINsi^2;  
    H2=hist(featW, 0:(BINsi^2*BINc^4-1));  
     
    % H3
    G2=C(:,1:3);
    D2=C(:,4:6); % d
    r=2/pi*atan(Coef*D2./G2); 

    R_code = atan_vq(r, Lr);
    W=Lr.^(2:-1:0);
    featW = R_code*W';
    H3 = hist(featW, 0:Lr^3-1);  

    H=[H1  H2  H3];

    
