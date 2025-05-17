# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build

WORKDIR /app

# Copy only the pom.xml to cache dependencies
COPY pom.xml .

# Download dependencies (this step is cached unless pom.xml changes)
RUN mvn dependency:go-offline -B

# Now copy the entire source (only invalidates cache if code changes)
COPY src ./src

# Build the app
RUN mvn clean package -DskipTests

# Stage 2: Runtime image
FROM amazoncorretto:21.0.4-alpine3.18

# Set the working directory in the container
WORKDIR /app

# Copy only the JAR from the previous stage into the container
COPY --from=build /app/target/application-0.0.1-SNAPSHOT.jar app.jar

# Expose the port that the application will run on
EXPOSE 8080

# Expose the port for debugging
EXPOSE 5005

# Run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]

# Run the JAR file with debug mode
ENTRYPOINT ["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005", "-jar", "app.jar"]