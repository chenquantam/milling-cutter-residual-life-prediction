clc
clear
close all
%% 讀取磨損數據和其中的一次數據進行可視化
% A=xlsread('C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\數據集\Train_B\Train_B\Train_B\Train_B_150.csv');
% B=xlsread('C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\數據集\Train_B\Train_B\Train_B_wear.csv');
% 
% t=50:315;
% F=sqrt((B(:,2).^2+B(:,3).^2+B(:,4).^2)/3);
% p=polyfit(t',F(50:315),3);
% pp=polyval(p,t);
% 
% figure(1)
% % plot(B(:,2))
% % hold on 
% % plot(B(:,3))
% % plot(B(:,4))
% % legend('flute_1','flute_2','flute_3')
% plot(t,pp)
% hold on 
% plot(t,F(50:315))
% %legend('flute_1','flute_2','flute_3','poly','average')
% hold off 
% 
% Fs=50000;
% T=1/Fs;
% L=length(A);
% A1=smoothdata(A(:,1));
% Y=fft(A1);
% P2=abs(Y/L);
% P1=P2(1:L/2+1);
% P1(2:end-1)=2*P1(2:end-1);
% f=Fs*(0:(L/2))/L;
% figure(2)
% plot(f,P1)

%%
mkdir('Train_BB')
dir_scr=dir('C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\數據集\Train_B\Train_B\Train_B');
m1=10000;
m2=30000;
Fs=50000;
T=1/Fs;
L=m2-m1;
PP=[];
PPY=[];
PPZ=[];
route_scr='C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\數據集\Train_B\Train_B\Train_B\';
route='C:\Users\G6011190\Desktop\IMS DATA ANALYSIS\數據集\Train_B\TrainB.xlsx';
for i=3:length(dir_scr)
    name=dir_scr(i).name;
    I=xlsread(strcat(route_scr,name));     
    [thr1,sorh1,keepapp1,crit1]=ddencmp('cmp','wp',I(m1:m2,1));
    [A1,wpt,perf0,perfl2]=wpdencmp(I(m1:m2,1),sorh1,3,'db2',crit1,thr1,keepapp1);
    Y=fft(A1);
    P2=abs(Y/L);
    P1=P2(1:L/2+1);
    P1(2:end-1)=2*P1(2:end-1);
    f=Fs*(0:(L/2))/L;
    P11=[P1(70) P1(209) P1(418)];
    PP=[PP; P11];     
     
    [thr2,sorh2,keepapp2,crit2]=ddencmp('cmp','wp',I(m1:m2,2));
    [A2,wpt,perf0,perfl2]=wpdencmp(I(m1:m2,2),sorh2,3,'db2',crit2,thr2,keepapp2);
    Y2=fft(A2);
    PY2=abs(Y2/L);
    PY1=PY2(1:L/2+1);
    PY1(2:end-1)=2*PY1(2:end-1);
    f=Fs*(0:(L/2))/L;
    PY11=[PY1(70) PY1(209) PY1(418)];
    PPY=[PPY; PY11];     
    
    [thr3,sorh3,keepapp3,crit3]=ddencmp('cmp','wp',I(m1:m2,3));
    [A3,wpt,perf0,perfl2]=wpdencmp(I(m1:m2,3),sorh3,3,'db2',crit3,thr3,keepapp3);
    Y3=fft(A3);
    PZ2=abs(Y3/L);
    PZ1=PZ2(1:L/2+1);
    PZ1(2:end-1)=2*PZ1(2:end-1);
    f=Fs*(0:(L/2))/L;
    PZ11=PZ1(209);
    PPZ=[PPZ; PZ11];
 end
% 
% %  X方向的315筆數據進行傅立葉變換後在17.5/52/104這3個位置的值
% PP1=smooth(PP(:,1),0.15,'rloess');
% PP2=smooth(PP(:,2),0.15,'rloess');
% PP3=smooth(PP(:,3),0.15,'rloess');
% 
% figure
% plot(PP(:,1))
% hold  on
% plot(PP(:,2))
% plot(PP(:,3))
% plot(smooth(PP(:,1),0.15,'rloess'))
% plot(smooth(PP(:,2),0.15,'rloess'))
% plot(smooth(PP(:,3),0.15,'rloess'))
% legend('x1=173.7','x2=521','x3=1042')
% hold off
% 
% PPY1=smooth(PPY(:,1),0.15,'rloess');
% PPY2=smooth(PPY(:,2),0.15,'rloess');
% PPY3=smooth(PPY(:,3),0.15,'rloess');
% figure
% plot(PPY(:,1))
% hold  on
% plot(PPY(:,2))
% plot(PPY(:,3))
% plot(smooth(PPY(:,1),0.15,'rloess'))
% plot(smooth(PPY(:,2),0.15,'rloess'))
% plot(smooth(PPY(:,3),0.15,'rloess'))
% legend('y1=173.7','y2=521','y3=1042')
% hold off
% 
% PPZ1=smooth(PPZ,0.15,'rloess');
% figure
% plot(PPZ)
% hold on
% plot(smooth(PPZ,0.15,'rloess'))
% legend('z=521')
% hold off



