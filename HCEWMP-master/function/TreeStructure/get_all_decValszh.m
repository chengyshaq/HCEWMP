function [decVal_label,decVal_dv,testLabel_mod] = get_all_decValszh(input_data, inputLabel, model, tree)
%decVal = {};
for i = 1:size(tree, 1)
     if (~ismember(i, tree_LeafNode(tree))) 
    %cur_des = tree_Descendant(tree,i);
 
        %% Prediction
        testLabel_mod = label_modify_MLNP(inputLabel, i, tree);
        [pre_label,acc,d_v] = predict(double(testLabel_mod),  sparse(input_data),  model{i}, '-b 1 -q');
        decVal_label{i} = model{i}.Label;
        decVal_dv{i} = d_v;
    end
end
end