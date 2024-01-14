function[node_Acc]=EvaHier_HierarchicalnodeAcc(label_test,label_predict,tree)
 middleNode  = newtree_InternalNodes(tree);
 num_examples = max(size(label_test,1),size(label_test,2));
 label_test_par=[];
 label_predict_par=[];
 for i = 1:num_examples
     cur_node = label_test(i);
     cur_node_pre=label_predict(i);
     cur_par = tree(cur_node,1);
     cur_node_pre_par=tree(cur_node_pre,1);
     label_test_par(i)=cur_par;
     label_predict_par(i)=cur_node_pre_par;
 end
 node_Acc=[];
 for i=1:length(middleNode)
     cur_par=middleNode(i);
     index= find(label_test_par==cur_par);
     cur_par_num=length(index);
     count = sum(label_test_par(index) == label_predict_par(index));
     node_Acc(i)=count/cur_par_num;
 end
end