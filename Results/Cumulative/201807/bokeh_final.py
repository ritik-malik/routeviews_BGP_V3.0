from bokeh.plotting import figure, output_file, save
import csv, sys

input_file = sys.argv[1]
# input_file = '201807_output.csv'

with open(input_file, 'r') as source:
    data = csv.reader(source)

    for y in data:
        
        x = [str(j) for j in range(31)]
        
        title = y[0]
        NAME = y.pop(0)+'.html'
        
        output_file(NAME)
        p = figure(title=title, x_axis_label='dates', y_axis_label='freq', x_range=x, plot_width = 1900, plot_height = 900)

        p.line(x,y)
        p.circle(x,y)

        print('Making graph for',NAME)
        save(p)









































