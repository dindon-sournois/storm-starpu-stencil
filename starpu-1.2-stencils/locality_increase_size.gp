#!/usr/bin/gnuplot
load '~/rev/build/gnuplot-palettes/paired.pal'

set output 'increase_size.pdf'
set terminal pdf
set key inside left top vertical Right noreverse enhanced
set title "Limited memory 600MB"
set title  font ",20" norotate
set xlabel "Problem Size (MB)"
set ylabel "Completion time / Problem Size (ms)"

plot "./output/increase_problem_size_dmda_600.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmda" ls 1 lw 2 pt -1, \
     "./output/increase_problem_size_dmdas_600.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdas" ls 2 lw 2 pt -1, \
     "./output/increase_problem_size_lws_600.txt" \
     using ($1):($2)/($1) \
     with linespoints title "lws" ls 3 lw 2 pt -1, \
     "./output/increase_problem_size_lws_loc_tasks_600.txt" \
     using ($1):($2)/($1) \
     with linespoints title "lws-loc-tasks" ls 4 lw 2 pt -1, \
     "./output/increase_problem_size_dmdas_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdas no-limit" ls 5 lw 2 pt -1, \
     "./output/increase_problem_size_cache_oblivious_600.txt" \
     using ($1):($2)/3/($1) \
     with linespoints title "cache-oblivious" ls 6 lw 2 pt -1
