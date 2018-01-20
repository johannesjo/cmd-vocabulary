#!/usr/bin/env bash
# echo "The script you are running has basename `basename $0`, dirname `dirname $0`"
# echo "The present working directory is `pwd`"

STR=''
NL='
'
LPURPLE='\033[01;35m'
YELLOW='\033[00;33m'
RESTORE='\033[0m'


FILE=${1:-`dirname $0`/default-vocabulary.yml}
LINE=`shuf -n1 $FILE`

# split word and translation
IFS=':' read -ra ARRAY <<< "$LINE"
STR="${LPURPLE}${ARRAY[0]}:${RESTORE}"

IFS=';' read -ra ARRAY2 <<< "${ARRAY[1]}"

STR="$STR${YELLOW}${ARRAY2[0]}${RESTORE}"
for entry in "${ARRAY2[@]:1}"; do
     STR="$STR ${NL} $entry"
done




echo -e "${STR}"