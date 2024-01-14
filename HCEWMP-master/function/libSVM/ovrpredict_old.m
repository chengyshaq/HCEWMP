function [pred, ac, decv] = ovrpredict_individual_node(y, x, model)

labelSet = model.labelSet;
labelSetSize = length(labelSet);
models = model.models;
decv= zeros(size(y, 1), labelSetSize);

for i=1:labelSetSize
  pLabel = (y == labelSet(i));
  [l,a,d] = predict(double(sum(pLabel, 2)), x, models{i});
  decv(:, i) = d * (2 * models{i}.Label(1) - 1);
end
[tmp,pred] = max(decv, [], 2);
pred = labelSet(pred);
[ro col] = size(y);
ac = 0;
for i = 1:col
    ac = ac + sum(y(:, i) == pred);
end
ac = ac / size(x, 1);
