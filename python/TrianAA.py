import re
import os 
import pandas as pd
import numpy as np
from scipy.fftpack import fft,ifft
import matplotlib.pyplot as plt
#import seaborn

path=os.chdir('F:/Train_A/')
file_chdir=os.getcwd()
filecsv_list=[]
for root,dirs,files in os.walk(file_chdir):
    for file in files:
        if os.path.splitext(file)[1]=='.csv':
            filecsv_list.append(file)
data=pd.DataFrame()
data1=pd.DataFrame()

x=pd.DataFrame()
for csv in filecsv_list:
    data=data.append(pd.read_csv(csv,header=None,sep=None,names=['X力量','Y力量','Z力量','X振動','Y振動','Z振動','均方根V'],encoding='utf8'))
    data1=data.iloc[:,0]
    x=data.iloc[:,0]
   # y=7*np.sin(2*np.pi*180*x) + 2.8*np.sin(2*np.pi*390*x)+5.1*np.sin(2*np.pi*600*x)
    yy=fft(x)                     #快速傅里???

yy1=pd.DataFrame(yy)
#yy1.to_csv("E:/新增資料夾/fu.csv")
#data1.to_csv("E:/新增資料夾/data.csv")
