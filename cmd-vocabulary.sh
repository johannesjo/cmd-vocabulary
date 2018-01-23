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
LAST_LINE_CACHE_FILE=$DIR/.cmd-vocabulary-last-line

# READ CASE
# ---------------
printVocabulary() {
    LINE=`shuf -n1 $VOCAB_FILE`
    echo "$LINE" > $LAST_LINE_CACHE_FILE

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
    #    LINE_NUMBER=$(grep -Fn "${LINE}" ${VOCAB_FILE})
    #    echo ${LINE_NUMBER}
    fi

    echo -e "${STR}"
}

## ENTRY POINT
while getopts u:f: option
do
 case "${option}"
 in
 u) UPDATE=$OPTARG;;
 f) VOCAB_FILE=$OPTARG;;
 esac
done

if [ -z ${VOCAB_FILE+x} ]; then
    VOCAB_FILE=$DIR/default-vocabulary.yml
fi

if [ -z ${UPDATE+x} ]; then
    printVocabulary
else
    echo 'XXXXXXXXXXXXXXXXXXXXX!'
    echo $UPDATE
    echo $VOCAB_FILE
    #cat $LAST_LINE_CACHE_FILE
    echo 'XXXXXXXXXXXXXXXXXXXXX!'
fi

