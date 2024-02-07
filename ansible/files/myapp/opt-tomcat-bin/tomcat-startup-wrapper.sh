#!/bin/bash

# Start Tomcat
/opt/tomcat/bin/startup.sh

# Sleep for 60 seconds
sleep 60

# Run the revert script
python3 /opt/tomcat/bin/config.properties.revert.py