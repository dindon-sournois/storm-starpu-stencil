#!/bin/bash

results=~/rev/internship/storm/starpu-1.2-stencils/where_to_check.txt
echo CREATED DIRS : > "$results"

host="attila"
ratio=0.8
vector=3

iter="200"
# limit_mem_fxt_list="0 200"
limit_mem_fxt_list="200"
domain_fxt_list="600"
nbgpus_fxt_list="1 2"

function test_cache_oblivious_details() {
    cd "build-simgrid/output" || exit

    for domain in $domain_fxt_list; do
        problem=$(expr "$domain" \* "$vector")
        for limit_mem in $limit_mem_fxt_list; do
            foldername=p"$problem"_l"$limit_mem"_i"$iter"/
            mkdir $foldername 2> /dev/null
            cd $foldername && echo $foldername >> "$results"
            echo $foldername

            for nbgpus in $nbgpus_fxt_list; do
                for sched in dmdar; do
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

            for sched in modular-heft; do
                nbgpus=1;
                targetname="$sched"_gpu"$nbgpus"/
                mkdir $targetname 2> /dev/null
                cd $targetname && echo $targetname >> "$results"
                echo "starting $sched gpu $nbgpus problem $problem iter $iter limit $limit_mem"
                STARPU_HOSTNAME=$host STARPU_NCPUS=0 STARPU_NCUDA=2 STARPU_NOPENCL=0 STARPU_LIMIT_CUDA_MEM=$limit_mem STARPU_SCHED=$sched ../../../tests/datawizard/locality --domain-size $domain --vector-size $vector --iterations $iter --silent --cfg=maxmin/precision:0.0001
                ../../../tools/starpu_fxt_tool -i /tmp/prof_file_llucido_0 -r "$ratio"
                cd .. > /dev/null
            done


            cd .. > /dev/null
        done
    done
    cd ../.. > /dev/null

}

function test_prefetch() {
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

test_cache_oblivious_details
# test_prefetch
# test_prio

unset STARPU_HOSTNAME
exit 0
