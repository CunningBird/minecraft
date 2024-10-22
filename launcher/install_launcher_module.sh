#!/bin/bash -e
set -e
if [ $? -eq 0 ]; then
    >&2 echo "Usage: install_launcher_module.sh MODULE_NAME"
    exit 1
fi
MODULE_FILE="compat/launcher-modules/\$1_lmodule.jar"
if test -f /app/\$MODULE_FILE
then
    ln -s /app/\$MODULE_FILE /app/data/launcher-modules/\$1_lmodule.jar
else
    echo \$MODULE_FILE not exist
fi