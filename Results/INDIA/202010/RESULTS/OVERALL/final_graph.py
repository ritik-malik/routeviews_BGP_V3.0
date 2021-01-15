#### This algo will read all the CSV files for prefixes & make a
#### new CSV for comparison for "dates vs number of dips"
#
#   eg - Each CSV will result like this -> "KOTA_AS134875","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","2","0","0","0","0","0","0"
#   which means that this CSV has 2 dips on 24th
#
#   Usage -> Run "make_final.sh" file to trigger this file for all CSVs
#   Alternate single case Usage -> python final_graph.py KOTA_AS134875_database.csv 50 202010

import pandas as pd
import sys, csv

FILE_NAME = sys.argv[1]                 # ISP_ASN_database.csv
LIMIT = int(sys.argv[2])                # drop LIMIT % for graphs
NAME = sys.argv[3]                      # name for output   [YYYYMM]

NAME = NAME+'_output.csv'
ISP, AS, EXT = FILE_NAME.split('_')

data = pd.read_csv(FILE_NAME)


x = []
y = []
fin = [0 for j in range(31)]

for i in range(len(data)):
    if data.DATE[i] != 0:
        x.append(str(data.DATE[i])+'.'+str(data.TIME[i]))
        y.append(data.FREQ[i])
        
    else:           # if 1 prefix is completed for entire month -> 0,0,0,0,0 occurs
        
        yy = []
        for freq in range(len(y)):
            yy.append(round((y[freq]/max(y))*100,2))    # take % istead of absolute values
        
        print('Max - Min = ',round(max(yy)-min(yy),2))
        
        if round(max(yy) - min(yy),2) > LIMIT:      # makes graphs if > LIMIT, else reset
            
            # count number of changes states
            # Count if the prefixes jumps half the lenght from max to min/ min to max 
            # If only 1 times, we assume that the prefix has (either) started to (or) stopped advertisement
            # tag these graphs as extra & make a new folder
            
            flag=0
            temp = yy[0]
            for freq in range(len(yy)-1):
                if abs(yy[freq] - temp) > temp/2:
                    flag+=1
                    temp=yy[freq]
                    
            if flag>1:

                print(x,yy)
                
                ans = [j for j, e in enumerate(yy) if e < 50]
                print("\nans = ",ans)
                ans = [j//4 for j in ans]
                print("\nans = ",ans)

                # fin = [0 for j in range(31)]
                
                for j in range(31):
                    fin[j]+=ans.count(j)
                
                print("\nFin = ",fin,"\n")
                

        x = []
        y = []
                

fin.insert(0,ISP+'_'+AS)

with open(NAME, 'a', newline='') as f:
    wr = csv.writer(f, quoting=csv.QUOTE_ALL)
    wr.writerow(fin)
