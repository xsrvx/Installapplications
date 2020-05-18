#!/bin/bash

# Get the logged in user
#CURRENTUSER=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
# Setup Done File
setupDone="/var/tmp/com.depnotify.provisioning.done"

#Setting some parameters
DNAPP="/Applications/Utilities/DEPNotify.app"
DNLOG="/var/tmp/depnotify.log"
DN_User=$(stat -f %Su "/dev/console")

#clearing previous command file. Just to be sure.
rm -rf $DNLOG
#creating new command file
touch $DNLOG

#Open DepNotify
sudo -u admin $DNAPP/Contents/MacOS/DEPNotify -fullScreen &

#Notification
#echo "Command: Notification: Your Mac will be autoconfigured in 5 seconds" >> $DNLOG

sleep 5

# Setup DEPNotify
echo "Command: Image: /tmp/logo.no.mission.medium.png" >> $DNLOG
echo "Command: Determinate: 4" >> $DNLOG
echo "Command: MainTitle: Welcome to Flagler County Public Schools" >> $DNLOG

#Run commands
echo "Status: Step 1" >> $DNLOG
echo 1
sleep 10

echo "Status: Step 2" >> $DNLOG
echo 2
sleep 5

echo "Status: Step 3" >> $DNLOG
echo 3
sleep 5

echo "Status: Complete" >> $DNLOG
echo "Command: Alert: Configuration done. You will need to logout to enable encryption." >> $DNLOG

# Add a logout button to enable FileVault, this will quit DEPNotify
#echo "Command: ContinueButtonLogout: Logout" >> $DNLOG
#sleep 3600
