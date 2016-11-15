#!/usr/bin/env python
# a bar plot with errorbars
import numpy as np
import matplotlib.pyplot as plt

N = 12
basicaa = (21.012213867,18.7198083177,8.8725580247,12.3604800776,4.0737125457,72.3102937641,42.1901715615,16.7204242664,46.5999741051,13.9431616341,8.9016447407,39.9068363166)
sraa = (50.9130747033,1.7797752088,19.7412771217,7.2313356153,14.7043266801,51.6946841243,53.8610061064,28.7302705968,8.6936965899,33.299693202,13.4118191717,30.8311408238)
basicsraa = (52.3831826572,19.8318328122,23.2224445313,14.8850093415,16.3067860283,76.9609021615,63.8569351556,33.5646989143,62.8822542767,36.8682383336,17.0911508503,53.6122492991)


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

