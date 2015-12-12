#!/bin/bash

function run_test {
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

for tfile in tests/*.lam; do
    run_test ${tfile%.lam}
    rc=$?
    if [[ $rc != 0 ]]; then
        echo "Test failed:" $tfile "with code" $rc
    fi
done
