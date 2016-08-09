#!/usr/bin/gnuplot
load '~/rev/build/gnuplot-palettes/paired.pal'

#function used to map a value to the intervals
hist(x,width) = width*floor(x/width)+width/2.0
set term pdf
set output "dmdas_pop_ready.pdf"

stats "output/dmdas_pop_ready.data" using 3 nooutput
max=STATS_max
min=0
n=(max-min)/2
width=(max-min)/n
set xrange [min:max]
set yrange [0:]

#to put an empty boundary around the
#data inside an autoscaled graph.
set offset graph 0.05,0.05,0.05,0.0
set xtics min,(max-min)/5,max
set boxwidth width*0.9
set style fill solid 0.5 #fillstyle
set tics out nomirror
set xlabel "Pop task"
set ylabel "Frequency"

#count and plot
plot "output/dmdas_pop_ready.data" u (hist($4,width)):(1.0) smooth freq w boxes lc rgb"green" notitle
