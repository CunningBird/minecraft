FROM gradle:jdk-21-and-23-alpine AS build

# Setup workdir
COPY . ./app/
WORKDIR app

RUN gradle clean build --stacktrace --no-daemon

FROM eclipse-temurin:21 AS launchserver

RUN mkdir /app/ && \
    mkdir /app/libraries && \
    mkdir /app/launcher-libraries && \
    mkdir /app/launcher-libraries-compile && \
    mkdir /app/modules && \
    mkdir /app/launcher-modules && \
    mkdir /app/compat && \
    mkdir /app/compat/launchserver-modules && \
    mkdir /app/data && \
    mkdir /app/runtime && \
    mkdir /app/updates

WORKDIR /app

RUN apt-get update && apt-get -y install git unzip curl wget osslsigncode vim nano && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://download2.gluonhq.com/openjfx/22.0.2/openjfx-22.0.2_linux-x64_bin-jmods.zip && \
    unzip openjfx-22.0.2_linux-x64_bin-jmods.zip && \
    cp javafx-jmods-22.0.2/* /opt/java/openjdk/jmods && \
    rm -r javafx-jmods-22.0.2 && \
    rm -rf openjfx-22.0.2_linux-x64_bin-jmods.zip

COPY --from=build /home/gradle/app/LaunchServer/build/libs/LaunchServer.jar .
COPY --from=build /home/gradle/app/LaunchServer/build/libs/libraries ./libraries/default
COPY --from=build /home/gradle/app/LaunchServer/build/libs/launcher-libraries ./launcher-libraries/default
COPY --from=build /home/gradle/app/LaunchServer/build/libs/launcher-libraries-compile* ./launcher-libraries-compile/default

COPY --from=build /home/gradle/app/launcher-runtime/runtime ./runtime
COPY --from=build /home/gradle/app/launcher-runtime/runtime ./data/runtime
COPY --from=build /home/gradle/app/launcher-runtime/build/libs/JavaRuntime*.jar ./launcher-modules
COPY --from=build /home/gradle/app/launcher-runtime/compat ./compat/runtime

COPY --from=build /home/gradle/app/ServerWrapper/build/libs/ServerWrapper.jar ./compat

COPY --from=build /home/gradle/app/modules/*_module/build/libs/*_module.jar ./compat/launchserver-modules
COPY --from=build /home/gradle/app/modules/*_lmodule/build/libs/*_lmodule.jar ./compat/launcher-modules

RUN ln -s ../data/libraries libraries/custom && \
    ln -s ../data/launcher-libraries launcher-libraries/custom && \
    ln -s ../data/modules modules/custom && \
    ln -s ../data/launcher-modules launcher-modules/custom

RUN echo '-Xmx512M' > launchserver_args.txt

WORKDIR /app/data
VOLUME /app/data
EXPOSE 9274
ENTRYPOINT ["java", "-jar", "-Dlaunchserver.dir.libraries=../libraries", "-Dlaunchserver.dir.launcher-libraries=../launcher-libraries", "-Dlaunchserver.dir.modules=../modules", "-Dlaunchserver.dir.launcher-modules=../launcher-modules", "-Dlauncher.useSlf4j=true", "/app/LaunchServer.jar"]