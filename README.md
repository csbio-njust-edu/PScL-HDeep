# PSL-Prediction
The code is the implementation of our method described in the paper “Matee Ullah, Fazal Hadi, Jian Xu, Jiangning Song, Dong-Jun Yu, Image-based prediction of protein subcellular location in human tissue using ensemble learning of optimized handcrafted and deep features with 2L feature selection”.
## (I)	data
There are two datasets:
### (1)	Train dataset
The benchmark training dataset contains a total of 2,876 immunohistochemistry (IHC) images of 7 different protein subcellular locations selected from the human protein atlas (HPA) database.
### (2)	Independent dataset
The independent dataset contains 107 IHC images of five different proteins selected from HPA. <br />
Please download the datasets from "https://drive.google.com/drive/folders/1ExTtZ3bWlmHiBpUsKAvuf9cQ2ZeoF9Qm?usp=sharing" and copy it to "data" folder.
## (II)	lib
lib folder contains all the code used in this study.<br />
Please visit "http://www.vlfeat.org/matconvnet" to download the matconvnet toolbox and dependencies and copy it to “\lib\3_featureCode\”. <br />
Please visit "http://www.csie.ntu.edu.tw/~cjlin/libsvm/" to download the LIBSVM toolbox for SVM classifier and copy it to “\lib\5_classifier\”.
## (III)	Biomage_Feature_Extraction.m
Biomage_Feature_Extraction.m is the matlab file for extracting <br />
(1)	DNA distribution features <br />
(2)	Haralick texture features <br />
(3)	Local binary pattern <br />
(4)	Completed local binary patterns <br />
(5)	Rotation invariant co-occurrence of adjacent LBP <br />
(6)	Adaptive hybrid pattern <br />
(7)	Histogram of oriented gradients <br />
(8)	Locally encoded transform feature histogram and <br /> 
(9)	deep learned features
## (IV)	CrossValidation.m
crossValidation.m is the matlab file that divides the training dataset randomly into 10 equal sub parts.
## (V)	Feature_Selection_SDA.m
Feature_Selection_SDA.m is the matlab file to individually select the optimal features from each extracted feature set using stepwise discriminant analysis (SDA).
## (VI)	Feature_Selection_SVM_RFE.m
feature_Selection_SVM_RFE.m is the matlab file that first integrate all the optimal feature sets obtained via SDA and then rank the integrated feature set using the SVM-RFE+CBR. The result is the Sup-400 feature set that contain the top 400 ranked features.
## (VII)	Classification_linSVM.m
Classification_linSVM.m is the matlab file for the implementation of SVM-LNR classifier.
## (VIII)	Classification_RBFSVM.m
Classification_RBFSVM is the matlab file for the implementation of SVM-RBF classifier.
## (IX)	Contact
If you are interested in our work or if you have any suggestions and questions about our research work, please contact us. E-mail: khan_bcs2010@hotmail.com.
