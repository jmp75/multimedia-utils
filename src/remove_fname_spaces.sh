#!/bin/bash

E_BADARGS=85

function sample_usage ()
{
  echo "Usage: `basename $0` FILENAME"
  echo "Note: This should be only used for short filenames, i.e. in place in the current directory"
  echo "Example: `basename $0` FILENAME"
}

function replace_spaces()
{
  local __resultvar="$1"
  local myresult=`echo $__resultvar | sed -e 's/ /_/g'`
  echo $myresult
}

#fname="Brazillian Zouk Intermediate Steps Hair Movements.webm"
fname="$1"
newfname=`replace_spaces "$fname"`

if [ "${newfname}" = "${fname}" ]
then
  echo "Nothing to do for ${fname}"
else
  echo Moving file named "${fname}" to "${newfname}"
  mv "${fname}" "${newfname}"
fi

