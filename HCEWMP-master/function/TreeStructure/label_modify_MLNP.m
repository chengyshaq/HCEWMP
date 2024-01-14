%% Find the leaf nodes of the current node (if has), and assign the labels of these leaf nodes 
function[label_mod] = label_modify_MLNP(labelSet, cur_node, tree)
label_mod = labelSet;
children_set = get_children_set(tree, cur_node);  
for c =1:length(children_set)
    pos_label_set = get_pos_label_MLNP(tree, children_set(c));  
    for tl = 1:length(label_mod)
        if (ismember(label_mod(tl), pos_label_set) ~= 0)
            label_mod(tl) = children_set(c);
        end
    end
end
end