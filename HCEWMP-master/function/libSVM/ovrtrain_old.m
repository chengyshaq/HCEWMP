function [model] = ovrtrain_individual_node(y, x, C, modelLearn, B, yt, xt)

labelSet = unique(y);
labelSet(labelSet==0) = [];

%% Remove -1
[x1 y1] = find(labelSet == -1);
x1b = unique(x1);
labelSet(x1b, :) = [];

labelSetSize = length(labelSet);
models = cell(labelSetSize,1);   
decv= zeros(size(yt, 1), 1);

for i=1:labelSetSize
    pLabel = (y == labelSet(i));
    pLabelT = (yt == labelSet(i));
    prevacc = 0; 
    testModels = cell(1, 1);
    for regTest = 1:length(C)
        cmd = ['-c ', num2str(C(regTest)), ' -s ', num2str(modelLearn), ' -B ', num2str(B)];       
        models{i} = train(double(sum(pLabel, 2)), x, cmd);
        [l,a,d] = predict(double(sum(pLabelT, 2)), xt, models{i});
        decv(:, 1) = d * (2 * models{i}.Label(1) - 1);
        decv(:, 1) = decv(:, 1) >0;

        acc = sum(decv == double(sum(pLabelT, 2)))/length(pLabelT);
        if(acc > prevacc)
            prevacc = acc;
            testModels = models{i};
        end
    end
    models{i} = testModels;
end

model = struct('models', {models}, 'labelSet', labelSet);
