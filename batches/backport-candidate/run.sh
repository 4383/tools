#!/bin/bash
set -x
set -e
if [ -d tmp/ ]; then
    rm -rf tmp/
fi

mkdir tmp/

base=$(pwd)
topic="oslo_backport_candidates"
if [ -f errors.txt ]; then
    rm -rf errors.txt
fi
touch errors.txt
if [ -f finished.txt ]; then
    rm -rf finished.txt
fi
touch done.txt
cd ${base}/tmp/
git clone git@github.com:openstack/project-config
cd project-config
git checkout -b ${topic}
git review -s
while read repo; do
    conf=gerrit/acls/openstack/${repo}.config
    if [ ! -f ${conf} ]; then
        continue
    fi
    sed -i --file ${base}/rules.sed ${conf}
    #git add .
    #git commit --file ${base}/commit_msg
    #git review -t ${topic}
    echo ${repo} >> ${base}/finished.txt
done < ${base}/start.txt
cd ${base}
