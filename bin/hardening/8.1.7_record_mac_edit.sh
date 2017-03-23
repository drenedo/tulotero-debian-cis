#!/bin/bash

#
# CIS Debian 7 Hardening
#

#
# 8.1.7 Record Events That Modify the System's Mandatory Access Controls (Scored)
#

set -e # One error, it's over
set -u # One variable unset, it's over

AUDIT_PARAMS='-w /etc/selinux/ -p wa -k MAC-policy'
FILE='/etc/audit/audit.rules'

# This function will be called if the script status is on enabled / audit mode
audit () {
    IFS=$'\n'
    for AUDIT_VALUE in $AUDIT_PARAMS; do
        debug "$AUDIT_VALUE should be in file $FILE"
        does_pattern_exist_in_file $FILE $AUDIT_VALUE
        if [ $FNRET != 0 ]; then
            crit "$AUDIT_VALUE is not in file $FILE"
        else
            ok "$AUDIT_VALUE is present in $FILE"
        fi
    done
}

# This function will be called if the script status is on enabled mode
apply () {
    IFS=$'\n'
    for AUDIT_VALUE in $AUDIT_PARAMS; do
        debug "$AUDIT_VALUE should be in file $FILE"
        does_pattern_exist_in_file $FILE $AUDIT_VALUE
        if [ $FNRET != 0 ]; then
            warn "$AUDIT_VALUE is not in file $FILE, adding it"
            add_end_of_file $FILE $AUDIT_VALUE
            eval $(pkill -HUP -P 1 auditd)
        else
            ok "$AUDIT_VALUE is present in $FILE"
        fi
    done
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
