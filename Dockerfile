<<<<<<< Updated upstream
# Use an official Maven image as the base image for building
FROM maven:3.8-openjdk-11 AS build
# Set the working directory inside the container
WORKDIR /app
# Copy the Maven project definition (pom.xml) into the container
COPY pom.xml .
# Download the project dependencies
RUN mvn dependency:go-offline
# Copy the application source code into the container
COPY src ./src
# Build the Spring Boot application JAR
RUN mvn package
# Use an official OpenJDK runtime image as the base image
FROM openjdk:11-jre-slim
# Set the working directory inside the container
WORKDIR /app
# Copy the Spring Boot JAR from the build stage into the container
COPY --from=build /app/target/*.jar app.jar
# Expose the port that the Spring Boot app will listen on
EXPOSE 8081
# Specify the command to run the Spring Boot app when the container starts
=======
# FROM openjdk:11.0.15-jre
# ADD target/*.jar app.jar
# ENTRYPOINT ["java","-jar","app.jar"]

# FROM maven:3.8-openjdk-11 AS build

# WORKDIR /app

# COPY pom.xml .

# RUN mvn dependency:go-offline

# COPY src ./src

# # Install MySQL Connector/J
# RUN apt-get update && \
#     apt-get install -y libmysql-java && \
#     rm -rf /var/lib/apt/lists/*

# RUN mvn package

# FROM openjdk:11-jre-slim

# WORKDIR /app

# COPY --from=build /app/target/*.jar app.jar

# EXPOSE 8081

# CMD ["java", "-jar", "app.jar"]

# Build stage
FROM maven:3.8-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Final stage
FROM openjdk:11-jre-slim
WORKDIR /app

# Install the MySQL Connector/J library
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8081
>>>>>>> Stashed changes
CMD ["java", "-jar", "app.jar"]
