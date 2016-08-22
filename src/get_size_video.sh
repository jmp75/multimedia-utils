#!/bin/bash

E_BADARGS=85

function sample_usage ()
{
  echo "Usage: `basename $0` FILENAME"
}

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

function get_size()
{
  local __resultvar="$1"
  local myresult=`echo $__resultvar | sed -e 's/ /_/g'`
  echo $myresult
}

function get_duration()
{
  local fname="$1"
  local vid_duration=`ffprobe -v quiet -print_format flat -show_streams ${fname} | grep "\.0\.duration\="`
  local vid_duration=`echo $vid_duration | sed -e 's/.*.duration\=//g'`
  local vid_duration=`echo $vid_duration | sed -e 's/\"//g'`
  minutes="scale=0;
define i(x) {
    auto s
    s=scale
    scale=0
    x /= 1   /* round x down */
    scale=s
    return (x)
}
define minutes(x) {
    return (i(x) / 60)
}
scale=0; minutes($vid_duration);
"
  seconds="scale=0;
define i(x) {
    auto s
    s=scale
    scale=0
    x /= 1   /* round x down */
    scale=s
    return (x)
}
define seconds(x) {
    return (i(x) % 60)
}
scale=0; seconds($vid_duration);
"
  local min=$(echo "$minutes" | bc)
  local sec=$(echo "$seconds" | bc)
  echo "${min}:${sec}" 
}

input_file=$1
if [ -e $input_file ]; then
  vid_width=`get_width $input_file`
  vid_height=`get_height $input_file`
  vid_duration=`get_duration $input_file`
  # maybe later: ls -s --block-size=M 
  echo "$input_file: ${vid_width}x${vid_height}, duration:${vid_duration}"
  exit 0
else
  echo "File does not exist: $input_file"
  exit $E_BADARGS
fi
