#!/usr/bin/env python
# a bar plot with errorbars
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import os
from pylab import *
import subprocess

N = 12


evalsraa=csv2rec('../report.evalsraaSpec.csv', delimiter=',')
evalbasic=csv2rec('../report.evalbasicSpec.csv', delimiter=',')
evalsraabasic=csv2rec('../report.evalsraabasicSpec.csv', delimiter=',')

basicaa = evalbasic["noalias"]
sraa = evalsraa["noalias"]
basicsraa = evalsraabasic["noalias"]


ind = np.arange(N)  # the x locations for the groups
width = 0.08       # the width of the bars

fig, ax = plt.subplots()
plt.yscale('log')

#ax.margins(0.01)


rects1 = ax.bar(ind+width, basicaa, width, color='b')
rects2 = ax.bar(ind+width+width, sraa, width, color='r')
rects3 = ax.bar(ind+width+width+width, basicsraa, width, color='y')


ax.set_xticks(ind+width)#emplacement de label
ax.set_xticklabels( ('bzip2','omnetpp','hmmer','h264ref','gcc','sjeng','astar','xalancbmk','gobmk','mcf','perlbench','libquantum'), rotation=45 )

ax.legend( (rects1[0], rects2[0], rects3[0] ), ('basicaa', 'SRAA', 'basicaa+SRAA') )


plt.savefig('TotalSpec.pdf', dpi=300)
os.system('pdfcrop "TotalSpec.pdf" TotalSpec.pdf')

plt.show()


