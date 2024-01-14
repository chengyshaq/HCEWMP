%% Get the positive label set of the current node, data with these labels
function [pos_label_set] = get_pos_label_MLNP(tree, cur_node)
cur_ancestor = tree_Ancestor(tree, cur_node);
cur_descendants = tree_Descendant(tree, cur_node);  
leaf_nodes_set = tree_LeafNode(tree); 
if (isempty(cur_ancestor))  
    ind = find(tree(:,1) == cur_node);
    for t=1:length(ind')
        root_children_node = ind(t);
        all_pos_nodes = tree_Descendant(tree, root_children_node);
        index_root_ret = 1;
        for i = 1:length(all_pos_nodes)
            isLeaf = find(all_pos_nodes(i) == leaf_nodes_set);
            if (~isempty(isLeaf))
                pos_label_set(index_root_ret) = all_pos_nodes(i); 
                index_root_ret = index_root_ret + 1;
            end
        end
    end
elseif (isempty(cur_descendants))   % the current node is a leaf node  当前节点是叶节点
    pos_label_set = cur_node; 
else  % the current node is a internal node  当前节点是内部节点
    all_pos_nodes = tree_Descendant(tree, cur_node);
    index_internal_ret = 1;
    for i = 1:length(all_pos_nodes)
        isLeaf = find(all_pos_nodes(i) == leaf_nodes_set);
        if (~isempty(isLeaf))
            pos_label_set(index_internal_ret) = all_pos_nodes(i);
            index_internal_ret = index_internal_ret + 1;%获得相应节点
        end
    end
end
end