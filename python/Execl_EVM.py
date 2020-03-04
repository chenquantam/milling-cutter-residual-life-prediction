import xlrd
import datetime
import xlwt
import os
import csv

# D:/1.xls"
# FILE_PATH = 'C:/Users/liam/Desktop/Cal值后测试LOG File/'

STORAGE_PATH = "C:/TALOG/5G_EVM_A.xls"
FILE_PATH = 'C:/Bigdata/Rawdata/CPP166W7_Cal0515_before17days_5G_452(combine)/'

if __name__ == '__main__':
    # 创建
    wb = xlwt.Workbook()
    ws1 = wb.add_sheet('Chain 1', cell_overwrite_ok=True)
    ws2 = wb.add_sheet('Chain 2', cell_overwrite_ok=True)
    ws4 = wb.add_sheet('Chain 3', cell_overwrite_ok=True)
    ws8 = wb.add_sheet('Chain 4', cell_overwrite_ok=True)

    row1 = ['PCBA', 'Test Date', 'Test Time', 'TestName', 'CH', 'Demod', 'Rate', 'Chain',
            'Data', 'Unit', 'LimitLo', 'LimitHi', 'P/F', 'ReTest', 'UsedTime', 'Remark','TP','EVM']
    # 初始化行的默认值
    x1 = 1
    x2 = 1
    x4 = 1
    x8 = 1
    # 写入表头
    for row, val in enumerate(row1):
        ws1.write(0, row, val)
        ws2.write(0, row, val)
        ws4.write(0, row, val)
        ws8.write(0, row, val)
   # 遍历FILE_PATH
    for excel_file in [_file for _file in os.listdir(FILE_PATH) if _file.endswith('.csv')]:
    # for file in os.listdir(FILE_PATH):
        # 获取子文件夹下的 .csv 文件
        # excel_file = [_file for _file in os.listdir(FILE_PATH + file) if _file.endswith('.csv')][0]
        # 切片.csv 文件获取SN
        SN = excel_file.split('_')[0]
        date_ = excel_file.split("_")[1].split("-")[0]
        time_ = excel_file.split("_")[1].split("-")[1]
        
        # with open(FILE_PATH + file + '/' + excel_file, 'r', encoding='utf-8') as csvfile:  # 打開文件
        with open(FILE_PATH + excel_file, 'r', encoding='utf-8') as csvfile:  # 打開文件   
            
            # print ( file)
            # 读取csv文件
            read = csv.reader(csvfile, delimiter=',')
            # print (read)
            for i in read:
                # 筛选
                if len(i) > 2 and i[0] == '5G VHT80 TX EVM' and i[1].strip() == '155' and i[
                    2].strip() == 'VHT80' and i[3].strip() == 'MCS9' and i[4].strip() in ['1', '2', '4', '8']:

                    for row, val in enumerate([SN, date_, time_] + i):
                        # 写入不同的工作表
                        locals()['ws' + i[4].strip()].write(locals()['x' + i[4].strip()], row, val)
                    locals()['x' + i[4].strip()] += 1
    # 保存Excel
    wb.save(STORAGE_PATH)
