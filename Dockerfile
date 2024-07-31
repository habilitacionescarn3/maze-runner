# Stage 1: Build React App
FROM node:16-alpine AS build-frontend
WORKDIR /app/maze-runner-game
COPY app/maze-runner-game/package.json app/maze-runner-game/yarn.lock ./
RUN yarn install
COPY app/maze-runner-game ./
RUN yarn build:prod

# Stage 2: Build Spring Boot Application
FROM eclipse-temurin:17-jdk-focal AS build-backend
WORKDIR /
COPY build.gradle gradlew settings.gradle ./
COPY gradle ./gradle
COPY src ./src
COPY --from=build-frontend /app/maze-runner-game/build ./src/main/resources/static
RUN ./gradlew build --no-daemon

# Stage 3: Run Application
FROM eclipse-temurin:17-jdk-focal
WORKDIR /
COPY --from=build-backend /build/libs/maze-runner-0.0.1-SNAPSHOT.jar ./maze-runner-0.0.1-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","maze-runner-0.0.1-SNAPSHOT.jar"]