#!/bin/bash

# If you MUST load an environment file:
# ENVIRONMENT_CONFIG_REQUIRED=1
#################################
# Include this for Bash goodness

# NOTE: This runs against the INSTALLED version of FindBin...
. /opt/IAS/lib/bash4/IAS/BashInfra/full_project_lib.sh

if [[ ! -d `get_project_whence` ]]; then
	echo "I was unable to find my whence dir.  Please check bash_lib.sh"
	exit 1
fi

#################################

write_log_start

error_log=`get_log_file_path`.$$.err

`get_bin_dir`/list_but_hide.sh "$@" 2> >(tee -a $error_log >&2) \
	| while read i
do
	write_log_informational "Removing: $i"
	rm "$i" 2> >(tee -a $error_log >&2) 
done
exit_status=${PIPESTATUS[0]}

write_log_informational "Exit status: ${exit_status}"

if [[ -s "$error_log" ]]; then
	write_log_err "Error log follows."
	cat "$error_log" | while read i
	do
		write_log_error "$i"
	done
fi

rm $error_log

write_log_end
exit $exit_status
