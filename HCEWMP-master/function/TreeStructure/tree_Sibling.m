function [ S ] = tree_Sibling( tree,i )


[r,c] = find(tree(:,1)==tree(i));
S = r;
%%
S(find(S==i)) = [];
%%
end

