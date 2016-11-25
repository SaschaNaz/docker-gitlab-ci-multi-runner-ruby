#!/bin/bash

/usr/bin/mysqld_safe &
$CATALINA_HOME/bin/startup.sh
/sbin/entrypoint.sh