#!/bin/bash

# grep $1 at-jobs
norm="$(printf '\033[0m')" #returns to "normal"
bold="$(printf '\033[0;1m')" #set bold
red="$(printf '\033[0;31m')" #set red
boldred="$(printf '\033[0;1;31m')" #set bold, and set red.

REGEX=${1:-OCP}

atq | while read JOBLINE
do
  	echo "Job ID: ${JOBLINE}" | sed -e "s/.*/${boldred}&${norm}/"
        JOBID=$(echo ${JOBLINE} | awk '{print $1}')
 	OUTPUT=$(at -c $JOBID | grep ${REGEX} || echo "Job desn't match ${REGEX}.")
	echo ${OUTPUT} | sed 's/^/  /' 
	echo 
done
