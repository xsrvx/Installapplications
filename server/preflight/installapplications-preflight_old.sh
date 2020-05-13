#!/bin/bash

#  installapplications-preflight.sh
#
#  Preflight script for InstallApplications
#
#
#  Created by Michael Pinto
#
#  Created: 05/13/20
#  Updated: 05/13/20
#

# Check if directory exists
if [[ ! -e /usr/local/.install ]]; then
  # Post Install has not been installed
  # Run InstallApplications
  exit 1
fi

# All tests passed
# Exit/remove InstallApplications
exit 0
