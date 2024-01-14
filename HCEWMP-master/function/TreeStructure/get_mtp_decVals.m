function mtp_dec_vals = get_mtp_decVals(dec_vals, tree)
% Get the accumulated multiplied posterior probabilities for each sample
% at each node
mtp_dec_vals = {};
root = find(tree(:,1)==0);
for i = 1:size(tree,1)
    if (i == root)
        mtp_dec_vals{i} = {};
    else
        cur_node = i;
        par_node = tree(cur_node,1);
        mtp_dec_vals{i} = ones(size(dec_vals{par_node}{2},1),1);
        while (cur_node ~= root)
            par_node = tree(cur_node,1);
            ind = find(dec_vals{par_node}{1} == cur_node);
            mtp_res = dec_vals{par_node}{2}(:,ind);
            mtp_dec_vals{i} = bsxfun(@times, mtp_dec_vals{i}, mtp_res);
            cur_node = par_node;
        end
    end
end
root_children = get_children_set(tree, root);
mtp_dec_vals{root} = ones(size(mtp_dec_vals{root_children(1)},1),1);
for l = 1:size(tree,1)
   if(isempty(mtp_dec_vals{l})) 
        mtp_dec_vals{l} = zeros(size(mtp_dec_vals{root_children(1)},1),1);
   end
end
end