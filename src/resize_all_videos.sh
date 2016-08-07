#!/bin/bash

E_BADARGS=85

function sample_usage ()
{
  echo "Usage: `basename $0` -i 'input*.mp4' -f ./output_folder"
}


function do_conversion ()
{
# https://trac.ffmpeg.org/wiki/Scaling%20%28resizing%29%20with%20ffmpeg
    input_file=$1
    filename=$(basename "$input_file")
    extension="${input_file##*.}"
    output_file="${filename%.*}"_resize.mp4 
    output_dir=$2
    if [ ! -e ${output_dir} ]; then
        mkdir -p ${output_dir};
    fi
    ffmpeg -i $input_file -strict -2 -vf scale=iw/2:ih/2 $output_dir/$output_file
}

TEMP=$(getopt -o i:f:h --long input:,output-folder:,help \
      -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
	case "$1" in
		-i|--input) input_files=$2 ; shift 2 ;;
		-f|--output-folder) output_dir=$2 ; shift 2 ;;
		-h|--help) sample_usage ; exit 0 ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done

#echo $input_files
#echo `ls $input_files`

for i in `ls $input_files` ; do 
    do_conversion $i $output_dir
done


# TODO for images in a separate script:
# for i in `ls 20*.jpg` ; do echo small_${i} ; convert $i -resize 50% small_${i} ; done

# find . -type f -name "*.mp4" -exec bash -c 'FILE="$1"; ffmpeg -i "${FILE}" -s 1280x720 -acodec copy -y "${FILE%.mp4}.shrink.mp4";' _ '{}' \;


