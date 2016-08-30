#!/usr/bin/gnuplot
load '~/rev/build/gnuplot-palettes/paired.pal'

set terminal pdf
set key outside top center
set title  font ",15" norotate
set xlabel "Problem Size (MB)"
set ylabel "Completion time / Problem Size (MB)"

set output 'cache_oblivious_gpu1_limit100.pdf'
set title "Limited memory 100 MB"

plot \
     "./output/cache_oblivious_1_100.txt" \
     using ($1):($2)/($1) \
     with linespoints title "cache-oblivious 1 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_1_dmdar_100_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 1 GPU" ls 2 lw 2 pt 2, \
     "./output/cache_oblivious_1_modular-heft_100_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "modular-heft 1 GPU" ls 5 lw 2 pt 5, \
     "./output/cache_oblivious_1_dmda_100_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmda 1 GPU" ls 3 lw 2 pt 3, \
     "./output/cache_oblivious_1_lws_100_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "lws 1 GPU" ls 4 lw 2 pt 4, \


set output 'cache_oblivious_gpu1_limit0.pdf'
set title "Limited memory 0 MB"

plot \
     "./output/cache_oblivious_1_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "cache-oblivious 1 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_1_dmdar_0_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 1 GPU" ls 2 lw 2 pt 2, \
     "./output/cache_oblivious_1_modular-heft_0_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "modular-heft 1 GPU" ls 5 lw 2 pt 5, \
     "./output/cache_oblivious_1_dmda_0_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmda 1 GPU" ls 3 lw 2 pt 3, \
     "./output/cache_oblivious_1_lws_0_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "lws 1 GPU" ls 4 lw 2 pt 4, \

set output 'cache_oblivious_gpu2_limit100.pdf'
set title "Limited memory 100 MB"

plot \
     "./output/cache_oblivious_2_100.txt" \
     using ($1):($2)/($1)\
     with linespoints title "cache-oblivious 2 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_2_dmdar_100_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1" ls 2 lw 2 pt 2, \
     "./output/cache_oblivious_2_modular-heft_100_1.txt" \
     using ($1):($2)/($1)\
     with linespoints title "modular-heft 2 GPU" ls 3 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmda_100_1.txt" \
     using ($1):($2)/($1)\
     with linespoints title "dmda 2 GPU" ls 4 lw 2 pt 4, \
     "./output/cache_oblivious_2_lws_100_1.txt" \
     using ($1):($2)/($1)\
     with linespoints title "lws 2 GPU" ls 5 lw 2 pt 5, \
     "./output/cache_oblivious_2_dmdar_100_1.2.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.2" ls 6 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_100_1.4.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.4" ls 7 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_100_0.8.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=0.8" ls 8 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_100_0.6.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=0.6" ls 9 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_100_0.1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=0.1" ls 10 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_100_10.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=10" ls 11 lw 2 pt -1, \


set output 'cache_oblivious_gpu2_limit0.pdf'
set title "Limited memory 0 MB"

plot \
     "./output/cache_oblivious_2_0.txt" \
     using ($1):($2)/($1)\
     with linespoints title "cache-oblivious 2 GPU" ls 1 lw 2 pt 1, \
     "./output/cache_oblivious_2_dmdar_0_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1" ls 2 lw 2 pt 2, \
     "./output/cache_oblivious_2_modular-heft_100_1.txt" \
     using ($1):($2)/($1)\
     with linespoints title "modular-heft 2 GPU" ls 3 lw 2 pt 3, \
     "./output/cache_oblivious_2_dmda_100_1.txt" \
     using ($1):($2)/($1)\
     with linespoints title "dmda 2 GPU" ls 4 lw 2 pt 4, \
     "./output/cache_oblivious_2_lws_100_1.txt" \
     using ($1):($2)/($1)\
     with linespoints title "lws 2 GPU" ls 5 lw 2 pt 5, \
     "./output/cache_oblivious_2_dmdar_0_1.2.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.2" ls 6 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_0_1.4.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1.4" ls 7 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_0_0.8.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=0.8" ls 8 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_0_0.6.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=0.6" ls 9 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_0_0.1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=0.1" ls 10 lw 2 pt -1, \
     "./output/cache_oblivious_2_dmdar_0_10.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=10" ls 11 lw 2 pt -1, \
