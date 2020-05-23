#!/bin/bash

#  assets.sh
#
#  Install assets during enrollment
#
#
#  Created by Michael Pinto
#
#  Created: 05/23/20
#  Updated: 05/23/20
#

# Create install folder
mkdir /usr/local/.install
# Download assets and move to install folder
curl -L -o /tmp/background.jpg https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/Background.jpg
mv /tmp/background.jpg /usr/local/.install/
curl -L -o /tmp/iconoff.png https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/iconoff.png
mv /tmp/iconoff.png /usr/local/.install/
curl -L -o /tmp/iconon.png https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/iconon.png
mv /tmp/iconon.png /usr/local/.install/
curl -L -o /tmp/logo.no.mission.medium.png https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/logo.no.mission.medium.png
mv /tmp/logo.no.mission.medium.png /usr/local/.install/
curl -L -o /tmp/postinstall.sh https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/postinstall.sh
mv /tmp/postinstall.sh /usr/local/.install/postinstall.sh
curl -L -o /tmp/shaded-district-logo.png https://raw.githubusercontent.com/xsrvx/Installapplications/master/assets/shaded-district-logo.png
mv /tmp/shaded-district-logo.png /usr/local/.install/
# Apply permissions
chmod -R 755 /usr/local/.install
chown -R root:wheel /usr/local/.install
