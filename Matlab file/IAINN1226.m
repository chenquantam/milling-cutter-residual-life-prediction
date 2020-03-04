clc
clear
close all
tic
flute_A=csvread('C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\數據集\Train_A\Train_A\Train_A_wear.csv',1);
flute_B=csvread('C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\數據集\Train_B\Train_B\Train_B_wear.csv',1);
dataAB=xlsread('C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\AB特徵值.xls','Sheet1');
dataT=xlsread('C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\T特徵值.xls','Sheet1');
%wear_t=csvread('D:\Daisy\IAI大賽\處理\2018.12.19\c6_wear.csv',1);
TIME=xlsread('C:\Users\G6011190\Desktop\次數.xlsx');
ndata=dataAB;
for i=1:size(dataAB,2)
    ndata(:,i)=smooth(dataAB(:,i),30,'lowess');%對周圍30個數據進行濾波
end
ip=ndata';

ntest=dataT;
for m=1:size(dataT,2)
    ntest(:,m)=smooth(ntest(:,m),30,'lowess');%對周圍30個數據進行濾波
end
newInput=ntest';


for j=2:4
    Mean_flute_AB(:,j-1)=mean([flute_A(:,j),flute_B(:,j)],2);%求AB絕對平均幅值的均值
end
%cumsum_flut_AB=cumsum(diff( Mean_flute_AB,1),1);
%up=cumsum_flut_AB';
flute_AB1=Mean_flute_AB(:,1);flute_AB2=Mean_flute_AB(:,2);flute_AB3=Mean_flute_AB(:,3);

for s=51:70
    for t=51:65
        for k=41:65
           % s=60;t=46;k=50;
           %s=60;t=46;k=49;
            flute_AB1=flute_AB1-flute_AB1(1)+s;flute_AB2=flute_AB2-flute_AB2(1)+t;flute_AB3=flute_AB3-flute_AB3(1)+k;%磨損量累加值
            flute_AB=[flute_AB1';flute_AB2';flute_AB3'];
            
            [pn,inputStr]=mapminmax(ip);
            [tn,outputStr]=mapminmax(flute_AB);

            net=newff(pn,tn,[50 39 10],{'logsig','logsig','logsig'},'trainlm');
            net.trainParam.epochs=5000;%最大訓練次數
            net.trainParam.lr=0.045;
            net.trainParam.goal=0.65*10^(-5);
            net.divideFcn='';
            net=train(net,pn,tn);
            answer=sim(net,pn);
            predictA=mapminmax('reverse',answer,outputStr);
            save(['C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\MAT\','A',num2str(s),num2str(t),num2str(k),'.mat'],'net')

            newInput=mapminmax('apply',newInput,inputStr);
            %load('-mat','F:\朸冪厙釐\(AB)yuce.matD:\Daisy\IAI大賽\處理\AB神經網絡.mat','net');%調用訓練好的神經網絡
            newOutput=sim(net,newInput);
            newOutput=mapminmax('reverse',newOutput,outputStr);
            resultAB=newOutput';
            end

        NUM=1:315;
        NUMA=NUM;
        minAA=[];
    for j1=1:315        %在使用次數相同時，取三把刀最小的值并從小到大排序，只保留最小值
        minA=sort([round(resultAB(j1,:)),round(resultAB(j1,2)),round(resultAB(j1,3))]);   
        minAA=[minAA minA(1)];
    end
    for j2=length(minAA):-1:2           %去掉磨損量重复的值
        if minAA(j2-1)==minAA(j2) 
            minAA(j2)=[]; 
            NUMA(j2)=[];
        end
    end

    for j3=2:(max(minAA)-min(minAA))     %將斷開的數據補上
        if minAA(j3)-minAA(j3-1)~=1
            minAAjtoEND=minAA(j3:end);
            NUMAjtoEND=NUMA(j3:end);    
            minAA(j3:end)=[];
            NUMA(j3:end)=[];
            minAA(j3)=minAA(j3-1)+1; 
            NUMA(j3)=NUMA(j3-1); 
            minAA=[minAA minAAjtoEND];                     
            NUMA=[NUMA  NUMAjtoEND];      
        end
    end

        if minAA(1)>51     %?第一??大于51?，在前面?上??的??，使得?列?51?始
           NUMA=[ones(1,minAA(1)-51) NUMA];
           minAA=[51:minAA(1)-1 minAA];   
        end

        if  minAA(end)<200   %?最后的磨?量小于200?，在后面?足200，次?全?315
            NUMA=[NUMA 315*ones(1,200-minAA(end))];
            minAA=[minAA (minAA(end)+1):200];
        end

        num51A=find(minAA==51);    %把磨?量?51-200的使用次?找出?
        num200A=find(minAA==200);  
        wearA=minAA(num51A:num200A)';
        wearnumA=NUMA(num51A:num200A)';

        SCORE=0;  %?算??分?
        for ii=1:150
            d=wearnumA(ii)-TIME(ii);
            if d>0
                score=exp(d/4.5)-1;
            else
                score=exp(-d/10)-1;
            end
            SCORE=SCORE+score;            
        end
        fineSCORE(s,t,k)=SCORE;
        end
    end

a=10^30;
for i=1:55
    for j=1:45
        for k=1:50
            if fineSCORE(i,j,k)>0 &&fineSCORE(i,j,k)<a
                a=fineSCORE(i,j,k);
                x=i;y=j;z=k;
            end
        end
    end
end
location=[x y z]
toc