%% Return to ancestor node
function [ A ] = tree_Ancestor( varargin)

   tree = varargin{1};
   tree=tree(:,1);
   i = varargin{2};
   if(length(varargin)==3)     
        self = varargin{3};
    else
        self = 0;
    end
    
A = [];
if (self)
    A(1) = i;
end

node = tree(i);
while (node~=0)  
    A(end+1) = node;
    node = tree(node);
end

end

