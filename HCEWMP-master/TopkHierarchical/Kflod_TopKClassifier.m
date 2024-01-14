function [accuracyMean,accuracyStd,F_LCAMean,FHMean,TIEMean,PredLabel,RealLabel,MidnodeaccMean] = Kflod_TopKClassifier(varargin)
if(length(varargin) == 7)
    data = varargin{1};
    numFolds = varargin{2};
    tree = varargin{3};
    select_num = varargin{4};
    alpha= varargin{5};
    trees=varargin{6};
    way=varargin{7};
else
    if(length(varargin) == 8)
        data = [varargin{1},varargin{2}];
        numFolds = varargin{3};
        tree = varargin{4};
        select_num = varargin{5};
        alpha= varargin{6};
        trees=varargin{7};
        way=varargin{8};
    end
end
[M,N]=size(data);
accuracy_k = zeros(1,numFolds);
rand('seed',1);
indices = crossvalind('Kfold',data(1:M,N),numFolds);
for k = 1:numFolds
    testID = (indices == k);
    trainID = ~testID;
    test_data = data(testID,1:end-1);
    test_label = data(testID,end);
    train_data = data(trainID,:);
    train_label = data(trainID,end);
    train_num=tabulate(train_label);
    train_num=train_num(:,1:2);
    RealLabel{k} = test_label;
    
    %% Creat sub table
    [trainDataMod, trainLabelMod] = creatSubTable(train_data, tree);
    middlenode = tree_InternalNodes( tree );
    for i=1:length(middlenode)
        [m,~]=size(trainDataMod{middlenode(i)});
        train_num=vertcat(train_num, [middlenode(i),m]);
    end
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Train classifiers of all internal nodes
    numNodes = length(tree(:,1));
    for i = 1:numNodes
        if (~ismember(i, tree_LeafNode(tree)))
            [model{i}] = train(double(sparse(trainLabelMod{i})), sparse(sparse(trainDataMod{i})), '-c 2 -s 0 -B 1 -q ');
        end
    end
    %%           Prediction       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    predict_label = TopKPrediction(test_data, model, tree,train_data,select_num,train_num,alpha,trees,way) ;
    PredLabel{k} = predict_label;
    %%          Envaluation       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [PH(k), RH(k), FH(k)] = EvaHier_HierarchicalPrecisionAndRecall(test_label,predict_label,tree);
    [P_LCA(k),R_LCA(k),F_LCA(k)] = EvaHier_HierarchicalLCAPrecisionAndRecall(test_label,predict_label,tree);
    TIE(k) = EvaHier_TreeInducedError(test_label,predict_label,tree);
    accuracy_k(k) = EvaHier_HierarchicalAccuracy(test_label,predict_label, tree);
    nodeacc{k}=EvaHier_HierarchicalnodeAcc(test_label,predict_label,tree);
end
accuracyMean = mean(accuracy_k);
accuracyStd = std(accuracy_k);
[a,b]=size(nodeacc{k});
Midnodeacc = []; % 创建
for i = 1:b
    for j = 1:k
        temp = nodeacc{j}(i); % 临时存储 nodeacc{j}(i) 的值
        Midnodeacc(j) = temp; % 赋值给 Midnodeacc(j)
    end
    MidnodeaccMean(i) = sum(Midnodeacc) / k; % 计算平均值并赋给 MidnodeaccMean(i)
end

F_LCAMean = mean(F_LCA);
FHMean = mean(FH);
TIEMean = mean(TIE);

end

