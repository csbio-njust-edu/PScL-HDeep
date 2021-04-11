function multi_labels01 = prepare_multiLabels(label_all)

%% 2. Set multi label data
    multi_labels01=[]; l1=[];l2=[];l3=[];l4=[];l5=[];l6=[];l7=[];
    % 
for i1=1:size(label_all,1)
      if label_all(i1)==1
      label1=label_all(i1);
      label00=[1 0 0 0 0 0 0]';
      l1=[l1;i1];
      end
       if label_all(i1)==2
      label1=label_all(i1);
      label00=[0 1 0 0 0 0 0]';
      l2=[l2;i1];
       end;
       if label_all(i1)==3
      label1=label_all(i1);
      label00=[0 0 1 0 0 0 0]';
      l3=[l3;i1];
       end;
       if label_all(i1)==4
      label1=4;
      label00=[0 0 0 1 0 0 0]';
      l4=[l4;i1];
       end
      if label_all(i1)==5
      label1=5;
      label00=[0 0 0 0 1 0 0]';
      l5=[l5;i1];
      end
      if label_all(i1)==6
      label1=6;
      label00=[0 0 0 0 0 1 0]';
      l6=[l6;i1];
      end
      if label_all(i1)==7
      label1=7;
      label00=[0 0 0 0 0 0 1]';
      l7=[l7;i1];
      end
multi_labels01=[multi_labels01  label00];          
end
% save multi_labels multi_labels01;
end
