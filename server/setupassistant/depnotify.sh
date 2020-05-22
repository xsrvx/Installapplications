
#!/bin/bash

#  depnotify.sh
#
#  DEPNotify configuration and kickoff
#
#
#  Created by Michael Pinto
#
#  Created: 05/21/20
#  Updated: 05/21/20
#

# Command file
DNLog="/var/tmp/depnotify.log"

# Remove previous DEPNotify command file if it exists
if [[ -e /var/tmp/depnotify.log ]]; then
	rm -rf $DNLog
	# create new file
	touch $DNLog
else
	# create new file
	touch $DNLog
fi

# Prepare DEPNotify
echo "Command: Image: /usr/local/.install/shaded-district-logo.png" >> $DNLog
echo "Command: Status: Preparing..." >> $DNLog
echo "Command: Determinate: 4" >> $DNLog
echo "Command: MainTitle: Welcome to Flagler County Public Schools!" >> $DNLog