import xlrd
import xlwt
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


file_path='C:/Users/G6011190/Desktop/IMS DATA ANALYSIS/數據集/Train_A/Train_A/Train_A/'
store_path='C:/Users/G6011190/Desktop/IMS DATA ANALYSIS/'

exceltable=xlwt.Workbook()  #創建excel表格
sheet1=exceltable.add_sheet('X-FFT',cell_overwrite_ok=True)
sheet1.write(0,0,'序號')  #創建欄位
sheet1.write(0,1,'頻率')
sheet1.write(0,2,'變換值')

sheet2=exceltable.add_sheet('Y-FFT',cell_overwrite_ok=True)
sheet2.write(0,0,'序號')  #創建欄位
sheet2.write(0,1,'頻率')
sheet2.write(0,2,'變換值')

sheet3=exceltable.add_sheet('Z-FFT',cell_overwrite_ok=True)
sheet3.write(0,0,'序號')  #創建欄位
sheet3.write(0,1,'頻率')
sheet3.write(0,2,'變換值')

m1=9999
m2=20000
x=range(m1,m2)
L=m2-m1

"""
for excel_file in [_file for _file in os.listdir(file_path)]:
    A=excel_file[8:11]
    with open(file_path) as csvfile:
        read=csv.reader(csvfile,delimiter=' ')
        #获取整行和整列的值（数组）
        #table.row_values(i)
        #table.col_values(i)
        xfft=np.fft(xread)
        xabs=abs(xfft)
        xf1=abs(fft(xread))/L      #歸一化處理
        xf2=xf1[range(int(L/2))]   #由於對稱性，只取一半
        xf=np.arange(len(xread))   #頻域
        xf1=xf
        xf2=xf[range(int(len(x)/2))]    #取一半
        sheet1.write(A,0,xf2)
            
#plt.plot(xf1,xf2)

"""
path=os.chdir('C:/Users/G6011190/Desktop/IMS DATA ANALYSIS/數據集/Train_A/Train_A/Train_A/')
file_chdir=os.getcwd()
filecsv_list=[]
for root,dirs,files in os.walk(file_chdir):
    for file in files:
        if os.path.splitext(file)[1]=='.csv':
            filecsv_list.append(file)
data=pd.DataFrame()
data1=pd.DataFrame()

x=pd.DataFrame()
for csv in file_path:
    data=pd.read_csv(csv,header=None,sep=None,names=['X力量','Y力量','Z力量','X振動','Y振動','Z振動','均方根V'],encoding='utf8')
    data1=data.iloc[:,0:3]
    








exceltable.save('C:/Users/G6011190/Desktop/IMS DATA ANALYSIS/XYZ-FFT.csv')   #保存excel文檔
