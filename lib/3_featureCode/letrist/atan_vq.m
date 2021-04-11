function SI_label = atan_vq(SI, flg)
    
SI_label=zeros(size(SI)); % SI:[0, 1]
if flg==7
    SI_label(SI<1/7) = 0;
    SI_label(1/7<=SI & SI<2/7) = 1;
    SI_label(2/7<=SI & SI<3/7) = 2;  
    SI_label(3/7<=SI & SI<4/7) = 3;  
    SI_label(4/7<=SI & SI<5/7) = 4; 
    SI_label(5/7<=SI & SI<6/7) = 5;     
    SI_label(SI>=6/7) = 6;
elseif flg==6
    SI_label(SI<1/6) = 0;
    SI_label(1/6<=SI & SI<2/6) = 1;
    SI_label(2/6<=SI & SI<3/6) = 2;  
    SI_label(3/6<=SI & SI<4/6) = 3;  
    SI_label(4/6<=SI & SI<5/6) = 4;  
    SI_label(SI>=5/6) = 5;
elseif flg==5
    SI_label(SI<1/5) = 0;
    SI_label(1/5<=SI & SI<2/5) = 1;
    SI_label(2/5<=SI & SI<3/5) = 2;  
    SI_label(3/5<=SI & SI<4/5) = 3;  
    SI_label(SI>=4/5) = 4;
elseif flg==4
    SI_label(SI<1/4) = 0;
    SI_label(1/4<=SI & SI<2/4) = 1;
    SI_label(2/4<=SI & SI<3/4) = 2;  
    SI_label(SI>=3/4) = 3;  
elseif flg==3
    SI_label(SI<1/3) = 0;
    SI_label(1/3<=SI & SI<2/3) = 1;
    SI_label(SI>=2/3) = 2;  
elseif flg==2
    SI_label(SI<0.5) =0;
    SI_label(SI>=0.5) =1;
elseif flg>7
    error('error: no such quantization level!');
end