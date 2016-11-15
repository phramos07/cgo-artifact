import numpy as np
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt2
from pylab import *
import subprocess
import os
from matplotlib.backends.backend_pdf import PdfPages
import pandas as pd
import matplotlib.ticker as plticker
import matplotlib.ticker as ticker


evalsraa=csv2rec('../report.evalsraaMultisources.csv', delimiter=',')
evalbasic=csv2rec('../report.evalbasicMultisources.csv', delimiter=',')
evalsraabasic=csv2rec('../report.evalsraabasicMultisources.csv', delimiter=',')

pairs=evalsraa["total"]
sraa=evalsraa["noalias"]
basic=evalbasic["noalias"] 
basicsraa=evalsraabasic["noalias"] 

plt.semilogy(pairs, 'xk', label='pairs')
plt.semilogy(sraa, 'ro', label='sraa')
plt.semilogy(basic, '^b', label='basicaa')
plt.semilogy(basicsraa, 'sy', label='basicaa+sraa')


#configure  X axes
plt.xlim(-5,110)
#plt.xaxis.set_major_locator(ticker.MultipleLocator(5))

loc = plticker.MultipleLocator(base=1.0) # this locator puts ticks at regular intervals


#plt.margins(0.1)
plt.legend(loc='upper left', numpoints=1)

#figure = plt.gcf()	
#figure.set_size_inches(15, 8)
#plt.savefig('multisources.pdf')
#os.system('pdfcrop "multisources.pdf" multisources.pdf')
plt.show()

