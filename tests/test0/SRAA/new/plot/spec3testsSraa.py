#!/usr/bin/env python
# a stacked bar plot with errorbars
import numpy as np
import matplotlib.pyplot as plt
import os
from pylab import *
from matplotlib.backends.backend_pdf import PdfPages
import subprocess

plt.yscale('log')
plt.ylim([100,100000000])
N = 13

evalsraa=csv2rec('../report.evalsraaSpec.csv', delimiter=',')
evalbasic=csv2rec('../report.evalbasicSpec.csv', delimiter=',')

pairs=evalsraa["total"]
totalSraa = evalsraa["noalias"]
Combine = evalsraa["noaliastest1"]
LTC = evalsraa["noaliastest2"]
PDD = evalsraa["noaliastest3"]
#basic = evalbasic["noalias"]

#Test1 => Local trees in the dependence graph  => Combine
#Test2 => Les than relationships  => LTC
#Test3 => Different allocation sites => PDD

plt.margins(0.03)
width = 0.1      # the width of the bars: can also be len(x) sequence
ind = np.arange(N)  # the x locations for the groups

p0 = plt.bar(ind, totalSraa, width, color='r')
p1 = plt.bar(ind+width, PDD, width, color='c')
p2 = plt.bar(ind+width, LTC, width, color='y',bottom=PDD)
p3 = plt.bar(ind+width, Combine, width, color='g', bottom=[i+j for i,j in zip(PDD,LTC)])
#p4 = plt.bar(ind+width+width, basic, width, color='b')


plt.xticks(ind+ width + width/2, ('bzip2','omnetpp','hmmer','h264ref','gcc','sjeng','astar','xalancbmk','gobmk','mcf','perlbench','libquantum', 'lbm'), rotation=45)
plt.legend((p0[0], p1[0], p2[0], p3[0]), ('Total SRAA', 'PDD', 'LTC', 'Ranges'))

#figure = plt.gcf()	
#figure.set_size_inches(15, 8)
#plt.savefig('spec3testsSraa.pdf', dpi=300)
#os.system('pdfcrop "spec3testsSraa.pdf" spec3testsSraa.pdf')
plt.show()

