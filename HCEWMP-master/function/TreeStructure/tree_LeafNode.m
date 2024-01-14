function [ leafNode ] = tree_LeafNode( tree )
    treeParent=tree(:,1)';
    lengthTree = length(treeParent); 
    middleNode = [];
    while length(treeParent)~=0  
        middleNode=[middleNode; treeParent(1)]; 
        label=find(treeParent==treeParent(1));    
        treeParent(label)=[];   
    end
    leafNode = 1:lengthTree;
    
    leafNode = leafNode(ismember(leafNode,middleNode)==0); 
end

