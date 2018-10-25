# STAGE: Build
FROM maven:3.5.4-ibmjava-8-alpine as builder

# Create Working Directory
ENV BUILD_DIR=/home/maven/app/
RUN mkdir -p $BUILD_DIR
WORKDIR $BUILD_DIR
COPY pom.xml $BUILD_DIR

# Copy Code Over and Build jar
COPY src src
RUN mvn clean install -DskipTests=true

# STAGE: Deploy
FROM openjdk:8-jre-alpine

# Install Extra Packages
RUN apk --no-cache update \
 && apk add jq bash bc

# Create app directory
ENV APP_HOME=/
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Copy jar file over from builder stage
COPY --from=builder /home/maven/app/target/micro-orders-0.0.1.jar $APP_HOME
RUN mv ./micro-orders-0.0.1.jar app.jar

COPY startup.sh startup.sh
COPY scripts scripts

EXPOSE 8080
ENTRYPOINT ["./startup.sh"]
