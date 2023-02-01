#!/bin/sh
# check system for zabbix integration 
# 30012023 by _

out=check_$(hostname)_$(date +%Y-%m-%d).txt
echo -e zabbix is sudo >> $out
grep zabbix /etc/sudoers >> $out 
echo -e zabbix_agent ver >> $out 
zabbix_agentd -V | grep dae >> $out
echo -e AllowKey for ver 5+ >> $out
grep AllowKey $(find /etc  -name zabbix_agentd.conf | head -n 1) | grep -v '^$\|^\s*#' >> $out
echo -e EnableRemoteCommand for ver 3+ >> $out
grep EnableRemoteCommands $(find /etc  -name zabbix_agentd.conf | head -n 1) | grep -v '^$\|^\s*#' >> $out
md5sum /root/.ssh/authorized_keys  >> $out
echo -e krasi is in /root/.ssh/authorized_keys >> $out
grep krasi /root/.ssh/authorized_keys -c >> $out
echo -e lastlog >> $out 
lastlog | grep -v Never >> $out 
echo -e samba users >> $out
pdbedit -L -v >> $out
/usr/bin/veeamconfig config export --overwrite  --file veeam_conf_$(hostname)_$(date +%Y-%m-%d).txt
veeamconfig session list --24 | grep Backup >> $out
veeamconfig session list --24 | grep Backup | awk '{ print $5 }' >> $out
echo -e nginx.conf ssl expiration date 
grep "ssl_certificate " $(find /etc -name nginx.conf | head -n 1) | grep -v '^$\|^\s*#' | awk '{ print $2 }' | sed 's/;\+$//' | xargs cat |  openssl x509 -noout -dates >> $out 
echo -e wss.pem ssl expiration date freeswitch >> $out 
cat $(fs_cli -x 'eval $${certs_dir}')/wss.pem | openssl x509 -noout -dates >> $out 
echo -e freeswitch pass >> $out 
fs_cli -x 'eval $${default_password}' >> $out 

