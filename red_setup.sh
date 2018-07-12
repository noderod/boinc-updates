#!bin/bash

############
# BASICS
#
# Necessary packages to set-up and work with a Redis database to store job submission
############


# Requirements
# |   Ubuntu system, preferably > 16
# |   Docker installed
# |   Internet connection

# Sets up a Redis client on port 6389

apt-get update -y
apt-get install redis-server git-core -y
git clone git://github.com/nrk/predis.git
mv predis/* ./user-interface/token_data
# Sets up a redis server on port 6389, which must be open in the docker-compose.yml
redis-server --port 6389 &
# Sets up python3, needed
apt-get install python3 python3-pip python3-mysql.connector -y
# Python modules
pip3 install redis Flask Werkzeug docker

# Moves all the APIs and email commands
# Requires to be cloned inside project
mv /root/project/boinc-updates/api /root/project
mv /root/project/boinc-updates/adtd-protocol /root/project
mv /root/project/boinc-updates/email_assimilator.py /root/project
mv /root/project/boinc-updates/email2.py /root/project
mv /root/project/boinc-updates/user-interface/* /root/project/html/user
mv /root/project/boinc-updates/API_Daemon.sh  /root/project
mv /root/project/boinc-updates/bproc.sh  /root/project
mv /root/project/boinc-updates/password_credentials.sh /root/project
mv /root/project/boinc-updates/dockerhub_credentials.sh /root/project
mv /root/project/boinc-updates/idir.py /root/project
mkdir /root/project/adtd-protocol/process_files
mkdir /root/project/adtd-protocol/tasks
mkdir /results/adtdp


chmod +x /root/project/email_assimilator.py
chmod +x /root/project/api/server_checks.py
chmod +x /root/project/api/submit_known.py
chmod +x /root/project/api/reef_storage.py
chmod +x /root/project/api/MIDAS.py
chmod +x /root/project/api/webin.py
chmod +x /root/project/API_Daemon.sh
chmod +x /root/project/bproc.sh
chmod +x /root/project/html/user/token_data/create_organization.py
chmod +x /root/project/html/user/token_data/modify_org.py
chmod +x /root/project/api/factor2.py
chmod +x /root/project/api/harbour.py
chmod +x /root/project/api/allocation.py
chmod +x /root/project/idir.py
chmod +x /root/project/api/personal_area.py
chmod +x /root/project/adtd-protocol/redfile2.py
chmod +x /root/project/adtd-protocol/red_runner2.py
chmod +x /root/project/api/adtdp_common.py
chmod +x /root/project/email2.py


# Changes the document root to the sites available
# Uses @ because slashes are already present

# Adds a DocumentRoot to the approproate configuration file
sed -i "s@DocumentRoot.*@DocumentRoot /root/project/html/user/\n@"  /etc/apache2/sites-enabled/000-default.conf

# Changes the master URL to just the root
sed -i "s@<master_url>.*</master_url>@<master_url>$URL_BASE/</master_url>"*"@" /root/project/config.xml

# Restarts apache
service apache2 restart


/root/project/API_Daemon.sh -up
nohup /root/project/bproc.sh &



