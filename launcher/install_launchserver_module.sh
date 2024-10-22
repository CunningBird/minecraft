#!/bin/bash -e
set -e
if [ $? -eq 0 ]; then
    >&2 echo "Usage: install_launchserver_module.sh MODULE_NAME"
    exit 1
fi
MODULE_FILE="compat/launchserver-modules/\$1_module.jar"
if test -f /app/\$MODULE_FILE
then
    ln -s /app/\$MODULE_FILE /app/data/modules/\$1_module.jar
else
    echo \$MODULE_FILE not exist
fi