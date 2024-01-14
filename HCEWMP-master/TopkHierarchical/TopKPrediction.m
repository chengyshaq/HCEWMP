function [predict_label_RF] = TopKPrediction(input_data, model, tree,train_data,k,train_num,alpha,trees,way)    
    [m,~]=size(input_data);
    root = find(tree(:,1)==0);
    train_distribute=train_num(:,2);%data distribution of leaf nodes in the training set
    leafnode=tree_LeafNode(tree);
    middlenode = tree_InternalNodes( tree );
    rootLabel=model{root}.Label';
    rootc=sum(train_num(rootLabel,2));
    rootd=max(train_num(rootLabel,2));
    for i=1:length(model{root}.Label)
        if (ismember(rootLabel(i),middlenode))
            if train_num(rootLabel(i),2)>=0.5*rootd
                W{root}(i,i)=1-(1./((train_num(rootLabel(i),2))+ rootc*alpha));
                PW{root}(i)=1-(1./(train_num(rootLabel(i),2)+ rootc*alpha));
            elseif train_num(rootLabel(i),2)<=0.2*rootd
                W{root}(i,i)=1+(1./((train_num(rootLabel(i),2))+ rootc*alpha));
                PW{root}(i)=1+(1./(train_num(rootLabel(i),2)+ rootc*alpha));
            else
                W{root}(i,i)=1;
                PW{root}(i)=1;
            end
        else
            if train_num(rootLabel(i),2)>=0.5*rootd
                W{root}(i,i)=1-(1./((train_num(rootLabel(i),2))+ rootc*alpha));
                PW{root}(i)=1-(1./(train_num(rootLabel(i),2)+ rootc*alpha));
            elseif train_num(rootLabel(i),2)<=0.2*rootd
                W{root}(i,i)=1+(1./((train_num(rootLabel(i),2))+ rootc*alpha));
                PW{root}(i)=1+(1./(train_num(rootLabel(i),2)+ rootc*alpha));
            else
                W{root}(i,i)=1;
                PW{root}(i)=1;
            end
        end    
    end
    for j =1:length(middlenode)
        currentnode=middlenode(j);
        currentnodeLabel=model{currentnode}.Label';
        currentnodec=sum(train_num(currentnodeLabel,2));
        currentnoded=max(train_num(currentnodeLabel,2));
        for i=1:length(currentnodeLabel)
            if (ismember(currentnodeLabel(i),middlenode))
                if train_num(currentnodeLabel(i),2)>=0.5*currentnoded
                    W{currentnode}(i,i)=1-(1./((train_num(currentnodeLabel(i),2))+ currentnodec*alpha));
                    PW{currentnode}(i)=1-(1./(train_num(currentnodeLabel(i),2)+ currentnodec*alpha));
                elseif train_num(currentnodeLabel(i),2)<=0.2*currentnoded
                    W{currentnode}(i,i)=1+(1./((train_num(currentnodeLabel(i),2))+ currentnodec*alpha));
                    PW{currentnode}(i)=1+(1./(train_num(currentnodeLabel(i),2)+ currentnodec*alpha));
                else
                    W{currentnode}(i,i)=1;
                    PW{currentnode}(i)=1;
                end
            else
                if train_num(currentnodeLabel(i),2)>=0.5*currentnoded
                    W{currentnode}(i,i)=1-(1./((train_num(currentnodeLabel(i),2))+ currentnodec*alpha));
                    PW{currentnode}(i)=1-(1./(train_num(currentnodeLabel(i),2)+ currentnodec*alpha));
                elseif train_num(currentnodeLabel(i),2)<=0.2*currentnoded
                    W{currentnode}(i,i)=1+(1./((train_num(currentnodeLabel(i),2))+ currentnodec*alpha));
                    PW{currentnode}(i)=1+(1./(train_num(currentnodeLabel(i),2)+ currentnodec*alpha));
                else
                    W{currentnode}(i,i)=1;
                    PW{currentnode}(i)=1;
                end
            end    
        end
    end
    for j=1:m %The number of instances
%% Start at the root and select K nodes 
        if(way==1)
             model{root}.w=W{root}*model{root}.w;
             [~,~,d_v] = predict(1,sparse(input_data(j,:)), model{root}, '-b 1 -q'); 
             [n_d_v,IX]=sort(d_v,'descend');
        else
            [~,~,d_v] = predict(1,sparse(input_data(j,:)), model{root}, '-b 1 -q');
            [n_d_v,IX]=sort(d_v.*PW{root},'descend');
        end
        q = max(tree(:,2)); %%Record the number of layers in the tree  
        for i =1:k   
            currentNodeID = IX(1,i);
            mid_pro(i) = n_d_v(1,i);
            currentNode(i) = model{root}.Label(currentNodeID); 
            currentNodeSelect(i,:)=[currentNode(i),mid_pro(i)];%
        end
%% Recursive middle level and select k nodes
        for index = 1: q-1 
            currentNodeNew = [];
            for i = 1:k %
                currentNodeNew =[currentNodeNew; RecursiveLeaf(currentNodeSelect(i,:),input_data(j,:),model,tree,k,W,PW,way)];
            end
            [n_d_v,IX]=sort(currentNodeNew(:,3),'descend');  
            currentNodeSelect(1:k,:) = currentNodeNew(IX(1:k,1),1:2); 
         end
%% Call classifier   
     [predict_label_RF(j,:)] = RandomForest(input_data(j,:),currentNodeSelect(:,1),train_data,k,trees);
   end %%endfor   
end
