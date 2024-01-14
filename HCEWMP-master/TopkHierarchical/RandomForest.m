function [predict_label_RF] = RandomForest(test_data,predict_label,data,k,trees)
Y=[];    
    for i = 1:k  
       Y_i= find(data(:,end) == predict_label(i)) ;  
       Y = [Y;Y_i] ;
    end
    TrainData = data(Y,:);
    train_data = TrainData(:,1:end-1);  
    train_label = TrainData(:,end); 
    
    nTree =trees;
    B = TreeBagger(nTree,train_data,train_label);   
    predict_label_RF_cell = predict(B,test_data); 
    predict_label_RF = str2num(predict_label_RF_cell{1,1});  
end