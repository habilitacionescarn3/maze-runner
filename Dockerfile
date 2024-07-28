
FROM eclipse-temurin:17-jdk-focal
FROM node:14-alpine

WORKDIR /
COPY . .
RUN cd app/maze-runner-game

RUN ls

RUN yarn build
# RUN cd ../../

# COPY 

EXPOSE 5000

CMD java -jar build/libs/maze-runner-0.0.1-SNAPSHOT.jar
