#!/bin/bash
if [ -d tmp/ ]; then
    rm -rf tmp/
fi

mkdir tmp/

base=$(pwd)
while read repo; do
    cd tmp/
    git clone git@github.com:${repo}
    cd ${repo}
    echo $(pwd)
    sed -i '' -f ${base}/rules.sed
    cd ${base}
done < jsonschema.search
