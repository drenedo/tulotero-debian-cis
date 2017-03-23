#!/bin/bash

#
# CIS Debian 7 Hardening
#

#
# 9.2.3 Check fail2ban
#

PACKAGE='fail2ban'
PATTERN='^bantime[:space:]*=[:space:]*86400'
FILE='/etc/fail2ban/jail.conf'

# This function will be called if the script status is on enabled / audit mode
audit () {
    is_pkg_installed $PACKAGE
    if [ $FNRET != 0 ]; then
        crit "$PACKAGE is not installed!"
    else
        ok "$PACKAGE is installed"
        does_pattern_exist_in_file $FILE $PATTERN
        if [ $FNRET = 0 ]; then
            ok "$PATTERN is present in $FILE"
        else
            crit "$PATTERN is not present in $FILE"
        fi
    fi
}

# This function will be called if the script status is on enabled mode
apply () {
    is_pkg_installed $PACKAGE
    if [ $FNRET = 0 ]; then
        ok "$PACKAGE is installed"
    else
        crit "$PACKAGE is absent, installing it"
        apt_install $PACKAGE
    fi
    does_pattern_exist_in_file $FILE $PATTERN
    if [ $FNRET = 0 ]; then
        ok "$PATTERN is present in $FILE"
    else
        crit "$PATTERN is not present in $FILE"
        add_line_file_before_pattern $FILE "password    requisite           pam_cracklib.so retry=3 minlen=8 difok=3" "# pam-auth-update(8) for details."
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
