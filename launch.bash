#!/bin/bash

# patch the config file to set the backend address
CFG=/etc/nginx/sites-enabled/default
cat $CFG | sed -e "s#@@BACKEND@@#${TARGET}#g" > /tmp/default
mv /tmp/default $CFG

exec nginx