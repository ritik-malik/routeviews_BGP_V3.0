from bokeh.plotting import figure, output_file, save
import pandas as pd
import os, sys

FILE_NAME = sys.argv[1]                 # ISP_ASN_database.csv
LIMIT = int(sys.argv[2])                # drop LIMIT % for graphs

ISP, AS, EXT = FILE_NAME.split('_')


data = pd.read_csv(FILE_NAME)
os.mkdir(ISP+'_'+AS+'_graphs')
os.chdir(ISP+'_'+AS+'_graphs')


x=[]
y=[]

for i in range(len(data)):
    if data.DATE[i] != 0:
        x.append(str(data.DATE[i])+'.'+str(data.TIME[i]))
        y.append(data.FREQ[i])
    
    else:
        
        yy=[]
        for freq in range(len(y)):
            yy.append(round((y[freq]/max(y))*100,2))
        
        # print('Len of x = ',len(x))
        # print('Len of y = ',len(y))
        # print('Len of yy = ',len(yy))
        
        # print(yy)
        
        print('Max - Min = ',round(max(yy)-min(yy),2))
        
        if round(max(yy) - min(yy),2) > LIMIT:
            
            flag=0
            temp = yy[0]
            for freq in range(len(yy)-1):
                if abs(yy[freq] - temp) > temp/2:
                    flag+=1
                    temp=yy[freq]
                    
            if flag>1:
                name = data.PREFIX[i-1][:-3]+'_'+data.PREFIX[i-1][-2:]+'.html'
            else:
                name = data.PREFIX[i-1][:-3]+'_'+data.PREFIX[i-1][-2:]+'_EXTRA.html'
                
                
            output_file(name)

            title = ISP+'_'+AS+' ->   '+data.PREFIX[i-1]+'   ,  [ max = '+str(max(y))+', min = '+str(min(y))+' ]'

            p = figure(title=title, x_axis_label='dates', y_axis_label='freq', x_range=x, plot_width = 1900, plot_height = 900)

            p.line(x,yy)
            p.circle(x,yy)

            print('Making graph',name)
            save(p)
            

        x=[]
        y=[]


os.chdir('..')
