#!/bin/bash

function run_test_impl {
    a=$1
    rm -f $a.hm-aterm $a.core-aterm $a.tcrr $a.out
    cat $a.lam        | dist/build/parse-hm/parse-hm > $a.hm-aterm
    if [[ $? != 0 ]]; then return 10; fi
    cat $a.hm-aterm   | dist/build/hmcr/hmcr         > $a.core-aterm
    if [[ $? != 0 ]]; then return 11; fi
    cat $a.core-aterm | dist/build/pp-core/pp-core   > $a.tcrr
    if [[ $? != 0 ]]; then return 12; fi
    uhcr --corerunopt=printresult $a.tcrr > $a.out
    if [[ $? != 0 ]]; then return 13; fi
    diff $a.out $a.exp
    return $?
}

function run_test {
    echo Running $1...
    run_test_impl $1
    rc=$?
    if [[ $rc != 0 ]]; then
        echo Test failed: $1 with code $rc
    fi
}

if [[ $1 ]]; then
    run_test $1
else
    for tfile in tests/*.lam; do
        run_test ${tfile%.lam}
    done
fi

