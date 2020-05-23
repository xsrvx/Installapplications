#!/bin/bash

#  installapplications-postflight.sh
#
#  Postinstall script for InstallApplications
#
#
#  Created by Michael Pinto
#
#  Created: 05/13/20
#  Updated: 05/23/20
#

# Redirect output to log
logfile=/var/log/postinstall.log
exec > $logfile 2>&1

# Securly PAC for students
securlyPAC() {
	# -- write out settings for Securly -----------------------------
	# Detects all network hardware & creates services for all installed network hardware
	echo "Status: Enabling PAC for Securly..." >> $DNLog
	autoProxyURL="https://useast-www.securly.com/smart.pac?fid=chandler.bing@flaglerschools.com"
  
	echo "Detecting network hardware..."
	/usr/sbin/networksetup -detectnewhardware

  	IFS=$'\n'

  	# Loops through the list of network services
  	for i in $(/usr/sbin/networksetup -listallnetworkservices | tail +2 );

    do
      
      	# Enable AutoProxyURL for Securly
      	/usr/sbin/networksetup -setautoproxyurl "$i" "$autoProxyURL"
      	/usr/sbin/networksetup -setproxybypassdomains "$i" *.local 169.254/16

      	echo "Enabling AutoProxyURL for $i..."
      	networksetup -setautoproxystate "$i" on
      	networksetup -setv6off "$i"

    done

	echo "Flushing DNS..."
	Killall -HUP mDNSResponder
}

# Command file
DNLog="/var/tmp/depnotify.log"

# Set Login Window Mech
authchanger -reset -preLogin NoMADLoginAD:Notify
killall loginwindow

# Disable root login by setting root's shell to /usr/bin/false
# To revert it back to /bin/sh, run the following command:
# /usr/bin/dscl . -change /Users/root UserShell /usr/bin/false /bin/sh
/usr/bin/dscl . -create /Users/root UserShell /usr/bin/false

# Disable Time Machine's pop-up message whenever an external drive is plugged in
echo "Disabling Time Machine for new disks..."
/usr/bin/defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Make a symbolic link from /System/Library/CoreServices/Applications/Directory Utility.app
# to /Applications/Utilities so that Directory Utility.app is easier to access.
echo "Creating symlinks for Utilities..."
if [[ ! -e "/Applications/Utilities/Directory Utility.app" ]]; then
	ln -s "/System/Library/CoreServices/Applications/Directory Utility.app" "/Applications/Utilities/Directory Utility.app"
fi

if [[ -L "/Applications/Utilities/Directory Utility.app" ]]; then
	rm "/Applications/Utilities/Directory Utility.app"
    ln -s "/System/Library/CoreServices/Applications/Directory Utility.app" "/Applications/Utilities/Directory Utility.app"
fi

# Make a symbolic link from /System/Library/CoreServices/Applications/Network Utility.app
# to /Applications/Utilities so that Network Utility.app is easier to access.
if [[ ! -e "/Applications/Utilities/Network Utility.app" ]]; then
	ln -s "/System/Library/CoreServices/Applications/Network Utility.app" "/Applications/Utilities/Network Utility.app"
fi

if [[ -L "/Applications/Utilities/Network Utility.app" ]]; then
	rm "/Applications/Utilities/Network Utility.app"
    ln -s "/System/Library/CoreServices/Applications/Network Utility.app" "/Applications/Utilities/Network Utility.app"
fi

# Make a symbolic link from /System/Library/CoreServices/Screen Sharing.app
# to /Applications/Utilities so that Screen Sharing.app is easier to access.
if [[ ! -e "/Applications/Utilities/Screen Sharing.app" ]]; then
	ln -s "/System/Library/CoreServices/Applications/Screen Sharing.app" "/Applications/Utilities/Screen Sharing.app"
fi

if [[ -L "/Applications/Utilities/Screen Sharing.app" ]]; then
	rm "/Applications/Utilities/Screen Sharing.app"
    ln -s "/System/Library/CoreServices/Applications/Screen Sharing.app" "/Applications/Utilities/Screen Sharing.app"
fi

# printing for standard users
echo "Allowing standard users to add printers..."
/usr/sbin/dseditgroup -o edit -a "everyone" -t group lpadmin

# enable SSH for admin
echo "Enabling SSH for admin accounts..."
echo "Status: Applying security settings..." >> $DNLog
/usr/sbin/dseditgroup -o create -q com.apple.access_ssh
/usr/sbin/systemsetup -f setremotelogin on
/usr/sbin/dseditgroup -o edit -n /Local/Default -a admin -t user com.apple.access_ssh

# enable ARD for admin
echo "Enabling ARD for admin users..."
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -specifiedUsers
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# set time zone
echo "Setting Time Zone..."
/usr/sbin/systemsetup -settimezone "America/New_York"

# -- write out settings for NoMAD -----------------------------
echo "writing settings for NoMAD"
echo "Status: Applying settings for NoMAD..." >> $DNLog
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist ADDomain "flaglercps.net"
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist DontShowWelcome 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist HideHelp 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist HidePrefs 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist HideQuit 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist HideSignOut 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist IconOff "/usr/local/.install/iconoff.png"
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist IconOn "/usr/local/.install/iconon.png"
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist LocalPasswordSync 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist MenuGetSoftware "Install Software"
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist RenewTickets 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist SecondsToRenew 7200
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist UPCAlert 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist UseKeychain 1
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist KerberosRealm FLAGLERCPS.NET
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist PasswordPolicy "{ minLength = 8; minNumber = 1; minUpperCase = 1; }"
defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist PasswordExpireAlertTime 1296000
echo "Status: Applying settings for NoLoAD..." >> $DNLog
defaults write /Library/Preferences/menu.nomad.login.ad.plist MessagePasswordChangePolicy "Minimum of eight characters, one uppercase, and one number."
defaults write /Library/Preferences/menu.nomad.login.ad.plist BackgroundImage "/usr/local/.install/background.jpg"
defaults write /Library/Preferences/menu.nomad.login.ad.plist LoginLogo "/usr/local/.install/logo.no.mission.medium.png"
defaults write /Library/Preferences/menu.nomad.login.ad.plist LoginScreen -bool true
defaults write /Library/Preferences/menu.nomad.login.ad.plist KeychainAddNoMAD -bool true
defaults write /Library/Preferences/menu.nomad.login.ad.plist KeychainCreate -bool true


echo "Status: Complete" >> $DNLog
echo "Command: ContinueButton: Finish" >> $DNLog