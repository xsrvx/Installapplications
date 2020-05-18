#!/bin/bash
# Created by Michael Pinto
# Updated by JBrush
# 03.13.18

start() {

  # redirect output to log
  logfile=/var/log/postinstall.log
  exec > $logfile 2>&1

  # install packages
  /usr/sbin/installer -pkg /usr/local/.install/munkitools-3.6.2.3776.pkg -target /
  /usr/sbin/installer -pkg /usr/local/.install/NoMAD.pkg -target /
  /usr/sbin/installer -pkg /usr/local/.install/Spaces.and.NoMAD.pkg -target /
  /usr/sbin/installer -pkg /usr/local/.install/EFI.Firmware.pkg -target /
  /usr/sbin/installer -pkg /usr/local/.install/NoMAD-Login-AD.pkg -target /
  /usr/sbin/installer -pkg /usr/local/.install/com.mosyle.macos.manager.native.pkg -target /

  # devices
  wservice=`/usr/sbin/networksetup -listallnetworkservices | grep -Ei '(Wi-Fi|Airport)'`
  device=`/usr/sbin/networksetup -listallhardwareports | awk "/$wservice/,/Ethernet Address/" | awk 'NR==2' | cut -d " " -f 2`

  # Disable root login by setting root's shell to /usr/bin/false
  # To revert it back to /bin/sh, run the following command:
  # /usr/bin/dscl . -change /Users/root UserShell /usr/bin/false /bin/sh
  /usr/bin/dscl . -create /Users/root UserShell /usr/bin/false

  ################################################################
  # Disable Time Machine's pop-up message whenever an external drive is plugged in
  echo "Disabling Time Machine for new disks..."
  /usr/bin/defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  ################################################################
  # Set the ability to  view additional system info at the Login window
  echo "Enable additional info at login window..."
  defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

  ################################################################
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

  ################################################################
  # Make a symbolic link from /System/Library/CoreServices/Applications/Network Utility.app
  # to /Applications/Utilities so that Network Utility.app is easier to access.
  if [[ ! -e "/Applications/Utilities/Network Utility.app" ]]; then
    ln -s "/System/Library/CoreServices/Applications/Network Utility.app" "/Applications/Utilities/Network Utility.app"
  fi

  if [[ -L "/Applications/Utilities/Network Utility.app" ]]; then
    rm "/Applications/Utilities/Network Utility.app"
    ln -s "/System/Library/CoreServices/Applications/Network Utility.app" "/Applications/Utilities/Network Utility.app"
  fi

  ################################################################
  # Make a symbolic link from /System/Library/CoreServices/Screen Sharing.app
  # to /Applications/Utilities so that Screen Sharing.app is easier to access.
  if [[ ! -e "/Applications/Utilities/Screen Sharing.app" ]]; then
    ln -s "/System/Library/CoreServices/Applications/Screen Sharing.app" "/Applications/Utilities/Screen Sharing.app"
  fi

  if [[ -L "/Applications/Utilities/Screen Sharing.app" ]]; then
    rm "/Applications/Utilities/Screen Sharing.app"
    ln -s "/System/Library/CoreServices/Applications/Screen Sharing.app" "/Applications/Utilities/Screen Sharing.app"
  fi

  ################################################################
  # Require user/pass for login window
  echo "Requiring Username and Password at login window..."
  /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

  ################################################################
  # Disable external accounts (i.e. accounts stored on drives other than the boot drive.)
  echo "Disabling external accounts..."
  defaults write /Library/Preferences/com.apple.loginwindow EnableExternalAccounts -bool false

  ################################################################
  # Disable allow known servers notificaiton at login
  echo "Disable known servers notification..."
  defaults write /Library/Preferences/com.apple.NetworkAuthorization AllowUnknownServers -bool YES

  ################################################################
  # Sets the "Show scroll bars" setting (in System Preferences: General)
  # to "Always" in your Mac's default user template and for all existing users.
  # Code adapted from DeployStudio's rc130 ds_finalize script, where it's
  # disabling the iCloud and gestures demos

  # Checks the system default user template for the presence of
  # the Library/Preferences directory. If the directory is not found,
  # it is created and then the "Show scroll bars" setting (in System
  # Preferences: General) is set to "Always".
  echo "Enabling persistent scroll bars..."
  for USER_TEMPLATE in "/System/Library/User Template"/*
    do
      if [ ! -d "${USER_TEMPLATE}"/Library/Preferences ]
      then
        /bin/mkdir -p "${USER_TEMPLATE}"/Library/Preferences
      fi
      if [ ! -d "${USER_TEMPLATE}"/Library/Preferences/ByHost ]
      then
        /bin/mkdir -p "${USER_TEMPLATE}"/Library/Preferences/ByHost
      fi
      if [ -d "${USER_TEMPLATE}"/Library/Preferences/ByHost ]
      then
        /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/.GlobalPreferences AppleShowScrollBars -string Always
      fi
    done

  # Checks the existing user folders in /Users for the presence of
  # the Library/Preferences directory. If the directory is not found,
  # it is created and then the "Show scroll bars" setting (in System
  # Preferences: General) is set to "Always".
  for USER_HOME in /Users/*
    do
      USER_UID=`basename "${USER_HOME}"`
      if [ ! "${USER_UID}" = "Shared" ]
      then
        if [ ! -d "${USER_HOME}"/Library/Preferences ]
        then
          /bin/mkdir -p "${USER_HOME}"/Library/Preferences
          /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library
          /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
        fi
      if [ ! -d "${USER_HOME}"/Library/Preferences/ByHost ]
      then
        /bin/mkdir -p "${USER_HOME}"/Library/Preferences/ByHost
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/ByHost
      fi
      if [ -d "${USER_HOME}"/Library/Preferences/ByHost ]
      then
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/.GlobalPreferences AppleShowScrollBars -string Always
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/.GlobalPreferences.*
      fi
      fi
  done


  # Determine OS version and build version
  # as part of the following actions to disable
  # the iCloud and Diagnostic pop-up windows
  echo "Disabling iCloud on first login..."
  osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
  sw_vers=$(sw_vers -productVersion)
  sw_build=$(sw_vers -buildVersion)

  # Checks first to see if the Mac is running 10.7.0 or higher.
  # If so, the script checks the system default user template
  # for the presence of the Library/Preferences directory. Once
  # found, the iCloud, Diagnostic and Siri pop-up settings are set
  # to be disabled.
  if [[ ${osvers} -ge 7 ]]; then

  for USER_TEMPLATE in "/System/Library/User Template"/*
    do
      /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool true
      /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
      /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
      /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
      /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
    done

  # Checks first to see if the Mac is running 10.7.0 or higher.
  # If so, the script checks the existing user folders in /Users
  # for the presence of the Library/Preferences directory.
  #
  # If the directory is not found, it is created and then the
  # iCloud, Diagnostic and Siri pop-up settings are set to be disabled.
  for USER_HOME in /Users/*
    do
      USER_UID=`basename "${USER_HOME}"`
      if [ ! "${USER_UID}" = "Shared" ]
      then
        if [ ! -d "${USER_HOME}"/Library/Preferences ]
        then
          /bin/mkdir -p "${USER_HOME}"/Library/Preferences
          /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library
          /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
        fi
        if [ -d "${USER_HOME}"/Library/Preferences ]
        then
          /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool true
          /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
          /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
          /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
          /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
          /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant.plist
        fi
      fi
    done
  fi

  # Set whether you want to send diagnostic info back to
  # Apple and/or third party app developers.
  SUBMIT_DIAGNOSTIC_DATA_TO_APPLE=FALSE
  SUBMIT_DIAGNOSTIC_DATA_TO_APP_DEVELOPERS=FALSE

  if [[ ${osvers} -eq 10 ]]; then
    VERSIONNUMBER=4
  elif [[ ${osvers} -ge 11 ]]; then
    VERSIONNUMBER=5
  fi

  # Checks first to see if the Mac is running 10.10.0 or higher.
  # If so, the desired diagnostic submission settings are applied.
  if [[ ${osvers} -ge 10 ]]; then
    CRASHREPORTER_SUPPORT="/Library/Application Support/CrashReporter"

    if [ ! -d "${CRASHREPORTER_SUPPORT}" ]; then
      /bin/mkdir "${CRASHREPORTER_SUPPORT}"
      /bin/chmod 775 "${CRASHREPORTER_SUPPORT}"
      /usr/sbin/chown root:admin "${CRASHREPORTER_SUPPORT}"
    fi

    /usr/bin/defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory AutoSubmit -boolean ${SUBMIT_DIAGNOSTIC_DATA_TO_APPLE}
    /usr/bin/defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory AutoSubmitVersion -int ${VERSIONNUMBER}
    /usr/bin/defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory ThirdPartyDataSubmit -boolean ${SUBMIT_DIAGNOSTIC_DATA_TO_APP_DEVELOPERS}
    /usr/bin/defaults write "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory ThirdPartyDataSubmitVersion -int ${VERSIONNUMBER}
    /bin/chmod a+r "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory.plist
    /usr/sbin/chown root:admin "$CRASHREPORTER_SUPPORT"/DiagnosticMessagesHistory.plist

  fi

  # printing for standard users
  echo "Allowing standard users to add printers..."
  /usr/sbin/dseditgroup -o edit -a "everyone" -t group lpadmin

  # enable SSH for admin
  echo "Enabling SSH for admin accounts..."
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

  # delete Sites and Public from the User Template
  find /System/Library/User\ Template -type d -maxdepth 2 -name Sites -delete
  find /System/Library/User\ Template -type d -maxdepth 2 -name Public -delete

  # Serial Number
  serial=$(/usr/sbin/system_profiler SPHardwareDataType | awk '/Serial/ { print $NF }')

  # Search for device
  searchSerial=$(curl -s 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQXFekbnWYr3yFGNAU-EyFA2UT8pJMq6wez444KZjX2Vfkp7BRWgu_HkRQL8XXStdSVkkLHlsubuCvV/pub?output=csv' | grep "$serial" | awk -F "," '{print $2}'| tr -d '\r')

  if [[ $searchSerial == "" ]]; then
    echo "Device not found in sheet, using serial for name..."
    scutil --set ComputerName "$serial"
    scutil --set LocalHostName "$serial"
    scutil --set HostName "$serial"
  else
    echo "Device found in sheet, writing name..."
    scutil --set ComputerName "$searchSerial"
    scutil --set LocalHostName "$searchSerial"
    scutil --set HostName "$searchSerial"
  fi

  computer_name=$(/usr/sbin/scutil --get ComputerName | awk '{print toupper($0,1,3)}' | cut -c 1-2)

  # Munki server address
  case "$computer_name" in
    MH) # Matanzas
      repo="munki2.flaglerschools.com"
      ;;
    BL) # Belle Terre
      repo="munkielm.flaglerschools.com"
      ;;
    IT) # Indian Trails
      repo="munkimid.flaglerschools.com"
      ;;
    WE) # Wadsworth
      repo="munkielm.flaglerschools.com"
      ;;
    BT) # Buddy Taylor
      repo="munkimid.flaglerschools.com"
      ;;
    RF) # Rymfire
      repo="munkielm.flaglerschools.com"
      ;;
    BE) # Bunnell
      repo="munkielm.flaglerschools.com"
      ;;
    FP) # Flagler Palm Coast
      repo="munki.flaglerschools.com"
      ;;
    OK) # Old Kings
      repo="munkielm.flaglerschools.com"
      ;;
    IF) # iFlagler
      repo="munki2.flaglerschools.com"
      ;;
    *) # The rest
      repo="munki.flaglerschools.com"
      ;;
  esac

  munki_server="https://${repo}/munki_repo/"

  # -- write out settings for Munki -----------------------------
  echo "writing settings for Munki"
  defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL "${munki_server}"
  defaults write /Library/Preferences/ManagedInstalls SuppressUserNotification -bool true
  defaults write /Library/Preferences/ManagedInstalls.plist AdditionalHttpHeaders -array "Authorization: Basic bXVua2k6d2ludGVyaXNjb21pbmcxMQ=="

  # kick off munki
  echo "Checking in with Munki to get pending updates..."
  /usr/local/munki/managedsoftwareupdate

  echo "Installing pending updates..."
  /usr/local/munki/managedsoftwareupdate --installonly

  # -- write out settings for NoMAD -----------------------------
  echo "writing settings for NoMAD"
  defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist ADDomain "flaglercps.net"
  defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist DontShowWelcome 1
  defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist HideHelp 1
  defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist HidePrefs 1
  defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist HideQuit 1
  defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist HideSignOut 1
  defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist IconOff "/Applications/NoMAD.app/Contents/MacOS/iconoff.png"
  defaults write /Library/Preferences/com.trusourcelabs.NoMAD.plist IconOn "/Applications/NoMAD.app/Contents/MacOS/iconon.png"
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
  defaults write /Library/Preferences/menu.nomad.login.ad.plist BackgroundImage "/usr/local/.install/Background.jpg"
  defaults write /Library/Preferences/menu.nomad.login.ad.plist LoginLogo "/usr/local/.install/logo.no.mission.medium.png"
  defaults write /Library/Preferences/menu.nomad.login.ad.plist LoginScreen -bool true
  defaults write /Library/Preferences/menu.nomad.login.ad.plist KeychainAddNoMAD -bool true
  defaults write /Library/Preferences/menu.nomad.login.ad.plist KeychainCreate -bool true


  # -- write out settings for Securly -----------------------------
  # Detects all network hardware & creates services for all installed network hardware

  autoProxyURL="https://useast-www.securly.com/smart.pac?fid=chandler.bing@flaglerschools.com"
  
  echo "Detecting network hardware..."
  /usr/sbin/networksetup -detectnewhardware

  IFS=$'\n'

  # Loops through the list of network services
  for i in $(/usr/sbin/networksetup -listallnetworkservices | tail +2 );

    do

      autoProxyURLLocal=$(/usr/sbin/networksetup -getautoproxyurl "$i" | head -1 | cut -c 6-)
      
      # Enable AutoProxyURL for Securly
      /usr/sbin/networksetup -setautoproxyurl "$i" "$autoProxyURL"
      /usr/sbin/networksetup -setproxybypassdomains "$i" *.local 169.254/16 munki.flaglerschools.com munki2.flaglerschools.com munkimid.flaglerschools.com munkielm.flaglerschools.com

      echo "Enabling AutoProxyURL for $i..."
      networksetup -setautoproxystate "$i" on
      networksetup -setv6off "$i"

    done

  echo "Flushing DNS..."
  Killall -HUP mDNSResponder

  unset IFS

  # -- write out LaunchDaemon for wifihelper -----------------------------
  cat >/Library/LaunchDaemons/net.flaglercps.wifihelper.plist <<EOL
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
      <key>Label</key>
      <string>net.flaglercps.wifihelper</string>
      <key>ProgramArguments</key>
      <array>
          <string>/usr/local/.install/wifi.sh</string>
      </array>
      <key>WatchPaths</key>
      <array>
          <string>/Library/Preferences/SystemConfiguration</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
  </dict>  
  </plist>
EOL

  # apply permissions to LaunchDaemon
  /bin/chmod 644 /Library/LaunchDaemons/net.flaglercps.wifihelper.plist
  /usr/sbin/chown root:wheel /Library/LaunchDaemons/net.flaglercps.wifihelper.plist

  # -- finalize system  ---------------------------
  # set startup disk
  echo "Blessing system..."
  /usr/sbin/bless -mount "/Volumes/Macintosh HD" -setBoot

  # write receipt
  echo "Dropping receipt for postinstall..."
  /usr/bin/touch /usr/local/.install/postinstall

  # remove wireless mobileconfig
  /bin/rm -rf /usr/local/.install/flagler_wifi.mobileconfig

  # Restart
  /sbin/shutdown -r NOW
}

# Look for postinstall receipt
if [[ ! -e /usr/local/.install/postinstall ]]; then
	# Run postinstall
  start
else
  exit 0
fi