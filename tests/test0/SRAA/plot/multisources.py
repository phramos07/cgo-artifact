import numpy as np
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt2
from pylab import *


#labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'I', 'J', 'H', 'K', 'L']
pairs=[28275,29337,32861,34272,35193,38262,38508,41123,43254,46055,46139,49254,58355,62570,65123,65332,71657,71657,73236,73685,88754,89971,98648,104997,109545,147525,148423,155642,155642,157514,193376,202118,227768,276247,279730,301764,333341,347219,394731,444500,447866,452291,495214,524163,533116,607716,635644,680390,779874,989268,1145593,1155974,1155974,1156418,1156418,1156827,1156827,1156933,1156933,1157173,1157173,1157885,1157885,1158083,1158083,1158479,1158479,1158540,1158540,1158965,1158965,1159397,1159397,1159475,1159475,1159535,1159535,1160144,1160144,1160608,1160608,1161318,1161318,1161372,1161372,1170411,1170411,1379458,2622405,4721799,4771961,5580864,5747018,8476003,10719258,12930599,15146276,32381906,294270415]
sraa=[14633,9121,13165,8141,7616,3515,9545,24305,15225,15915,7886,34306,6516,28350,30129,28294,28893,28600,11100,8030,16361,30672,8224,15672,5640,78840,136461,122165,122164,15079,25018,64002,70101,54348,32318,52660,42284,127931,21206,115325,103019,185615,251799,168075,117621,67278,234520,238652,103459,532392,359942,112951,113105,113009,112919,112917,113039,113006,112914,113133,113040,113289,113226,113104,113133,113041,113155,113129,113098,113339,113246,112888,112843,113288,113406,113159,113218,113271,113210,113432,113519,113350,113215,113096,113221,113611,113583,356670,602326,1321318,347551,2992271,2398268,1641050,2764838,2435577,1828785,5010223,40780931]
basic=[4716,5772,15965,13947,10228,2763,18924,30296,15227,10956,10846,32348,21209,37104,31444,21188,24888,24888,18509,9811,38204,19692,8662,11647,12641,78233,76607,108263,108263,32345,43611,61774,28415,48857,19797,73347,44177,164182,102035,37962,85864,270579,293324,105280,79915,249759,95773,159210,100082,394799,174721,502553,502553,502835,502835,502985,502985,503044,503044,503373,503373,503601,503549,503960,503960,504120,504120,503876,503864,504582,504582,504345,504345,505049,505049,504675,504675,504825,504825,505744,505744,505760,505760,505683,505683,510311,510311,114771,482342,1311185,625198,2690741,1406757,825454,1840068,2976731,1784023,2091055,8714260]
#x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
basicsraa=[15007,10690,19730,15320,12404,4795,22247,33131,20708,18901,13385,35967,22297,43883,36604,33734,31657,31970,23157,12622,41165,35007,13191,16149,14610,92293,136824,124783,124783,37049,57509,80658,76834,88449,45382,83087,75610,171216,107217,124512,152108,329667,314274,209298,158322,276066,260080,281914,163680,640813,425604,502707,502719,502906,502934,503121,503136,503156,503221,503464,503572,503723,503632,504059,504119,504225,504306,503999,503989,504711,504724,504443,504434,505128,505158,504791,504746,505024,505038,505864,505834,505883,505893,505772,505796,510408,510408,394047,716126,1859541,714062,3354307,2789209,1813943,3218836,4223000,2855664,6439087,47138767]
plt.semilogy(pairs, 'xk', label='pairs')
plt.semilogy(sraa, 'ro', label='sraa')
plt.semilogy(basic, '^b', label='basicaa')
plt.semilogy(basicsraa, 'sy', label='basicaa+sraa')

plt.margins(0.1)
plt.legend(loc='upper left')
#plt.title('rbaa Runtime')
plt.ylabel("exp scale")
plt.xlabel("Benchmarks")
plt.show()
