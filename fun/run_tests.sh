#!/bin/bash

for a in tests/*.lam; do
    rm -f ${a%lam}tcrr ${a%lam}out
    cat $a | dist/build/parse-hm/parse-hm | dist/build/hmcr/hmcr | dist/build/pp-core/pp-core > ${a%lam}tcrr
    uhcr --corerunopt=printresult ${a%lam}tcrr > ${a%lam}out
    diff ${a%lam}out ${a%lam}exp
    rc=$?
    if [[ $rc != 0 ]]; then
        echo "Test failed:" $a
    fi
done
