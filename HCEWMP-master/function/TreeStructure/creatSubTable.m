%% Top-down prediction
% Written by Yu Wang
% Modified by Hong Zhao
% 2017-4-11
%% Molecular table  
function [DataMod,LabelMod]=creatSubTable(dataset, tree)
Data = dataset(:,1:end-1);
Label =  dataset(:,end); 
[numTrain,~] = size(dataset);
numNodes = length(tree(:,1));
for i = 1:numNodes  
    if (~ismember(i, tree_LeafNode(tree))) 
        cur_descendants = tree_Descendant(tree, i);  
        ind_d = 1;  
        id = [];       
        for n = 1:numTrain
            if (ismember(Label(n), cur_descendants) ~= 0)  
                id(ind_d) =  n;
                ind_d = ind_d +1;
            end
        end
        Label_Uni_Sel = Label(id,:);
        DataSel = Data(id,:);     
        numTrainSel = size(Label_Uni_Sel,1); 
        LabelUniSelMod = label_modify_MLNP(Label_Uni_Sel, i, tree);
        ind_tdm = 1;
        index = [];    
        children_set = get_children_set(tree, i);
        for ns = 1:numTrainSel 
            if (ismember(LabelUniSelMod(ns), children_set) ~= 0)
                index(ind_tdm) =  ns ;
                ind_tdm = ind_tdm +1;
            end
        end
        DataMod{i} = DataSel(index, :);  
        LabelMod{i} = LabelUniSelMod(index, :);
    end
end

end