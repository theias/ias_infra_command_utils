#!/bin/bash


base_dir=$1
max_age=$2
hide=$3

DEBUG=0

max_age_default='100'
hide_default='3'

if [[ -z "$max_age" ]]
then
	max_age="$max_age_default"
fi

if [[ -z "$hide" ]]
then
	hide="$hide_default"
fi

function echo_debug_message
{
	if [[ "$DEBUG" == '1' ]]
	then
		echo "$@"
	fi
}

function rotater_usage
{
	>&2 echo "Description - Lists all files older than 'max_age' but not 'hide' of the newest."
	>&2 echo "Usage:"
	>&2 echo "$0 base_dir [ max_age [ hide ] ]"
	>&2 echo "Where:"
	>&2 echo "base_dir - directory containing files to be removed."
	>&2 echo "max_age - age in days of the files default: $max_age"
	>&2 echo "hide - the number of files to always hide.  Default: $hide_default"
	
	exit 1
}

if [[ ! -d $base_dir ]]
then
	>&2 echo "Base dir not specified or doesn't exist."
	rotater_usage
	exit 1
fi

echo_debug_message "Base_dir: $base_dir"
echo_debug_message "Max age: $max_age" 
echo_debug_message "hide: $hide"

find "$base_dir" -type f -printf "%T+\t%p\n" \
	| sort --reverse \
	| sed -e "1,${hide}d" \
	| while read i
do
	# echo $i
	line=`echo $i | awk '{sub($1 OFS,""); print $2}'`
	# echo $line
	if test "$(find "$line" -mtime "+$max_age")"
	then
		echo "${line}"
	fi 
done
