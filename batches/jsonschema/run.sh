#!/bin/bash
set -x
set -e
if [ -d tmp/ ]; then
    rm -rf tmp/
fi

mkdir tmp/

base=$(pwd)
while read repo; do
    project_name=$(echo ${repo} | awk -F '/' '{print $2}')
    cd tmp/
    git clone git@github.com:${repo}
    cd ${project_name}
    git checkout -b cap_jsonschema
    git review -s
    echo $(pwd)
    sed -i --file ${base}/rules.sed *.txt
    git add .
    git commit --file ${base}/commit_msg
    git review -t cap_jsonschema
    cd ${base}
done < search.txt
