#!/usr/bin/env python
# a bar plot with errorbars
import numpy as np
import matplotlib.pyplot as plt

N = 12
basicaa = (21.012213867,18.7198083177,8.8725580247,12.3604800776,4.0737125457,72.3102937641,42.1901715615,16.7204242664,46.5999741051,13.9431616341,8.9016447407,39.9068363166)
sraa = (51.2108659058,1.7951062201,19.8898664655,7.2755782913,14.618101239,52.9868340509,54.2413492294,28.8620059374,13.6348356188,34.3553205232,13.4390465427,30.8501186112)
basicsraa = (52.4415547699,19.8545605632,23.261698731,14.9564018539,16.3401329604,78.2362840386,63.9651061355,33.5837550301,66.6821096528,37.6574358146,17.1204814649,53.6657321544,)


ind = np.arange(N)  # the x locations for the groups
width = 0.08       # the width of the bars

fig, ax = plt.subplots()

ax.margins(0.01)


rects1 = ax.bar(ind+width, basicaa, width, color='y')
rects2 = ax.bar(ind+width+width, sraa, width, color='g')
rects3 = ax.bar(ind+width+width+width, basicsraa, width, color='b')
+width

ax.set_xticks(ind+width)#emplacement de label
ax.set_xticklabels( ('bzip2','omnetpp','hmmer','h264ref','gcc','sjeng','astar','xalancbmk','gobmk','mcf','perlbench','libquantum') )

ax.legend( (rects1[0], rects2[0], rects3[0] ), ('basicaa', 'sraa', 'basicaa+sraa') )



plt.show()

