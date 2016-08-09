#!/usr/bin/gnuplot
load '~/rev/build/gnuplot-palettes/paired.pal'

set terminal pdf
set key outside top center
set title  font ",15" norotate
set xlabel "Problem Size (MB)"
set ylabel "Completion time / Problem Size"

set output 'cache_oblivious_gpu1_limit300.pdf'
set title "Limited memory 300 MB"

plot \
     "./output/cache_oblivious_regular_300.txt" \
     using ($1):($2)/($1) \
     with linespoints title "cache-oblivious 1 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_1_dmdas_300.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdas 1 GPU" ls 2 lw 2 pt 2, \


set output 'cache_oblivious_gpu1_limit0.pdf'
set title "Limited memory 0 MB"

plot \
     "./output/cache_oblivious_regular_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "cache-oblivious 1 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_1_dmdas_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdas 1 GPU" ls 2 lw 2 pt 2, \

set output 'cache_oblivious_gpu2_limit300.pdf'
set title "Limited memory 300 MB"

plot \
     "./output/cache_oblivious_parallel-submit_300.txt" \
     using ($1):($2)/($1)\
     with linespoints title "cache-oblivious 2 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_2_dmdas_300.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdas 2 GPU" ls 2 lw 2 pt 2, \


set output 'cache_oblivious_gpu2_limit0.pdf'
set title "Limited memory 0 MB"

plot \
     "./output/cache_oblivious_parallel-submit_0.txt" \
     using ($1):($2)/($1)\
     with linespoints title "cache-oblivious 2 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_2_dmdas_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdas 2 GPU" ls 2 lw 2 pt 2, \
