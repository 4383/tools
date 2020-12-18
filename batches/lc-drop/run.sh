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
    git checkout -b oslo_lc_drop
    echo $(pwd)
    if [ ! -z "$(grep -i .zuul.yaml -e lower-constraints)" ]; then
        git review -s
        sed -i --file ${base}/rules.sed .zuul.yaml
        git add .
        git commit --file ${base}/commit_msg
        git review -t oslo_lc_drop
    else
        echo "Ignoring ${project_name}"
    fi
    cd ${base}
done < search.txt
