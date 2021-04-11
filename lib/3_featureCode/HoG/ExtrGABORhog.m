function FeatA=GABORminutiae(A,P1,P2,ND,NS,num_cells_x,num_cells_y)

if nargin==3
    ND=4;
    NS=4;
    num_cells_x=5;
    num_cells_y=6;
end

t=1;
FeatA=[];
for disk=0:1:ND-1
    for scala=1:NS
        dimFilter=size(A,1);
        % per la rotazione corrente si costruisce il filtro di Gabor corrispondente
        gabor=gabor2d_sub(disk,P1,P2,1*scala,1*scala,size(A,1));
        [NR NC]=size(A);
        AA=real(ifft2(fft2(single(A),NR+dimFilter-1,NC+dimFilter-1).*fft2(gabor,NR+dimFilter-1,NC+dimFilter-1)));
        R=floor(dimFilter/2);
        C=floor(dimFilter/2);
        % si estrae la parte di interesse della convoluzione di dimensioni (dimCrop+1)*(dimCrop+1)
        AA=single(AA(R+1:R+NR,C+1:C+NC));
        AA=NormConnie(AA);
        FeatA=[FeatA EstraiHog(AA, [],num_cells_x,num_cells_y)];
    end
end

