#!/bin/bash
mkdir -p libraries
mkdir -p launcher-libraries
mkdir -p modules
mkdir -p launcher-modules
mkdir -p updates
chmod +rx updates
if test -f launchserver_args.txt
then
    true
else
    echo '-Xmx512M' > launchserver_args.txt
fi
if test -f runtime
then
    true
else
    cp -r ../runtime runtime
fi
exec java -Xmx512M -Dlaunchserver.dir.libraries=../libraries -Dlaunchserver.dir.launcher-libraries=../launcher-libraries -Dlaunchserver.dir.modules=../modules -Dlaunchserver.dir.launcher-modules=../launcher-modules -Dlauncher.useSlf4j=true -jar ../LaunchServer.jar \$@
