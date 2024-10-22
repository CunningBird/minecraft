#FROM gradle:jdk-21-and-23-alpine AS build
#
## Setup workdir
#COPY . ./app/
#WORKDIR app
#
#RUN gradle clean build --stacktrace --no-daemon

FROM bellsoft/liberica-openjdk-alpine:23.0.1 AS launchserver

RUN mkdir /app && adduser -D application && chown -R application /app
WORKDIR /app

#RUN apt-get update && apt-get -y install git unzip curl wget osslsigncode vim nano && \
#    wget https://download2.gluonhq.com/openjfx/22.0.2/openjfx-22.0.2_linux-x64_bin-jmods.zip && \
#    unzip openjfx-22.0.2_linux-x64_bin-jmods.zip && \
#    cp javafx-jmods-22.0.2/* /opt/java/openjdk/jmods && \
#    rm -r javafx-jmods-22.0.2 && \
#    rm -rf openjfx-22.0.2_linux-x64_bin-jmods.zip && \

RUN mkdir libraries && \
    mkdir launcher-libraries && \
    mkdir launcher-libraries-compile && \
    mkdir modules && \
    mkdir launcher-modules && \
    mkdir compat && \
    mkdir compat/launchserver-modules && \
    mkdir data && \
    mkdir updates

COPY --from=hello /home/gradle/app/LaunchServer/build/libs/LaunchServer.jar .
COPY --from=hello /home/gradle/app/LaunchServer/build/libs/libraries ./libraries/default
COPY --from=hello /home/gradle/app/LaunchServer/build/libs/launcher-libraries ./launcher-libraries/default
COPY --from=hello /home/gradle/app/LaunchServer/build/libs/launcher-libraries-compile* ./launcher-libraries-compile/default

COPY --from=hello /home/gradle/app/launcher-runtime/runtime .
COPY --from=hello /home/gradle/app/launcher-runtime/build/libs/JavaRuntime*.jar ./launcher-modules
COPY --from=hello /home/gradle/app/launcher-runtime/compat ./compat/runtime

COPY --from=hello /home/gradle/app/ServerWrapper/build/libs/ServerWrapper.jar ./compat

COPY --from=hello /home/gradle/app/modules/*_module/build/libs/*_module.jar ./compat/launchserver-modules
COPY --from=hello /home/gradle/app/modules/*_lmodule/build/libs/*_lmodule.jar ./compat/launcher-modules

RUN ln -s ../data/libraries libraries/custom && \
    ln -s ../data/launcher-libraries launcher-libraries/custom && \
    ln -s ../data/modules modules/custom && \
    ln -s ../data/launcher-modules launcher-modules/custom

COPY --from=hello /home/gradle/app/install_launchserver_module.sh .
COPY --from=hello /home/gradle/app/install_launcher_module.sh .
COPY --from=hello /home/gradle/app/start.sh .

RUN chmod +x install_launchserver_module.sh && \
    chmod +x install_launcher_module.sh && \
    chmod +rx updates && \
    echo '-Xmx512M' > launchserver_args.txt

VOLUME /app/data
USER application
EXPOSE 9274
ENTRYPOINT ["java", "-jar", "-Dlaunchserver.dir.libraries=../libraries", "-Dlaunchserver.dir.launcher-libraries=../launcher-libraries", "-Dlaunchserver.dir.modules=../modules", "-Dlaunchserver.dir.launcher-modules=../launcher-modules", "-Dlauncher.useSlf4j=true", "/app/LaunchServer.jar"]