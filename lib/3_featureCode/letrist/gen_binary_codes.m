function Ccode = gen_binary_codes(C, K)

    U=mean(C,1);
    Ccode =zeros(size(C));
    Ccode( bsxfun(@gt, C, K*U) )=1;
    
