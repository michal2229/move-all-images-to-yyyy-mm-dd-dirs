#!/bin/bash

files=./images/*

jhead $files > all_files_exif.exif

cameramodel=$(jhead $files | grep "Camera model" | sed "s/^.*: //g")

echo "camera: "$cameramodel
