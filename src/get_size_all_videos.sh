#!/bin/bash

E_BADARGS=85

function sample_usage ()
{
  echo "Usage: `basename $0` DIRNAME"
}

prog=`dirname $0`/get_size_video.sh
vidpath=$1

if [ ! -e $prog ]; then
  echo "File does not exist: $prog"
  exit $E_BADARGS
fi

input_file=$1
if [ -e $input_file ]; then
  find ${vidpath} -iname "*.*4" | while read f
  do
    ~/src/github_jm/multimedia-utils/src/get_size_video.sh "$f";
  done
  exit 0
else
  echo "Directory does not exist: $input_file"
  exit $E_BADARGS
fi
