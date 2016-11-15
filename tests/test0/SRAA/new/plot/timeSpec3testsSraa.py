#!/usr/bin/env python
# a stacked bar plot with errorbars
import numpy as np
import matplotlib.pyplot as plt
import os
from matplotlib.backends.backend_pdf import PdfPages
from pylab import *
import subprocess

plt.yscale('log')
N = 12

evalsraa=csv2rec('../report.evalsraaSpec.csv', delimiter=',')

totaltime = evalsraa["totaltime"]
time_Ranges = evalsraa["timetest1"]
time_LTC = evalsraa["timetest2"]
time_PDD = evalsraa["timetest3"]

#Test1 => Local trees in the dependence graph
#Test2 => Less than relationships
#Test3 => Different allocation sites

width = 0.1      # the width of the bars: can also be len(x) sequence
ind = np.arange(N)  # the x locations for the groups

p0 = plt.bar(ind, totaltime, width, color='r')
p1 = plt.bar(ind+width, time_PDD, width, color='b')
p2 = plt.bar(ind+width, time_LTC, width, color='y',bottom=time_PDD)
p3 = plt.bar(ind+width, time_Ranges, width, color='g', bottom=[i+j for i,j in zip(time_PDD,time_LTC)])


#plt.title('Scores by group and gender')
plt.xticks(ind+ width + width/2, ('bzip2','omnetpp','hmmer','h264ref','gcc','sjeng','astar','xalancbmk','gobmk','mcf','perlbench','libquantum'), rotation=45)
#plt.yticks(np.arange(0, 81, 10))
plt.legend((p0[0], p1[0], p2[0], p3[0]), ('Total Time SRAA', 'Time_PDD', 'Time_LTC', 'Time_Ranges'))

#figure = plt.gcf()	
#figure.set_size_inches(15, 8)
#plt.savefig('spec3testsSraa.pdf', dpi=300)
#os.system('pdfcrop "spec3testsSraa.pdf" spec3testsSraa.pdf')
plt.show()

