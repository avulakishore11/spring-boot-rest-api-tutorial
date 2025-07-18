
#FROM docker.io/maven:3.9.9-eclipse-temurin:8-alpine AS base
#WORKDIR /app
#COPY pom.xml ./
#RUN mvn clean package
# ---- Stage 1: Build the JAR ----


FROM maven:3.9.8-eclipse-temurin-8 AS builder

WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Build the JAR file
RUN mvn clean package -DskipTests

# ---- Stage 2: Run the App ----
FROM eclipse-temurin:8-jre

WORKDIR /app

# Copy the JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port 8080 (Spring Boot default)
EXPOSE 8080

# Run the JAR
CMD ["java", "-jar", "app.jar"]
