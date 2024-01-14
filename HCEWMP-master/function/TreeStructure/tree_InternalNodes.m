
function [ middleNode ] = tree_InternalNodes( tree )
treeParent=tree(:,1)';
index=find(treeParent==0);
Allnonleaf=unique(treeParent);
middleNode=setdiff(Allnonleaf,0);
middleNode(find(middleNode==index))=[];
middleNode=middleNode';


