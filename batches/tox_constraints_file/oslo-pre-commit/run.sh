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
    git checkout -b oslo-pre-commit
    git review -s
    echo $(pwd)
    set +e
    already_exist=$(grep -ri . -e "pre-commit" | grep -v '.git/')
    set -e
    if [ ! -z "${already_exist}" ]; then
        echo "pre-commit already setup... skipping"
        continue
    fi
    if [ ! -f ./tox.ini ]; then
        echo "No tox file... skipping"
        continue
    fi
    cp ${base}/.pre-commit-config.yaml .
    sed -i --file ${base}/rules.sed tox.ini
    git add .
    git commit --file ${base}/commit_msg
    tox -e pre-commit
    git review -t oslo-pre-commit
    cd ${base}
done < search.txt
