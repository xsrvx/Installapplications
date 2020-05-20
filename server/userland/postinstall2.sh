#!/bin/bash

#  installapplications-postflight.sh
#
#  Postinstall script for InstallApplications
#
#
#  Created by Michael Pinto
#
#  Created: 05/13/20
#  Updated: 05/18/20
#

# Redirect output to log
logfile=/var/log/postinstall.log
exec > $logfile 2>&1

# Download assets
mkdir /usr/local/.install
curl -L -o /tmp/background.jpg https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/Background.jpg
mv /tmp/background.jpg /usr/local/.install/
curl -L -o /tmp/iconoff.png https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/iconoff.png
mv /tmp/iconoff.png /usr/local/.install/
curl -L -o /tmp/iconon.png https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/iconon.png
mv /tmp/iconon.png /usr/local/.install/
curl -L -o /tmp/logo.no.mission.medium.png https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/logo.no.mission.medium.png
mv /tmp/logo.no.mission.medium.png /usr/local/.install/
curl -L -o /tmp/shaded-district-logo.png https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/shaded-district-logo.png
mv /tmp/shaded-district-logo.png /usr/local/.install/
chmod -R 755 /usr/local/.install
chown -R root:wheel /usr/local/.install

# -- write out settings for NoMAD -----------------------------
echo "writing settings for NoMAD"
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
defaults write /Library/Preferences/menu.nomad.login.ad.plist MessagePasswordChangePolicy "Minimum of eight characters, one uppercase, and one number."
defaults write /Library/Preferences/menu.nomad.login.ad.plist BackgroundImage "/usr/local/.install/background.jpg"
defaults write /Library/Preferences/menu.nomad.login.ad.plist LoginLogo "/usr/local/.install/logo.no.mission.medium.png"
defaults write /Library/Preferences/menu.nomad.login.ad.plist LoginScreen -bool true
defaults write /Library/Preferences/menu.nomad.login.ad.plist KeychainAddNoMAD -bool true
defaults write /Library/Preferences/menu.nomad.login.ad.plist KeychainCreate -bool true
