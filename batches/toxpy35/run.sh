#!/bin/bash
set -x
set -e
if [ -d tmp/ ]; then
    rm -rf tmp/
fi

mkdir tmp/

base=$(pwd)
topic="drop_future_imports"
if [ -f errors.txt ]; then
    rm -rf errors.txt
fi
touch errors.txt
if [ -f finished.txt ]; then
    rm -rf finished.txt
fi
touch done.txt
while read repo; do
    cd ${base}/tmp/
    git clone git@github.com:openstack/${repo}
    cd ${project_name}
    git checkout -b ${topic}
    git review -s
    echo $(pwd)
    find . -type f -print0 | xargs -0 sed -i --file ${base}/rules.sed

    #tox -l | grep pep8
    #if [ "$?" == "0" ]; then
    #    tox -e pep8
    #    if [ "$?" != "0" ]; then
    #        echo ${project_name} >> ${base}/errors.txt
    #    fi
    #fi
    git add .
    git commit --file ${base}/commit_msg
    git review -t ${topic}
    echo ${project_name} >> ${base}/finished.txt
    cd ${base}
done < start.txt
