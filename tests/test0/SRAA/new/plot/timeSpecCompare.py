#!/usr/bin/env python
# a stacked bar plot with errorbars
import numpy as np
import matplotlib.pyplot as plt
import os
from matplotlib.backends.backend_pdf import PdfPages
from pylab import *
import subprocess

plt.yscale('log')
plt.ylim([0.001,300])
N = 13

evalsraa=csv2rec('../report.evalsraaSpec.csv', delimiter=',')
evalsraaNoOverlap=csv2rec('../report.evalsraaSpecNoOverlap.csv', delimiter=',')

totaltime = evalsraa["totaltime"]
totaltimeNoOverlap = evalsraaNoOverlap["totaltime"]


#Test1 => Local trees in the dependence graph
#Test2 => Less than relationships
#Test3 => Different allocation sites

width = 0.1      # the width of the bars: can also be len(x) sequence
ind = np.arange(N)  # the x locations for the groups
plt.margins(0.03)

p0 = plt.bar(ind, totaltime, width, color='y')
p1 = plt.bar(ind+width, totaltimeNoOverlap, width, color='b')


#plt.title('Scores by group and gender')
plt.xticks(ind+ width, ('bzip2','omnetpp','hmmer','h264ref','gcc','sjeng','astar','xalancbmk','gobmk','mcf','perlbench','libquantum','lbm'), rotation=45)
#plt.yticks(np.arange(0, 81, 10))
plt.legend((p0[0], p1[0]), ('Total Time SRAA', 'Total Time Selective SRAA'))

#figure = plt.gcf()	
#figure.set_size_inches(15, 8)
#plt.savefig('spec3testsSraa.pdf', dpi=300)
#os.system('pdfcrop "spec3testsSraa.pdf" spec3testsSraa.pdf')
plt.show()

