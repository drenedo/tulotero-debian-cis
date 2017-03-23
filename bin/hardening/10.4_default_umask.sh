#!/bin/bash

#
# CIS Debian 7 Hardening
#

#
# 10.4 Set Default umask for Users (Scored)
#

set -e # One error, it's over
set -u # One variable unset, it's over

USER='root'
PATTERN='umask 077'
FILES_TO_SEARCH='/etc/bash.bashrc /etc/profile.d/* /etc/profile'
FILE='/etc/profile.d/CIS_10.4_umask.sh'

# This function will be called if the script status is on enabled / audit mode
audit () {
    does_pattern_exist_in_file "$FILES_TO_SEARCH" "^$PATTERN"
    if [ $FNRET != 0 ]; then
        crit "$PATTERN is not present in $FILES_TO_SEARCH"
    else
        ok "$PATTERN is present in $FILES_TO_SEARCH"
    fi
}

# This function will be called if the script status is on enabled mode
apply () {
    does_pattern_exist_in_file "$FILES_TO_SEARCH" "^$PATTERN"
    if [ $FNRET != 0 ]; then
        warn "$PATTERN is not present in $FILES_TO_SEARCH"
        touch $FILE
        chmod 644 $FILE
        add_end_of_file $FILE "$PATTERN"
    else
        ok "$PATTERN is present in $FILES_TO_SEARCH"
    fi
}

# This function will check config parameters required
check_config() {
    :
}

# Source Root Dir Parameter
if [ ! -r /etc/default/cis-hardening ]; then
    echo "There is no /etc/default/cis-hardening file, cannot source CIS_ROOT_DIR variable, aborting"
    exit 128
else
    . /etc/default/cis-hardening
    if [ -z ${CIS_ROOT_DIR:-} ]; then
        echo "No CIS_ROOT_DIR variable, aborting"
        exit 128
    fi
fi 

# Main function, will call the proper functions given the configuration (audit, enabled, disabled)
if [ -r $CIS_ROOT_DIR/lib/main.sh ]; then
    . $CIS_ROOT_DIR/lib/main.sh
else
    echo "Cannot find main.sh, have you correctly defined your root directory? Current value is $CIS_ROOT_DIR in /etc/default/cis-hardening"
    exit 128
fi
