#!/bin/bash
set -x
set -e
if [ -d /tmp/mock ]; then
    rm -rf tmp/
fi

mkdir /tmp/mock
python3.8 -m venv tmp/.venv
source tmp/.venv/bin/activate
pip install zimports

base=$(pwd)
topic="drop_mock"
if [ -f ignored-gerrit.txt ]; then
    rm -rf ignored-gerrit.txt
fi
if [ -f errors.txt ]; then
    rm -rf errors.txt
fi
touch errors.txt
if [ -f finished.txt ]; then
    rm -rf finished.txt
fi
touch done.txt
while read repo; do
    project_name=$(echo ${repo} | awk -F '/' '{print $2}')
    cd ${base}/tmp/
    git clone git@github.com:${repo}
    cd ${project_name}
    git checkout -b ${topic}
    sleep 5
    set +e
    git review -s
    if [ "$?" != "0" ]; then
        set -e
        echo ${project_name} >> ${base}/ignored-gerrit.txt
        cd ${base}
        continue
    fi
    set -e
    sleep 5
    echo $(pwd)
    if [ -f lower-constraints.txt ]; then
        sed -i --file ${base}/rules-requirements.sed lower-constraints.txt
    fi
    if [ -f test-requirements.txt ]; then
        sed -i --file ${base}/rules-requirements.sed test-requirements.txt
    fi
    if [ -f doc/requirements.txt ]; then
        sed -i --file ${base}/rules-requirements.sed doc/requirements.txt
    fi
    if [ -f requirements.txt ]; then
        sed -i --file ${base}/rules-requirements.sed requirements.txt
    fi
    find . -type f -print0 | xargs -0 sed -i --file ${base}/rules.sed

    git add .
    if [ "1" = "$(git status --short | wc -l)" ] && \
       [ ! -z "$(git status --short | grep lower-constraints)" ]; then
        git commit --file ${base}/commit_msg_simple_clean
    elif [ "2" = "$(git status --short | wc -l)" ] && \
         [ ! -z "$(git status --short | grep requirements)" ]; then
        git commit --file ${base}/commit_msg_req_constr
    else
        git commit --file ${base}/commit_msg
        #set +e
        #tox -l | grep pep8
        #if [ "$?" == "0" ]; then
        #    tox -e pep8
        #    if [ "$?" != "0" ]; then
        #        echo ${project_name} >> ${base}/errors.txt
        #    fi
        #fi
        #set -e
    fi
    git review -t ${topic}
    echo ${project_name} >> ${base}/finished.txt
    cd ${base}
done < start.txt
deactivate
