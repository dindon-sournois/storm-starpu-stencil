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
     "./output/cache_oblivious_1_dmdar_300_1.0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 1 GPU" ls 2 lw 2 pt 2, \


set output 'cache_oblivious_gpu1_limit0.pdf'
set title "Limited memory 0 MB"

plot \
     "./output/cache_oblivious_regular_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "cache-oblivious 1 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_1_dmdar_0_1.0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 1 GPU" ls 2 lw 2 pt 2, \

set output 'cache_oblivious_gpu2_limit300.pdf'
set title "Limited memory 300 MB"

plot \
     "./output/cache_oblivious_parallel-submit_300.txt" \
     using ($1):($2)/($1)\
     with linespoints title "cache-oblivious 2 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_2_dmdar_300_1.0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.0" ls 2 lw 2 pt 2, \
     "./output/cache_oblivious_2_dmdar_300_1.1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.1" ls 3 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmdar_300_1.2.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.2" ls 4 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmdar_300_1.3.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.3" ls 5 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmdar_300_1.4.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.4" ls 6 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmdar_300_1.5.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.5" ls 7 lw 2 pt 3, \


set output 'cache_oblivious_gpu2_limit0.pdf'
set title "Limited memory 0 MB"

plot \
     "./output/cache_oblivious_parallel-submit_0.txt" \
     using ($1):($2)/($1)\
     with linespoints title "cache-oblivious 2 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_2_dmdar_0_1.0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.0" ls 2 lw 2 pt 2, \
     "./output/cache_oblivious_2_dmdar_0_1.1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.1" ls 3 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmdar_0_1.2.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.2" ls 4 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmdar_0_1.3.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.3" ls 5 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmdar_0_1.4.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.4" ls 6 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmdar_0_1.5.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.5" ls 7 lw 2 pt 3, \
