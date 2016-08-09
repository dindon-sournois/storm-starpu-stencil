#!/usr/bin/gnuplot
load '~/rev/build/gnuplot-palettes/paired.pal'

set output 'limit_gpu_mem.pdf'
set terminal pdf
set key inside left top vertical Right noreverse enhanced
set title "Fixed problem size : 1500MB"
set title  font ",20" norotate
set xlabel "Memory per node (MB)"
set ylabel "Completion time (ms)"
set xrange [] reverse
set yrange [0:]

plot "./output/limit_gpu_mem_dmda_500x3.txt" \
     with linespoints title "dmda" ls 1 lw 2 pt -1, \
     "./output/limit_gpu_mem_dmdas_500x3.txt" \
     with linespoints title "dmdas" ls 2 lw 2 pt -1, \
     "./output/limit_gpu_mem_dmdas_alternate_500x3.txt" \
     with linespoints title "dmdas alternate" ls 6 lw 2 pt -1, \
     "./output/limit_gpu_mem_lws_500x3.txt" \
     with linespoints title "lws" ls 3 lw 2 pt -1, \
     "./output/limit_gpu_mem_lws_loc_tasks_500x3.txt" \
     with linespoints title "lws-loc-tasks" ls 4 lw 2 pt -1, \
     "./output/limit_gpu_mem_cache_oblivious_500x3.txt" \
     using ($1):($2)/3 \
     with linespoints title "cache-oblivious" ls 5 lw 2 pt -1
