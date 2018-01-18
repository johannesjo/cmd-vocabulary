#!/usr/bin/env bash
# echo "The script you are running has basename `basename $0`, dirname `dirname $0`"
# echo "The present working directory is `pwd`"
file=${1:-`dirname $0`/default-vocabulary.yml}
line=`shuf -n1 $file`
printf "$line\n"
