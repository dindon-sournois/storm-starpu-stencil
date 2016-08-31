#!/bin/bash

results=~/rev/internship/storm/starpu-1.2-stencils/where_to_check.txt
echo CREATED DIRS : > "$results"

host="attila"
ratio=0.8
vector=3

limit_mem_list="0 150"
nbgpus_list="1 2"
iter="100"

function test_cache_oblivious() {
    $compile > /dev/null
    cd "build-simgrid-no-fxt" || exit

    for limit_mem in $limit_mem_list ; do
        for nbgpus in $nbgpus_list ; do
            for sched in dmdar modular-heft dmda lws; do
                if [[ "$nbgpus" -eq 1 ]]; then
                    betas="1"
                elif [[ "$sched" != "dmdar" ]]; then
                    betas="1"
                else
                    betas="0.1 0.6 0.8 1 1.2 1.4 10"
                fi
                for beta in $betas; do
                    filename=../output/cache_oblivious_"$nbgpus"_"$sched"_"$limit_mem"_"$beta".txt
                    echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
                done
            done
            filename=../output/cache_oblivious_"$nbgpus"_"$limit_mem".txt
            echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
        done

        for (( d=68 ; d<=1000; d+=48 )); do
            problem=$(expr "$d" \* "$vector")
            for nbgpus in $nbgpus_list; do
                for sched in dmdar modular-heft dmda lws; do
                    export STARPU_SCHED=$sched
                    if [[ "$nbgpus" -eq 1 ]]; then
                        betas="1"
                    elif [[ "$sched" != "dmdar" ]]; then
                        betas="1"
                    else
                        betas="0.1 0.6 0.8 1 1.2 1.4 10"
                    fi
                    for beta in $betas; do
                        echo ; echo "starting $sched problem=$problem beta=$beta"
                        filename=../output/cache_oblivious_"$nbgpus"_"$sched"_"$limit_mem"_"$beta".txt
                        completed_time=$(STARPU_HOSTNAME=$host STARPU_NCPUS=0 STARPU_NCUDA=$nbgpus STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem STARPU_SCHED_BETA=$beta ./tests/datawizard/locality --domain-size $d --vector-size $vector --iterations $iter --silent | grep "completion time" | cut -d \  -f4)
                        echo "$problem $completed_time" >> $filename
                    done
                done

                echo ; echo "starting cache oblivious $nbgpus $problem"
                completed_time=$(STARPU_HOSTNAME=$host STARPU_LIMIT_CUDA_MEM=$limit_mem ./tests/datawizard/locality --domain-size $d --vector-size $vector --silent --iterations $iter --cache-oblivious --co-nbgpus $nbgpus | grep "completion time" | cut -d \  -f4)
                filename=../output/cache_oblivious_"$nbgpus"_"$limit_mem".txt
                echo "$problem $completed_time" >> $filename
            done
        done
    done

    cd .. > /dev/null
    unset STARPU_SCHED
}
test_cache_oblivious && ./locality_cache_oblivious.gp

unset STARPU_HOSTNAME
exit 0
