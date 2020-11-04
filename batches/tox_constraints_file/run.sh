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
    git checkout -b tox_constraints_file
    echo $(pwd)
    if [ ! -z "$(grep -i tox.ini -e UPPER_CONSTRAINTS_FILE)" ]; then
        git review -s
        sed -i --file ${base}/rules.sed tox.ini
        git add .
        git commit --file ${base}/commit_msg
        git review -t tox_constraints_file
    else
        echo "Ignoring ${project_name}"
    fi
    cd ${base}
done < search.txt
