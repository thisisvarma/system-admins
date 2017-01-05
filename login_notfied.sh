#!/bin/bash
##################################################
# Name: login-notify
# Description: Sends an email when user logs in to system.
# Script Maintainer: santhosh kumar poturaju
#
# Last Updated: Jan 5,2017
##################################################
# Mail Configuration
#
#SUBJECT="Root Login Alert:`hostname`"
#EMAIL="changeme@email.com"
###################################################
# Logging Settings
#
Logging=true; #true/false
LOG_FILE=/var/log/login.log
###################################################
# Notification Variables
#
KNOWN_IPS="127.0.0.1" # IPs you do not want to be notified about.
WHO=`w -si`
loginip=`echo $SSH_CLIENT | awk '{print $1}'`
authorized=false;
###################################################
# message Function
#
function message {
                echo "${msgheader}`hostname`"
                echo
                echo "------------: Login Info :---------------"
                echo
                echo "Login IP : $loginip"
                echo "Login User: `whoami`"
                echo "Date-Time:`date`"
                echo
                echo "------------: Logged in users :----------"
                echo
                echo "$WHO"
                }
# End message Function
###################################################
# Determine authorization, Send Email if not.
#
for ip in $KNOWN_IPS; do
        if [ "$loginip" == "$ip" ]; then
                authorized=true;
                msgheader="Authorized Login to Server: "
        fi
done
if [ ! "$authorized" == "true" ];then
        msgheader="Unauthorized Login to Server: " message | mail -s "$SUBJECT" "$EMAIL"
fi
###################################################
# Logging statment
#
if [ "$Logging" == "true" ]; then
	touch $LOG_FILE
        message >> $LOG_FILE
fi
# EOF