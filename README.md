# TuLotero Debian 8 Hardening

This is a modification of [debian-cis](https://github.com/ovh/debian-cis)

Modular Debian 8 security hardening scripts based on [cisecurity.org](https://www.cisecurity.org) recommendations.


```console
$ bin/hardening.sh --audit-all
[...]
hardening [INFO] Treating /opt/cis-hardening/bin/hardening/13.15_check_duplicate_gid.sh
13.15_check_duplicate_gid [INFO] Working on 13.15_check_duplicate_gid
13.15_check_duplicate_gid [INFO] Checking Configuration
13.15_check_duplicate_gid [INFO] Performing audit
13.15_check_duplicate_gid [ OK ] No duplicate GIDs
13.15_check_duplicate_gid [ OK ] Check Passed
[...]
################### SUMMARY ###################
      Total Available Checks : 191
         Total Runned Checks : 191
         Total Passed Checks : [ 170/191 ]
         Total Failed Checks : [  21/191 ]
   Enabled Checks Percentage : 100.00 %
       Conformity Percentage : 89.01 %
```

## Usage

### Configuration

Hardening scripts are in ``bin/hardening``. Each script has a corresponding
configuration file in ``etc/conf.d/[script_name].cfg``.

Each hardening script can be individually enabled from its configuration file.
For example, this is the default configuration file for ``disable_system_accounts``:

```
# Configuration for script of same name
status=disabled
# Put here your exceptions concerning admin accounts shells separated by spaces
EXCEPTIONS=""
```

``status`` parameter may take 3 values:
- ``disabled`` (do nothing): The script will not run.
- ``audit`` (RO): The script will check if any change *should* be applied.
- ``enabled`` (RW): The script will check if any change should be done and automatically apply what it can.

Global configuration is in ``etc/hardening.cfg``. This file controls the log level
as well as the backup directory. Whenever a script is instructed to edit a file, it
will create a timestamped backup in this directory.

## Disclaimer

This project is a set of tools used at TuLotero to harden our PCI-DSS compliant
infrastructure.

## Reference

- **Center for Internet Security**: https://www.cisecurity.org/
- **CIS recommendations**: https://benchmarks.cisecurity.org/downloads/show-single/index.cfm?file=debian7.100
- **OVH original scripts**: https://github.com/ovh/debian-cis

## License

3-Clause BSD
