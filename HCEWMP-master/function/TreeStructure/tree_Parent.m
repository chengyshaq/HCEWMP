function [ A ] = tree_Parent( varargin)
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
 A(end+1) = node;
end

