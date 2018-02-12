#!/bin/bash

echo "Running Gitblit server from entrypoint.sh"
java -server -Xmx1024M -Djava.awt.headless=true -jar /opt/gitblit/gitblit.jar --baseFolder /opt/gitblit-data
