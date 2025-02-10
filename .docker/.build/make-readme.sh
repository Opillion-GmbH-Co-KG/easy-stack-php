#!/bin/bash
set -e

CURRENT_DIR=$(pwd)

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 INPUT_FILES OUTPUT_FILE"
    echo "INPUT_FILES should be comma-separated (e.g., file1,file2)"
    exit 1
fi

INPUT_FILES="$1"
OUTPUT_FILE="$2"

tempFile=$(mktemp)
maxLength=0
secondColumnWidth=76

IFS=',' read -ra FILE_ARRAY <<< "$INPUT_FILES"
for file in "${FILE_ARRAY[@]}"; do
    if [[ ! -f $file ]]; then
        echo "Warning: $file does not exist. Skipping."
        continue
    fi

    grep -E '^[a-zA-Z0-9/%_-]+:' $file | grep -v 'callback' | cut -d':' -f1 | sort >> $tempFile
done

sort -u $tempFile -o $tempFile
while IFS= read -r line; do
    if [[ ${#line} -gt $maxLength ]]; then
        maxLength=${#line}
    fi
done < $tempFile

let maxLength=maxLength+7
echo -e "$OUTPUT_FILE \n"
output="|--$(printf '%0.s-' $(seq 1 $maxLength))|$(printf '%0.s-' $(seq 1 $(($secondColumnWidth+1))))|\n"
output+="| $(printf "Make Commands %*s" $(($maxLength-14)) "") | $(printf "Description %*s" $(($secondColumnWidth-12)) "")|\n"
output+="|--$(printf '%0.s-' $(seq 1 $maxLength))|$(printf '%0.s-' $(seq 1 $(($secondColumnWidth+1))))|\n"

get_translation() {
    echo $(cd $CURRENT_DIR && export TRANSLATION_KEY=$TRANSLATION_KEY; make translate)
}

for line in $(cat $tempFile); do
    export TRANSLATION_KEY="make $line"
    echo -e "\033[1;34m processing: $TRANSLATION_KEY \033[0m"
    translation=$(get_translation || exit 0)
    output+="| $(printf "%-${maxLength}s" "\`${TRANSLATION_KEY}\`") | $(printf "%-${secondColumnWidth}s" "$translation")|\n"
done

output+="|--$(printf '%0.s-' $(seq 1 $maxLength))|$(printf '%0.s-' $(seq 1 $(($secondColumnWidth+1))))|\n"
echo -e "$output" > $OUTPUT_FILE
echo -e "\n\033[1;32m$output\033[0m"
rm $tempFile
