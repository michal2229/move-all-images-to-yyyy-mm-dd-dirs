#!/bin/bash

dir=$1

if [ ! "$dir" ]; then dir=.; fi

cd "$dir"

shopt -s nullglob
array=(*)

# echo "${array[@]}"

for filename in "${array[@]}"; do
    # cameramodel=$( jhead "$filename" | grep "Camera model" | sed "s/^.*: //g" )
    dateyyyymmdd=$( jhead "$filename" | grep "Date/Time" | sed -e "s/^.*: //g" -e "s/:/-/g" -e "s/ .*$//g"  )

    if [ "$dateyyyymmdd" ]; then
        mkdir "$dateyyyymmdd" 2>/dev/null
        # echo cp "$filename" "$dateyyyymmdd/$filename" -v
        mv "$filename" "$dateyyyymmdd/$filename"
    else
        echo "$filename has no exif, so not moved."
    fi

    # printf "$filepath $cameramodel $dateyyyymmdd \n"
done
