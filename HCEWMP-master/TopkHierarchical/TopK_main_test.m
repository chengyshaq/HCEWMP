%%
clear;
clc;
%% Load information of the dataset
dataSetCand = {'Bridges'};  %% 'F194','Car196','VOC','CLEF','Bridges','DD'
ds = 1;
    dataSet = dataSetCand{ds};
    dataSetTest = [dataSet '.mat'];
    dataTest = importdata(dataSetTest); %importdata
   
tic 
alpha=1;%    DD 0.28 3 30
numFolds = 10;
k =3; % Number of paths 1 <= k <= min(Number of batches).
trees=10;  %RF trees
way=1; %way=1 HCEWMP ,Others HCPWMP 
[accuracyMean,accuracyStd,F_LCAMean,FHMean,TIEMean,PredLabel,RealLabel] = Kflod_TopKClassifier( dataTest.data_array,numFolds,dataTest.tree,k,alpha,trees,way);

t = toc;
