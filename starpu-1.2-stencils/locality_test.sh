#!/bin/bash

results=~/rev/internship/storm/starpu-1.2-stencils/where_to_check.txt
echo CREATED DIRS : > "$results"

host="attila"
ratio=0.8
vector=3

limit_mem_list="0 100"
nbgpus_list="1 2"
iter="200"
limit_mem_fxt_list="0 100"
domain_fxt_list="400"
nbgpus_fxt_list="1 2"

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

        for (( d=116 ; d<=1000; d+=48 )); do
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

function test_cache_oblivious_details() {
    $compile > /dev/null
    cd "build-simgrid/output" || exit

    for domain in $domain_fxt_list; do
        problem=$(expr "$domain" \* "$vector")
        for limit_mem in $limit_mem_fxt_list; do
            foldername=p"$problem"_l"$limit_mem"_i"$iter"/
            mkdir $foldername 2> /dev/null
            cd $foldername && echo $foldername >> "$results"
            echo $foldername

            for nbgpus in $nbgpus_fxt_list; do
                for sched in dmdar modular-heft; do
                    targetname="$sched"_gpu"$nbgpus"/
                    mkdir $targetname 2> /dev/null
                    cd $targetname && echo $targetname >> "$results"
                    echo "starting $sched gpu $nbgpus problem $problem iter $iter limit $limit_mem"
                    STARPU_HOSTNAME=$host STARPU_NCPUS=0 STARPU_NCUDA=$nbgpus STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem STARPU_SCHED=$sched ../../../tests/datawizard/locality --domain-size $domain --vector-size $vector --iterations $iter --silent --cfg=maxmin/precision:0.0001
                    ../../../tools/starpu_fxt_tool -i /tmp/prof_file_llucido_0 -r "$ratio"
                    cd .. > /dev/null
                done

                targetname=co_gpu"$nbgpus"/
                mkdir $targetname 2> /dev/null
                cd $targetname && echo $targetname >> "$results"
                echo "starting cache oblivious gpu $nbgpus problem $problem iter $iter limit $limit_mem"
                STARPU_HOSTNAME=$host STARPU_LIMIT_CUDA_MEM=$limit_mem ../../../tests/datawizard/locality --domain-size $domain --vector-size $vector --cache-oblivious --iterations $iter --co-nbgpus $nbgpus --silent --cfg=maxmin/precision:0.0001
                ../../../tools/starpu_fxt_tool -i /tmp/prof_file_llucido_0 -r "$ratio"
                cd .. > /dev/null
            done

            cd .. > /dev/null
        done
    done
    cd ../.. > /dev/null

}

function test_prefetch() {
    $compile > /dev/null
    cd "build-simgrid/output" || exit

    for domain in $domain_fxt_list; do
        problem=$(expr "$domain" \* "$vector")
        for limit_mem in $limit_mem_fxt_list; do
            foldername=p"$problem"_l"$limit_mem"_i"$iter"/
            mkdir $foldername 2> /dev/null
            cd $foldername && echo $foldername >> "$results"
            for opt in regular prefetch-data; do
                echo ; echo "starting dmdar gpu 2 problem $problem iter $iter limit $limit_mem $opt"
                targetname=dmdar_gpu2_"$opt"/
                mkdir $targetname 2> /dev/null
                cd $targetname && echo $targetname >> "$results"

                STARPU_HOSTNAME=$host STARPU_SCHED=dmdar STARPU_NCPUS=0 STARPU_NCUDA=2 STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem ../../../tests/datawizard/locality --domain-size $domain --vector-size $vector --silent --iterations $iter --$opt --cfg=maxmin/precision:0.0001
                ../../../tools/starpu_fxt_tool -i /tmp/prof_file_llucido_0 -r "$ratio"

                cd .. > /dev/null
            done
            cd .. > /dev/null
        done
    done
    cd ../.. > /dev/null
}

function test_prio() {
    $compile > /dev/null
    cd "build-simgrid/output" || exit

    for domain in $domain_fxt_list; do
        problem=$(expr "$domain" \* "$vector")
        for limit_mem in $limit_mem_fxt_list; do
            foldername=p"$problem"_l"$limit_mem"_i"$iter"/
            mkdir $foldername 2> /dev/null
            cd $foldername && echo $foldername >> "$results"
            for nbcpus in 1 2 4; do
                for sched in prio; do
                    echo ; echo "starting $sched cpu $nbcpus problem $problem iter $iter limit $limit_mem"
                    targetname="$sched"_cpu"$nbcpus"/
                    mkdir $targetname 2> /dev/null
                    cd $targetname && echo $targetname >> "$results"

                    STARPU_HOSTNAME=$host STARPU_SCHED=$sched STARPU_NCPUS=$nbcpus STARPU_MIN_PRIO=0 STARPU_MAX_PRIO=$iter STARPU_NCUDA=0 STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem ../../../tests/datawizard/locality --domain-size $domain --vector-size $vector --silent --iterations $iter --priority-submit --cfg=maxmin/precision:0.0001
                    ../../../tools/starpu_fxt_tool -i /tmp/prof_file_llucido_0 -r "$ratio" -colorize-cpus

                    cd .. > /dev/null
                done
            done
            cd .. > /dev/null
        done
    done
    cd ../.. > /dev/null
}

test_cache_oblivious && ./locality_cache_oblivious.gp
test_cache_oblivious_details
test_prefetch
test_prio

unset STARPU_HOSTNAME
exit 0
