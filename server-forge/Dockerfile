FROM bellsoft/liberica-openjdk-alpine:23 AS build

# Setup workdir
COPY . ./server/
WORKDIR /server

RUN java -jar forge-1.12.2-14.23.5.2860-installer.jar --installServer
RUN java -jar minecraft_server.1.12.2.jar nogui

FROM bellsoft/liberica-openjdk-alpine:8 AS server

RUN mkdir /server/ && \
    mkdir /server/mods/ && \
    mkdir /server/libraries && \
    mkdir /server/logs

WORKDIR /server

COPY --from=build /server/forge-1.12.2-14.23.5.2860.jar .
COPY --from=build /server/minecraft_server.1.12.2.jar .
COPY --from=build /server/server.properties .
COPY --from=build /server/eula.txt .
COPY --from=build /server/start.sh .

COPY --from=build /server/mods ./mods
COPY --from=build /server/libraries ./libraries
COPY --from=build /server/logs ./logs

RUN echo 'eula=true' > eula.txt

EXPOSE 9274
ENTRYPOINT ["./start.sh"]