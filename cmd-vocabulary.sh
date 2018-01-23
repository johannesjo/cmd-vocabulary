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

# HELPER
getVocabName() {
    IFS=':' read -ra ARRAY <<< "$1"
    echo ${ARRAY[0]}
}

# READ CASE
# ---------------
printVocabulary() {
    LINE=`shuf -n1 $VOCAB_FILE`

    # save last line
    echo "$LINE" > $LAST_LINE_CACHE_FILE

    IFS=':' read -ra ARRAY <<< "$LINE"
    IFS=';' read -ra ARRAY2 <<< "${ARRAY[1]}"

    VOCAB=$(getVocabName $LINE)
    TRANSLATION=${ARRAY2[0]}

    STR="${LPURPLE}${VOCAB}:${RESTORE}"
    STR="$STR${YELLOW}${TRANSLATION}${RESTORE}"

    for entry in "${ARRAY2[@]:1}"; do
         STR="$STR ${NL} * $entry"
    done

    if [ -z ${ARRAY2[1]+x} ];
      then
        STR="$STR"
    #    STR="$STR ${NL} ––– Add your own sentence! –––"
    #    LINE_NUMBER=$(grep -Fn "${LINE}" ${VOCAB_FILE})
    #    echo ${LINE_NUMBER}
    fi

    echo -e "$STR" | awk '$1=$1'
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
    LAST_LINE_TEXT=$(cat $LAST_LINE_CACHE_FILE)
    NEW_TEXT="$LAST_LINE_TEXT;$UPDATE"
    VOCAB=$(getVocabName $LAST_LINE_TEXT)

    sed -i "s/$LAST_LINE_TEXT/$NEW_TEXT/g" $VOCAB_FILE

#    read -p " $VOCAB => Add \"$UPDATE\"? " -n 1 -r
#    echo
#    if [[ $REPLY =~ ^[Yy]$ ]]
#    then
#        sed -i "s/$LAST_LINE_TEXT/$NEW_TEXT/g" $VOCAB_FILE
#    fi
fi

