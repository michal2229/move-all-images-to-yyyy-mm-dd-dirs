#!/bin/bash


## INPUT CONFIG BEGIN
IMAGE_DIMENSION_MAX=1920
ANIMATION_DIMENSION_MAX=720
ANIMATION_INTERVAL=10
IMAGE_QUALITY_JPG_PERCENT=96

dir=$1
if [ ! "$dir" ]; then dir=.; fi
PROCESSED_FILES_DIR="$dir"/"_processed_old_todelete"
cd "$dir"
shopt -s nullglob
array=(*)
# echo "${array[@]}"

## INPUT CONFIG END


## HELPER FUNCTIONS BEGIN

function get_exif_info_by_filename() { 
    jhead "$1"
}

function get_date_yyyymmdd_by_filename() {
    jhead_info=$( get_exif_info_by_filename $1 )
    echo "$jhead_info" | grep "Date/Time" | sed -e "s/^.*: //g" -e "s/:/-/g" -e "s/ .*$//g"
} 

function install_jhead_and_imagemagick_if_not_found() {
	echo "function install_jhead_and_imagemagick_if_not_found() not implemented yet!!"
} 

function compute_burst_by_dir() {
    #burst_array=($1/*)
    #burst_array=$( ls $1 | sort -V )
    burst_array=$( ls $1 | sort -V | sed -r "s#(.*)#$1/\1#g" )
    burst_output_dir=$1/../
    burst_output_filename=$1
    # ${a[@]} - all
    convert -resize ${ANIMATION_DIMENSION_MAX}x${ANIMATION_DIMENSION_MAX} -delay $ANIMATION_INTERVAL -loop 0 ${burst_array[@]} ${burst_output_filename}.gif
	#echo "function compute_burst_by_dir( $1 ) not implemented yet!!" #| tee "./test/$1/compute_burst_by_dir.log"
}

## HELPER FUNCTIONS END


## MAIN ALGORITHM BEGIN

install_jhead_and_imagemagick_if_not_found

mkdir $PROCESSED_FILES_DIR 2>/dev/null

#for filename in "${array[@]}"; do
for index in ${!array[@]}; do
	index_next=$(expr $index + 1)

    filename=${array[$index]}
    filename_next=${array[$index_next]}

    dateyyyymmdd=$( get_date_yyyymmdd_by_filename $filename )
    dateyyyymmdd_next=$( get_date_yyyymmdd_by_filename $filename_next )

    if [ "$dateyyyymmdd" ]; then    
        
        extension="${filename##*.}"      # extension, probably JPG
	    filename_no_ext="${filename%.*}" # filename without extension
	    
        if [ $( echo $filename | grep -i BURST ) ]; then 
            burst_prefix=$( echo $filename | sed -r "s#(^.*)(_BURST)([0-9]*)(.*$)#\1\2#g" )
            burst_index=$( echo $filename | sed -r "s#(^.*)(_BURST)([0-9]*)(.*$)#\3#g" )
            filedir_new="./test/$dateyyyymmdd/$burst_prefix"
            filename_new="$filename_no_ext""-r."$extension 
            filepath_new=$filedir_new/$filename_new
            
            mkdir "./$( dirname $filepath_new )" -p 2>/dev/null
            convert "$filename" -resize ${IMAGE_DIMENSION_MAX}x${IMAGE_DIMENSION_MAX} -quality $IMAGE_QUALITY_JPG_PERCENT $filepath_new
            
            if [ $( echo $filename_next | grep -i BURST ) ]; then 
		        burst_prefix_next=$( echo $filename_next | sed -r "s#(^.*)(_BURST)([0-9]*)(.*$)#\1\2#g" )
		        burst_index_next=$( echo $filename_next | sed -r "s#(^.*)(_BURST)([0-9]*)(.*$)#\3#g" )
            	
        	    # echo "BURST DETECTED in next $burst_prefix_next - b$burst_index_next - i$index_next $ !!"
            	
            	if [ $burst_prefix = $burst_prefix_next ]; then 
            		echo "" # same prefix      -> not last
            	else
            	    # different prefix -> LAST - start compute burst (tmp, then move result to ./$dateyyyymmdd)
            	    echo "LAST BURST DETECTED in next $burst_prefix - b$burst_index - i$index $ !!"
            	    compute_burst_by_dir $filedir_new
            	fi
        	else
        	    # LAST - start compute burst (tmp, then move result to ./$dateyyyymmdd)
        		echo "LAST BURST DETECTED in $burst_prefix - b$burst_index - i$index $ !!"
        		compute_burst_by_dir $filedir_new
            fi
            
            
        else
		    filepath_new="./test/$dateyyyymmdd/$filename_no_ext""-r."$extension 
            mkdir "./$( dirname $filepath_new )" -p 2>/dev/null
		    convert "$filename" -resize ${IMAGE_DIMENSION_MAX}x${IMAGE_DIMENSION_MAX} -quality $IMAGE_QUALITY_JPG_PERCENT $filepath_new
        fi
        
        
        echo mv "$filename" $PROCESSED_FILES_DIR/
    else
        echo "$filename not jpeg, so no exif date to mkdir"
    fi

    # printf "$filepath $cameramodel $dateyyyymmdd \n"
done

## MAIN ALGORITHM END

