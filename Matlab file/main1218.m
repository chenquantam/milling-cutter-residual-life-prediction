clear all;  
rnode=cell(3,1);%3*1��?��??  
% rchild_value=cell(3,1);%3*1��?��??  
% rchild_node_num=cell(3,1);%3*1��?��??  
sn=300; %?��i���`�����sn??��  
tn=10;  %�˪L��?��?��?��
load('aaa.mat');  
n = size(r,1);
%% ?��??����?��˪L�MID3��k�۫�?���˪L  
discrete_dim = [];
for j=1:tn  
    Sample_num=randi([1,n],1,sn);%?1��1000??����sn??��  
    SData=r(Sample_num,:);  
    [tree,discrete_dim]= train_C4_5(SData, 5, 10, discrete_dim);  
    rnode{j,1}=tree;  
end  
      
%% ?��??  
load('aaa.mat');  
T = r;
%TData=roundn(T,-1);  
TData = roundn(T,-1);  
%??��?�A??�J��??�V�q?��벼�A�M�Z??�X?���̰���???��?�X  
result = statistics(tn, rnode, TData, discrete_dim);  
gd = T(:,end);
len = length(gd);
count = sum(result==gd);
fprintf('�@��%d??���A�P?���̪���%d\n',len,count);
