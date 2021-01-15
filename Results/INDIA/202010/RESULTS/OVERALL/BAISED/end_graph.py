#   Use this script to craft a graphical comparison between dips & dates
#   Make sure that you run 2 scripts before & have a YYYYMM_output.csv in
#   the current folder
#
#   Usage -> python YYYMM_output.csv
#

from bokeh.plotting import figure, output_file, save
import csv, sys

input_file = sys.argv[1]
# input_file = '201807_output.csv'

sum_list = [0 for j in range(30)]
x = [str(j+1) for j in range(30)]

with open(input_file, 'r') as source:
    data = csv.reader(source)

    for y in data:
        
        y.pop(0)
        
        sum_list = [a + int(b) for a, b in zip(sum_list, y)]
        
        
    print(sum_list)
        
        
title = 'All ASNs combined for '+input_file+' [ max = '+str(max(sum_list))+', min = '+str(min(sum_list))+' ]'
NAME = 'final_graph.html'

output_file(NAME)
p = figure(title=title, x_axis_label='dates', y_axis_label='freq', x_range=x, plot_width = 1900, plot_height = 900)

p.line(x,sum_list)
p.circle(x,sum_list)

print('Making graph for',NAME)
save(p)
