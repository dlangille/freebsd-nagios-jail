# freebsd-nagios-jail

Nagios checks for FreeBSD jails

I used these settings in /etc/periodic.conf:

# for security/405.pkg-base-audit
security_status_baseaudit_enable="YES"
security_status_baseaudit_jails="*"

#for 410.pkg-audit
security_status_pkgaudit_expiry=1

# for many scripts including 405 & 410
pkg_jails='*'

I install those script at:

  /usr/local/libexec/nagios-custom

I add these entries to /usr/local/etc/nrpe.cfg

$ grep audit /usr/local/etc/nrpe.cfg
command[check_pkg_audit]    =/usr/local/bin/sudo /usr/local/libexec/nagios-custom/pkg-audit.sh
command[check_base_audit]   =/usr/local/bin/sudo /usr/local/libexec/nagios-custom/pkg-base-audit.sh


I add these entries via sudo:

$ sudo grep audit /usr/local/etc/sudoers
nagios   ALL=(ALL) NOPASSWD:/usr/local/libexec/nagios-custom/pkg-audit.sh
nagios   ALL=(ALL) NOPASSWD:/usr/local/libexec/nagios-custom/pkg-base-audit.sh

These services are defined in /usr/local/etc/services.cfg

define service {
        #NAGIOSQL_CONFIG_NAME           FreeBSD_Server
        hostgroup_name                  FreeBSD Server
        service_description             base audit
        use                             remote_service_timeout
        check_command                   check_nrpe_timeout!check_base_audit!240
        check_interval                  30
        retry_interval                  5
        notification_interval           1440
        contact_groups                  admins
        register                        1
}


define service {
        #NAGIOSQL_CONFIG_NAME           FreeBSD_Server
        hostgroup_name                  FreeBSD Server
        service_description             pkg audit
        use                             remote_service_timeout
        check_command                   check_nrpe_timeout!check_pkg_audit!240
        check_interval                  30
        retry_interval                  5
        notification_interval           1440
        contact_groups                  admins
        register                        1
}
