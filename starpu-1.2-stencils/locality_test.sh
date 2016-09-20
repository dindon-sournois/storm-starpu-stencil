#!/bin/bash

host="attila"
ratio=0.8
vector=3

limit_mem_list="0 200"
nbgpus_list="1 2"
iter="100"

function test_cache_oblivious() {
    cd "build-simgrid-no-fxt" || exit

    for limit_mem in $limit_mem_list ; do
        for nbgpus in $nbgpus_list ; do

            # RANDOM SCHED
            for sched in dmda lws; do
                filename=../output/perf_"$nbgpus"_"$sched"_"$limit_mem".txt
                echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
                for (( d=68 ; d<=1000; d+=96 )); do
                # for d in 100 500; do
                    problem=$(expr "$d" \* "$vector")
                    echo ; echo "starting $sched $problem"
                    completed_time=$(STARPU_HOSTNAME=$host STARPU_SCHED=$sched STARPU_NCPUS=0 STARPU_NCUDA=$nbgpus STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem ./tests/datawizard/locality --domain-size $d --vector-size $vector --iterations $iter --silent | grep "completion time" | cut -d \  -f4)
                    echo "$problem $completed_time" >> $filename
                done
            done

            # DMDAR
            sched=dmdar
            if [[ "$nbgpus" == "2" ]]; then
                betas="0.1 0.6 0.8 1 1.2 1.4 10"
            else
                betas="1"
            fi
            for beta in $betas; do
                filename=../output/perf_"$nbgpus"_"$sched"_"$limit_mem"_"$beta".txt
                echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
                for (( d=66 ; d<=966; d+=50 )); do
                # for d in 100 500; do
                    problem=$(expr "$d" \* "$vector")
                    echo ; echo "starting $sched $problem $beta"
                    completed_time=$(STARPU_HOSTNAME=$host STARPU_SCHED=$sched STARPU_NCPUS=0 STARPU_NCUDA=$nbgpus STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem STARPU_SCHED_BETA=$beta ./tests/datawizard/locality --domain-size $d --vector-size $vector --iterations $iter --silent | grep "completion time" | cut -d \  -f4)
                    echo "$problem $completed_time" >> $filename
                done
            done


            # CACHE OBLIVIOUS
            filename=../output/perf_"$nbgpus"_co_"$limit_mem".txt
            echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
            for (( d=66 ; d<=966; d+=50 )); do
            # for d in 100 500; do
                problem=$(expr "$d" \* "$vector")
                echo ; echo "starting cache oblivious $nbgpus $problem"
                completed_time=$(STARPU_HOSTNAME=$host STARPU_LIMIT_CUDA_MEM=$limit_mem ./tests/datawizard/locality --domain-size $d --vector-size $vector --silent --iterations $iter --cache-oblivious --co-nbgpus $nbgpus | grep "completion time" | cut -d \  -f4)
                echo "$problem $completed_time" >> $filename
            done
        done

        # MODULAR HEFT
        for nbgpus in 1; do
            sched=modular-heft
            filename=../output/perf_"$nbgpus"_"$sched"_"$limit_mem".txt
            echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
            for (( d=66 ; d<=966; d+=50 )); do
            # for d in 100 500; do
                problem=$(expr "$d" \* "$vector")
                echo ; echo "starting $sched $problem "
                completed_time=$(STARPU_HOSTNAME=$host STARPU_SCHED=$sched STARPU_NCPUS=0 STARPU_NCUDA=2 STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem ./tests/datawizard/locality --domain-size $d --vector-size $vector --iterations $iter --silent | grep "completion time" | cut -d \  -f4)
                echo "$problem $completed_time" >> $filename
            done
        done
    done

    cd .. > /dev/null
}

function test_load() {
    cd "build-simgrid-no-fxt" || exit

    # for limit_mem in 0; do
    for limit_mem in 200; do
        for nbgpus in 2; do
            # for load in dyn-unbalanced-load unbalanced-load regular; do
            for load in dyn-unbalanced-load; do
                for sched in dmdar; do
                    filename=../output/load_"$nbgpus"_"$sched"_"$limit_mem"_"$load".txt
                    echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
                    for (( d=66 ; d<=966; d+=50 )); do
                        problem=$(expr "$d" \* "$vector")
                        echo ; echo "starting $sched $problem $load"
                        completed_time=$(STARPU_HOSTNAME=$host STARPU_SCHED=$sched STARPU_NCPUS=0 STARPU_NCUDA=$nbgpus STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem ./tests/datawizard/locality --domain-size $d --vector-size $vector --iterations $iter --$load --silent | grep "completion time" | cut -d \  -f4)
                        echo "$completed_time"
                        echo "$problem $completed_time" >> $filename
                    done
                done

                filename=../output/load_"$nbgpus"_co_"$limit_mem"_"$load".txt
                echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
                for (( d=66 ; d<=966; d+=50 )); do
                    problem=$(expr "$d" \* "$vector")
                    echo ; echo "starting cache oblivious $nbgpus $problem $load"
                    completed_time=$(STARPU_HOSTNAME=$host STARPU_LIMIT_CUDA_MEM=$limit_mem ./tests/datawizard/locality --domain-size $d --vector-size $vector --$load --silent --iterations $iter --cache-oblivious --co-nbgpus $nbgpus | grep "completion time" | cut -d \  -f4)
                    echo "$completed_time"
                    echo "$problem $completed_time" >> $filename
                done
            done
        done
    done

    cd .. > /dev/null
}

# test_cache_oblivious
test_load
./locality_cache_oblivious.gp
unset STARPU_HOSTNAME
exit 0
