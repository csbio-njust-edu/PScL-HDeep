The source code is for the paper:
LETRIST: Locally Encoded Transform Feature Histogram for Rotation-Invariant Texture Classification, 
by Tiecheng Song, Hongliang Li, Fanman Meng, Qingbo Wu, and Jianfei Cai, 
IEEE TCSVT, 2017,
tggwin@gmail.com
version 1.0 (2017.2)

=====================================
        How to use the code
=====================================
Running Environment: Windows 7, Matlab R2013a

-----------------------------------------------------
Reproduce the experimental results for Outex_TC_00010
1. Download the Outex_TC_00010 dataset from http://www.outex.oulu.fi/index.php?page=classification
   In the downloaded file 'Outex_TC_00010', the sub-file 'images' includes all the training and test images, and the sub-file '000' incudes the documents specifying the split of the training and test sets. 
2. Run demo_TC10.m to reproduce the reported results.
   --makeGDfilters.m: generate Gaussian derivative filters Gx, Gy, Gxx, Gxy, and Gyy.
   --K, C, Ls and Lr: the parameters involved in Eqns. (14)-(16).
   --getFeatsCodes.m: generate the LETRIST feature descriptor.
      ----atan_vq.m: quantize the features {s, r}.
      ----gen_binary_codes.m: quantize the features {g, d}.
      ----H1, H2, and H3: histograms for LETRIST_ASC1, LETRIST_ASC2 and LETRIST_FSC.
   --ReadOutexTxt.m: obtain image IDs and class IDs for the Outex dataset.
   --cal_AP.m: texture classification using the nearest-neighborhood (NN) classifier.
      ----distMATChiSquare.m: compute the chi-square distance between the training and test samples.
      ----ClassifyOnNN.m: compute the classification accuracy using the NN classifier.

-----------------------------------------------------
Reproduce the experimental results for Outex_TC_00012
1. Download the Outex_TC_00012 dataset from http://www.outex.oulu.fi/index.php?page=classification
   In the downloaded file 'Outex_TC_00012', the sub-file 'images' includes all the training and test images for TC12t and TC12h. The sub-file '000' incudes the documents specifying the split of the training and test sets for TC12t; the sub-file '001' incudes the documents specifying the split of the training and test sets for TC12h. 
2. Run demo_TC12t.m and demo_TC12h.m to reproduce the reported results.

--------------------------------------------
Reproduce the experimental results for CURET
1. Download the CURET dataset from http://www.robots.ox.ac.uk/~vgg/research/texclass/index.html
2. Store 61 classes of texture images (each class corresponds to one sub-file, e.g., 'sample01' and 'sample02') in a root file 'CURET'. 
3. Run demo_CURET.m to reproduce the reported results.
   --get_im_label.m: generate the image labels.
   --calculate_LETRIST_features: extract the LETRIST descriptors of all images and save them under one single feature file.
   --get_feature_path.m: get the storage path of each image feature.
   --load_feature.m: load all image features and save them in a matrix.
   --the code in the loop 'for i = 1: trail': perform N=trail random splits of the training and test sets and compute the classification accuracy with each split. 
   --AP=mean(cp_avg): compute the average accuracy over N=trail random splits.

