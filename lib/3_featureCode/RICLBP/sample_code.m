clear;
clc;

%% init
M = getMap();
foo = @(img) [cvtRICLBP(img,1,2,M); cvtRICLBP(img,2,4,M); cvtRICLBP(img,4,8,M);];

input = 'sample.jpg'; 
img = imresize(im2double(rgb2gray(imread(input))),[100,100]);

figure;
imshow(img);

%% feature extraction

F1 = foo(img);
F1 = F1 / norm(F1);
c = zeros(360,1);

for i = 0:359
    F2 = foo(imrotate(img,i,'crop'));
    c(i+1) = F1'*F2/norm(F2);
end

%% vilualization
figure;
plot(0:359,c);
xlabel('Angle [deg]');
ylabel('Cosine Similarity');
xlim([0 360]);
ylim([0.9 1]);


