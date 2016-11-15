import numpy as np
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt2
from pylab import *
import subprocess
import os
from matplotlib.backends.backend_pdf import PdfPages

evalsraa=csv2rec('../report.evalsraaMultisources.csv', delimiter=',')

pairs=evalsraa["total"]
time=evalsraa["totaltime"]

plt.semilogy(pairs, 'xk', label='#Pointers')
plt.semilogy(time, 'ro', label='SRAA runtime')

plt.margins(0.1)
plt.legend(loc='upper left', numpoints=1)
plt.savefig('SRAAtimeMultisources.pdf')
os.system('pdfcrop "SRAAtimeMultisources.pdf" SRAAtimeMultisources.pdf')
plt.show()

