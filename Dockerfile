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
