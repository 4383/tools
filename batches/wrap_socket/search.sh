#!/bin/bash
base=$(pwd)
cd ~/dev/perso/beagle
source .venv/bin/activate
research_results="research_results.txt"
beagle --debug search --ignore-comments -f link 'ssl.wrap_socket' | \
    grep openstack > ${base}/${research_results}
cat ${base}/${research_results} | \
    awk -F "/" '{print $4 "/" $5}' | uniq > ${base}/start.txt
deactivate
cd -
