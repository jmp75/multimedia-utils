#!/bin/bash

E_BADARGS=85

function sample_usage ()
{
  echo "Usage: `basename $0` -i 'input*.mp4' -f ./output_folder"
}

let max_numpix=(1024*780)

function get_width()
{
  local fname="$1"
  local vid_width=`ffprobe -v quiet -print_format flat -show_streams ${fname} | grep "\.width"`
  local vid_width=`echo $vid_width | sed -e 's/.*stream.*\.width\=//g'`
  echo $vid_width
}

function get_height()
{
  local fname="$1"
  local vid_height=`ffprobe -v quiet -print_format flat -show_streams ${fname} | grep "\.height"`
  local vid_height=`echo $vid_height | sed -e 's/.*stream.*\.height\=//g'`
  echo $vid_height
}

function has_90_rotation()
{
  local fname="$1"
  local rot_ninety=`ffprobe -v quiet -print_format flat -show_streams ${fname} | grep ".*rotation.*90"`
  if [ "${rot_ninety}" != "" ]
  then
    echo "yes"
  else
    echo "no"
  fi
}

function calc_ratio()
{
  local numpix="$1"
  local target_numpix="$2"
local code="
scale=2; 
define my_ratio(tgt,n) {
    r=tgt/n
    if (r < 1) {
       return (r)
    }
    return 1
 };
my_ratio($target_numpix, $numpix)
"
  local ratio=$(echo "$code" | bc)
  echo $ratio
}

function ratio_to_even_num()
{
  local orig_numpix="$1"
  local ratio="$2"
local code="

scale=6;

define i(x) {
    auto s
    s=scale
    scale=0
    x /= 1   /* round x down */
    scale=s
    return (x)
 }

define make_even(orig_numpix,ratio) {
    r=i(orig_numpix*ratio)
    if ((r % 2) == 1) {
       return (r+1)
    }
    return r
};
scale=0; make_even($orig_numpix, $ratio)
"
# it is important to set the scale-0 above for it to work. Unclear why.
  local tgt_pix=$(echo "$code" | bc)
  echo $tgt_pix
}

function do_conversion ()
{
# https://trac.ffmpeg.org/wiki/Scaling%20%28resizing%29%20with%20ffmpeg
    input_file=$1
    echo "Processing $input_file..."
    filename=$(basename "$input_file")
    extension="${input_file##*.}"
    output_file="${filename%.*}"_resize.mp4 
    output_dir=$2
    if [ ! -e ${output_dir} ]; then
      mkdir -p ${output_dir};
    fi
    if [ -e $output_dir/$output_file ]; then
      if [ "${force_overwrite}" != "yes" ]
      then
        echo "$output_dir/$output_file already exists, and options says not to overwrite it"
        return
      fi
    fi
    local ffmpeg_write_opt="-n"
    if [ "${force_overwrite}" != "yes" ]
    then
      local ffmpeg_write_opt="-y"
    fi
    local vid_width=`get_width $input_file`
    local vid_height=`get_height $input_file` 
    #echo vid_width=$vid_width
    #echo vid_height=$vid_height
    let numpix=($vid_height * $vid_width)
    ratio=`calc_ratio $numpix $max_numpix`
    local out_vid_width=`ratio_to_even_num $vid_width $ratio`
    local out_vid_height=`ratio_to_even_num $vid_height $ratio`
    local has_rot=`has_90_rotation $input_file`
    if [ "$has_rot" == "yes" ]
    then
      echo "    NOTE: 90 degree rotation detected..."
      local tmpswap=$out_vid_width
      local out_vid_width=$out_vid_height
      local out_vid_height=$tmpswap
    fi
    echo "    ${vid_width}x${vid_height} ==> ${out_vid_width}x${out_vid_height}"
    ffmpeg -i $input_file -strict -2 $ffmpeg_write_opt -loglevel warning -vf scale=$out_vid_width:$out_vid_height $output_dir/$output_file
}

TEMP=$(getopt -o i:o:hf --long input:,output-folder:,help,force \
      -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

force_overwrite=no

while true ; do
	case "$1" in
		-i|--input) input_files=$2 ; shift 2 ;;
		-o|--output-folder) output_dir=$2 ; shift 2 ;;
		-f|--force) force_overwrite=yes ; shift 1 ;;
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


