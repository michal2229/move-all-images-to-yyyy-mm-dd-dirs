#!/bin/bash

jhead * > all_files_exif.exif

cameramodel=$(jhead * | grep "Camera model" | sed "s/^.*: //g")

echo "camera: "$cameramodel
