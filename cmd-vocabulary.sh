#!/usr/bin/env bash
# echo "The script you are running has basename `basename $0`, dirname `dirname $0`"
# echo "The present working directory is `pwd`"

STR=''
NL='
'
LPURPLE='\033[01;35m'
YELLOW='\033[00;33m'
RESTORE='\033[0m'

DIR="$(dirname "$(readlink -f "$0")")"
FILE=${1:-$DIR/default-vocabulary.yml}

# READ CASE
# ---------------
printVocabulary() {
    LINE=`shuf -n1 $FILE`

    # split word and translation
    IFS=':' read -ra ARRAY <<< "$LINE"
    STR="${LPURPLE}${ARRAY[0]}:${RESTORE}"

    IFS=';' read -ra ARRAY2 <<< "${ARRAY[1]}"

    STR="$STR${YELLOW}${ARRAY2[0]}${RESTORE}"
    for entry in "${ARRAY2[@]:1}"; do
         STR="$STR ${NL} $entry"
    done

    if [ -z ${ARRAY2[1]+x} ];
      then
        STR="$STR"
    #    STR="$STR ${NL} ––– Add your own sentence! –––"
    #    LINE_NUMBER=$(grep -Fn "${LINE}" ${FILE})
    #    echo ${LINE_NUMBER}
    fi

    echo -e "${STR}"
}

## ENTRY POINT
UPDATE=false
while getopts u option
do
 case "${option}"
 in
 u) UPDATE=true;;
 esac
done

if $UPDATE ; then
    echo 'Be careful not to fall off!'
else
    printVocabulary
fi

