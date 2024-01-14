function [model] = ovrtrain(y, x, cmd)

labelSet = unique(y);

%% Remove -1
[x1 y1] = find(labelSet == -1);
x1b = unique(x1);
labelSet(x1b, :) = [];
                    
labelSetSize = length(labelSet);
models = cell(labelSetSize,1);

for i=1:labelSetSize
    models{i} = train(double(y == labelSet(i)), x, cmd);
end

model = struct('models', {models}, 'labelSet', labelSet);
