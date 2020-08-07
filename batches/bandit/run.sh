#!/bin/bash
set -x
set -e
if [ -d tmp/ ]; then
    rm -rf tmp/
fi

base=$(pwd)
mkdir tmp/
cd tmp/

while read repo; do
    project_name=$(echo ${repo} | awk -F '/' '{print $2}')
    git clone https://opendev.org/${repo}
    cd ${project_name}
    git checkout -b bandit
    echo $(pwd)

    if [ ! -f ./test-requirements.txt ]; then
        echo "No test-requirements.txt file... skipping"
        cd ..
        rm -rf ${project_name}
    fi

    if grep -q '^bandit>=' test-requirements.txt
    then
        git review -s
        sed -i '' -f ${base}/rules.sed test-requirements.txt
        git add test-requirements.txt
        git commit --file ${base}/commit_msg
        git review -t bump-bandit
        cd ..
    else
        echo "No bandit in test-requirements.txt file... skipping"
        cd ..
        rm -rf ${project_name}
    fi
done < ../oslo_projects.txt
