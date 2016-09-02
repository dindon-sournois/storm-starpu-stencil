#!/usr/bin/gnuplot
load '~/rev/build/gnuplot-palettes/paired.pal'

set terminal pdf
set key outside center top font ",12"
set xlabel "Taille (MB)"
set ylabel "Temps / Taille (MB)"

set output 'perf_gpu1_limit200.pdf'

plot \
     "./output/perf_1_co_200.txt" \
     using ($1):($2)/($1) \
     with linespoints title "cache-oblivious 1 GPU" ls 1 lw 2 pt 1, \
     "./output/perf_1_dmdar_200_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 1 GPU" ls 2 lw 2 pt 2, \
     "./output/perf_1_modular-heft_200.txt" \
     using ($1):($2)/($1) \
     with linespoints title "modular-heft 1 GPU" ls 3 lw 2 pt 3, \
     "./output/perf_1_dmda_200.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmda 1 GPU" ls 4 lw 2 pt 4, \
     "./output/perf_1_lws_200.txt" \
     using ($1):($2)/($1) \
     with linespoints title "lws 1 GPU" ls 5 lw 2 pt 5, \

set output 'perf_gpu1_limit0.pdf'

plot \
     "./output/perf_1_co_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "cache-oblivious 1 GPU" ls 1 lw 2 pt 1, \
     "./output/perf_1_dmdar_0_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 1 GPU" ls 2 lw 2 pt 2, \
     "./output/perf_1_modular-heft_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "modular-heft 1 GPU" ls 3 lw 2 pt 3, \
     "./output/perf_1_dmda_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmda 1 GPU" ls 4 lw 2 pt 4, \
     "./output/perf_1_lws_0.txt" \
     using ($1):($2)/($1) \
     with linespoints title "lws 1 GPU" ls 5 lw 2 pt 5, \

set output 'perf_gpu2_limit200.pdf'

plot \
     "./output/perf_2_co_200.txt" \
     using ($1):($2)/($1)\
     with linespoints title "cache-oblivious 2 GPU" ls 1 lw 2 pt 1, \
     "./output/perf_2_dmdar_200_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1" ls 2 lw 2 pt 2, \
     "./output/perf_2_dmda_200.txt" \
     using ($1):($2)/($1)\
     with linespoints title "dmda 2 GPU" ls 4 lw 2 pt 4, \
     "./output/perf_2_lws_200.txt" \
     using ($1):($2)/($1)\
     with linespoints title "lws 2 GPU" ls 5 lw 2 pt 5, \
     # "./output/perf_2_dmdar_200_1.2.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=1.2" ls 6 lw 2 pt -1, \
     # "./output/perf_2_dmdar_200_1.4.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=1.4" ls 7 lw 2 pt -1, \
     # "./output/perf_2_dmdar_200_0.8.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=0.8" ls 8 lw 2 pt -1, \
     # "./output/perf_2_dmdar_200_0.6.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=0.6" ls 9 lw 2 pt -1, \
     # "./output/perf_2_dmdar_200_0.1.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=0.1" ls 10 lw 2 pt -1, \
     # "./output/perf_2_dmdar_200_10.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=10" ls 11 lw 2 pt -1, \


set output 'perf_gpu2_limit0.pdf'

plot \
     "./output/perf_2_co_0.txt" \
     using ($1):($2)/($1)\
     with linespoints title "cache-oblivious 2 GPU" ls 1 lw 2 pt 1, \
     "./output/perf_2_dmdar_0_1.txt" \
     using ($1):($2)/($1) \
     with linespoints title "dmdar 2 GPU beta=1" ls 2 lw 2 pt 2, \
     "./output/perf_2_dmda_0.txt" \
     using ($1):($2)/($1)\
     with linespoints title "dmda 2 GPU" ls 4 lw 2 pt 4, \
     "./output/perf_2_lws_0.txt" \
     using ($1):($2)/($1)\
     with linespoints title "lws 2 GPU" ls 5 lw 2 pt 5, \
     # "./output/perf_2_dmdar_0_1.2.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=1.2" ls 6 lw 2 pt -1, \
     # "./output/perf_2_dmdar_0_1.4.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=1.4" ls 7 lw 2 pt -1, \
     # "./output/perf_2_dmdar_0_0.8.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=0.8" ls 8 lw 2 pt -1, \
     # "./output/perf_2_dmdar_0_0.6.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=0.6" ls 9 lw 2 pt -1, \
     # "./output/perf_2_dmdar_0_0.1.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=0.1" ls 10 lw 2 pt -1, \
     # "./output/perf_2_dmdar_0_10.txt" \
     # using ($1):($2)/($1) \
     # with linespoints title "dmdar 2 GPU beta=10" ls 11 lw 2 pt -1, \

# set output 'load_gpu2_limit0.pdf'

# plot \
#      "./output/load_2_co_0_unbalanced-load.txt" \
#      using ($1):($2)/($1)\
#      with linespoints title "cache-oblivious rep. statique" ls 1 lw 2 pt 1, \
#      "./output/load_2_dmdar_0_unbalanced-load.txt" \
#      using ($1):($2)/($1)\
#      with linespoints title "dmdar rep. statique" ls 3 lw 2 pt 1, \
#      "./output/load_2_dmdar_0_dyn-unbalanced-load.txt" \
#      using ($1):($2)/($1)\
#      with linespoints title "dmdar rep. dynamique" ls 4 lw 2 pt 3, \
#      "./output/load_2_co_0_dyn-unbalanced-load.txt" \
#      using ($1):($2)/($1)\
#      with linespoints title "cache-oblivious rep. dynamique" ls 2 lw 2 pt 3, \

# "./output/load_2_dmdar_0_regular.txt" \
# using ($1):($2)/($1)\
# with linespoints title "dmdar rep. équilibrée" ls 6 lw 2 pt 2, \
# "./output/load_2_co_0_regular.txt" \
# using ($1):($2)/($1)\
# with linespoints title "cache-oblivious rep. équilibrée" ls 5 lw 2 pt 2, \
