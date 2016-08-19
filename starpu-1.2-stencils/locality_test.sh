#!/bin/bash

host="attila"
ratio=0.8
export STARPU_HOSTNAME=$host

if [ "$1" == "make" ]
then
    compile="make -j4"
else
    compile=""
fi

# logs=~/rev/internship/storm/starpu-1.2-stencils/locality_logs.txt
# rm $logs

function locality() {
    d="build-simgrid$1"
    cd "$d"
    echo "$d"
    $compile > /dev/null
    sched="`cat sched.txt`"
    for i in $sched
    do
        echo "$i"
        STARPU_SCHED=$i ./tests/datawizard/locality --domain-size 100 > /dev/null
        ./tools/starpu_fxt_tool -r "$ratio" -i /tmp/prof_file_llucido_0 > /dev/null
        mv locality.xpm ../output/locality_"$host"_"$i$1".xpm
        mv paje.trace ../output/paje_"$host"_"$i$1".trace
    done
    cd - > /dev/null
}

function test_all_xpm() {
    locality ""
    locality "_LOCALITY"
    locality "_LOCALITY_TASKS"
    locality "_BOTH"
}

function test_limit_mem() {
    $compile > /dev/null
    cd "build-simgrid-no-fxt"
    # NOTE: real maxmem = 8294 MB (2833 * 3)
    maxmem=2850
    domain=500
    vector=3
    problem_size=`expr $domain \* $vector`
    sched=dmdar
    filename=../output/limit_gpu_mem_"$sched"_"$domain"x"$vector".txt
    echo $filename
    export STARPU_SCHED=$sched
    echo "# MEM_PER_NODE (MB) COMPLETION_TIME (ms)" > $filename

    for (( m=1500 ; m>0 ; m-=50 ))
    do
        echo $m
        completed_time=`STARPU_LIMIT_OPENCL_MEM=$m STARPU_LIMIT_CUDA_MEM=$m \
        ./tests/datawizard/locality \
        --domain-size $domain \
        --vector-size $vector \
        --alternate-submit \
        --silent \
        | grep "completion time" | cut -d \  -f4`
        echo "$m $completed_time" >> $filename
    done
    cd - > /dev/null
    unset STARPU_SCHED
}

function test_increase_problem_size() {
    $compile > /dev/null
    cd "build-simgrid-no-fxt"
    # NOTE: real maxmem = 8294 MB (2833 * 3)
    limit_mem=600
    vector=3
    sched=dmdar
    filename=../output/increase_problem_size_"$sched"_"alternate"_"$limit_mem".txt
    export STARPU_SCHED=$sched
    echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename

    for (( d=200 ; d<=3333; d+=274 ))
    do
        problem_size=`expr $d \* $vector`
        completed_time=`STARPU_LIMIT_OPENCL_MEM=$limit_mem STARPU_LIMIT_CUDA_MEM=$limit_mem \
        ./tests/datawizard/locality \
        --domain-size $d \
        --vector-size $vector \
        --alternate-submit \
        --silent \
        | grep "completion time" | cut -d \  -f4`
        echo "$problem_size $completed_time" >> $filename
    done
    cd - > /dev/null
    unset STARPU_SCHED
}

function test_cache_oblivious() {
    $compile > /dev/null
    cd "build-simgrid-no-fxt"
    vector=3

    for limit_mem in 0 300; do
    # for limit_mem in 0 ; do

        for nbgpus in 1 2; do
        # for nbgpus in 2; do
            for sched in dmdar; do
                for (( beta=0 ; beta <= 5 ; beta+=1 )); do
                    filename=../output/cache_oblivious_"$nbgpus"_"$sched"_"$limit_mem"_1."$beta".txt
                    echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
                done
            done
        done
        for opt in regular parallel-submit; do
            filename=../output/cache_oblivious_"$opt"_"$limit_mem".txt
            echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename
        done

        for (( d=20 ; d<=1000; d+=48 )); do
            problem_size=`expr $d \* $vector`
            for nbgpus in 1 2; do
            # for nbgpus in 2; do
                for sched in dmdar; do
                    for (( beta=0 ; beta <= 5 ; beta+=1 )); do
                        echo ; echo "starting $sched domain=$d beta=1.$beta"
                        export STARPU_SCHED=$sched
                        completed_time=`STARPU_NCPUS=0 STARPU_NCUDA=$nbgpus STARPU_NOPENCL=0 \
                                    STARPU_LIMIT_CUDA_MEM=$limit_mem \
                                    STARPU_SCHED_BETA=1.$beta \
                                    ./tests/datawizard/locality \
                                    --domain-size $d \
                                    --vector-size $vector \
                                    --alternate-submit \
                                    --silent \
                                    | grep "completion time" | cut -d \  -f4`
                        filename=../output/cache_oblivious_"$nbgpus"_"$sched"_"$limit_mem"_1."$beta".txt
                        echo "$problem_size $completed_time" >> $filename
                    done
                done
            done

            for opt in regular parallel-submit; do
                echo ; echo "starting cache oblivious $opt $d"
                completed_time=`STARPU_LIMIT_CUDA_MEM=$limit_mem \
                                 ./tests/datawizard/locality \
                                 --domain-size $d \
                                 --vector-size $vector \
                                 --silent \
                                 --alternate-submit \
                                 --cache-oblivious \
                                 --$opt \
                                 | grep "completion time" | cut -d \  -f4`
                filename=../output/cache_oblivious_"$opt"_"$limit_mem".txt
                echo "$problem_size $completed_time" >> $filename
            done
        done
    done

    cd .. > /dev/null
    unset STARPU_SCHED
}

function test_cache_oblivious_details() {
    $compile > /dev/null
    cd "build-simgrid/output"
    vector=3
    iterations=50

    for domain in 68 500; do
        for limit_mem in 0 100; do
            foldername=d"$domain"_l"$limit_mem"_i"$iterations"/
            mkdir $foldername 2> /dev/null
            cd $foldername
            echo $foldername

            for nbgpus in 1 2; do
                for sched in dmdar; do
                    targetname="$sched"_"$nbgpus"/
                    mkdir $targetname 2> /dev/null
                    cd $targetname
                    echo "starting $sched gpu $nbgpus domain $domain iter $iterations limit $limit_mem $opt"
                    STARPU_NCPUS=0 STARPU_NCUDA=$nbgpus STARPU_NOPENCL=0 \
                                STARPU_LIMIT_CUDA_MEM=$limit_mem STARPU_SCHED=$sched \
                                ../../../tests/datawizard/locality \
                                --domain-size $domain \
                                --vector-size $vector \
                                --alternate-submit \
                                --silent
                    ../../../tools/starpu_fxt_tool -i /tmp/prof_file_llucido_0 -r 0.8
                    cd .. > /dev/null
                done
            done

            for opt in regular parallel-submit; do
                targetname=co_"$opt"/
                mkdir $targetname 2> /dev/null
                cd $targetname
                echo "starting cache oblivious $opt domain $domain iter $iterations limit $limit_mem $opt"
                STARPU_LIMIT_CUDA_MEM=$limit_mem \
                                     ../../../tests/datawizard/locality \
                                     --domain-size $domain \
                                     --vector-size $vector \
                                     --alternate-submit \
                                     --cache-oblivious \
                                     --$opt \
                                     --silent
                ../../../tools/starpu_fxt_tool -i /tmp/prof_file_llucido_0 -r 0.8
                cd .. > /dev/null
            done

            cd .. > /dev/null
        done
    done
    cd ../.. > /dev/null

}

function test_prefetch() {
    $compile > /dev/null
    cd "build-simgrid/output"
    vector=3
    iterations=200

    # for domain in 400 1334; do
    for domain in 400; do
        for limit_mem in 0 100; do
            foldername=d"$domain"_l"$limit_mem"_i"$iterations"/
            mkdir $foldername 2> /dev/null
            cd $foldername
            for opt in regular prefetch-data; do
                echo ; echo "starting dmdar gpu 2 domain $domain iter $iterations limit $limit_mem $opt"
                targetname=dmdar_gpu2_"$opt"/
                mkdir $targetname 2> /dev/null
                cd $targetname

                STARPU_SCHED=dmdar STARPU_HOSTNAME=attila STARPU_NCPUS=0 \
                            STARPU_NCUDA=2 STARPU_NOPENCL=0 \
                            STARPU_LIMIT_CUDA_MEM=$limit_mem \
                            ../../../tests/datawizard/locality \
                            --domain-size $domain \
                            --vector-size $vector \
                            --alternate-submit \
                            --silent \
                            --iterations $iterations \
                            --$opt \
                            --cfg=maxmin/precision:0.0001
                ../../../tools/starpu_fxt_tool -i /tmp/prof_file_llucido_0 -r 0.8

                cd .. > /dev/null
            done
            cd .. > /dev/null
        done
    done
    cd ../.. > /dev/null
}

# test_all_xpm
# test_limit_mem
# test_increase_problem_size
test_cache_oblivious && ./locality_cache_oblivious.gp
# test_cache_oblivious_details
test_prefetch

unset STARPU_HOSTNAME
exit 0
