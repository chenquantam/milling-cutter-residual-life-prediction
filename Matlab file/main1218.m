clear all;  
rnode=cell(3,1);%3*1的?元??  
% rchild_value=cell(3,1);%3*1的?元??  
% rchild_node_num=cell(3,1);%3*1的?元??  
sn=300; %?机可重复的抽取sn??本  
tn=10;  %森林中?策?的?目
load('aaa.mat');  
n = size(r,1);
%% ?本??采用?机森林和ID3算法构建?策森林  
discrete_dim = [];
for j=1:tn  
    Sample_num=randi([1,n],1,sn);%?1至1000??机抽取sn??本  
    SData=r(Sample_num,:);  
    [tree,discrete_dim]= train_C4_5(SData, 5, 10, discrete_dim);  
    rnode{j,1}=tree;  
end  
      
%% ?本??  
load('aaa.mat');  
T = r;
%TData=roundn(T,-1);  
TData = roundn(T,-1);  
%??函?，??入的??向量?行投票，然后??出?票最高的???型?出  
result = statistics(tn, rnode, TData, discrete_dim);  
gd = T(:,end);
len = length(gd);
count = sum(result==gd);
fprintf('共有%d??本，判?正确的有%d\n',len,count);
