#!/bin/bash
set -e
rm -f /run/apache2.pid
rm -f /run/apache2/apache2.pid
rm -f /var/run/apache2/apache2.pid
rsyslogd
cron -L15
ulimit -s unlimited
exec apache2 -DFOREGROUND
