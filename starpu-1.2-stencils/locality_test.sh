#!/bin/bash
dirs=" build-simgrid-LOCALITY build-simgrid-LOCALITY_TASKS build-simgrid-BOTH"
host="attila"
ratio=0.8
export STARPU_HOSTNAME=$host

if [ "$1" == "make" ]
then
    compile="make -j4"
else
    compile=""
fi

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

# erreur avec :
# STARPU_HOSTNAME=attila STARPU_SCHED=dmda STARPU_LIMIT_OPENCL_MEM=500 STARPU_LIMIT_CUDA_MEM=500 ./tests/datawizard/locality --domain-size 500 --vector-size 3 > /dev/null && ./tools/starpu_fxt_tools -i /tmp/prof_llucido_0

function test_limit_mem() {
    $compile > /dev/null
    cd "build-simgrid-no-fxt"
    # NOTE: real maxmem = 8294 MB (2833 * 3)
    maxmem=2850
    domain=500
    vector=3
    problem_size=`expr $domain \* $vector`
    sched=dmdas
    filename=../output/limit_gpu_mem_"$sched"_"$domain"x"$vector".txt
    export STARPU_SCHED=$sched
    # echo "# MEM_PER_NODE (MB) COMPLETION_TIME (ms)" > $filename

    for (( m=50 ; m>0 ; m-=50 ))
    do
        echo $m
        completed_time=`STARPU_LIMIT_OPENCL_MEM=$m STARPU_LIMIT_CUDA_MEM=$m \
        ./tests/datawizard/locality \
        --domain-size $domain \
        --vector-size $vector \
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
    sched=lws
    filename=../output/increase_problem_size_"$sched"_"$limit_mem".txt
    export STARPU_SCHED=$sched
    echo "# PROBLEM_SIZE (MB) COMPLETION_TIME (ms)" > $filename

    for (( d=200 ; d<=3333; d+=274 ))
    do
        problem_size=`expr $d \* $vector`
        completed_time=`STARPU_LIMIT_OPENCL_MEM=$limit_mem STARPU_LIMIT_CUDA_MEM=$limit_mem \
        ./tests/datawizard/locality \
        --domain-size $d \
        --vector-size $vector \
        --silent \
        | grep "completion time" | cut -d \  -f4`
        echo "$problem_size $completed_time" >> $filename
    done
    cd - > /dev/null
    unset STARPU_SCHED
}

# test_all_xpm
test_limit_mem
# test_increase_problem_size

unset STARPU_HOSTNAME
exit 0
