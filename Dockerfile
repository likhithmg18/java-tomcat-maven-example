# Use an official Maven image to build the WAR
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy only pom.xml first to leverage Docker cache
COPY pom.xml .
# If you have other dependency files, copy them now
RUN mvn dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Build the WAR
RUN mvn package -DskipTests

# Second stage: use a lightweight JRE + Tomcat runner
FROM eclipse-temurin:17-jre-slim

WORKDIR /app

# Copy the built WAR file from build stage
COPY --from=build /app/target/*.war app.war

# Expose port 8080
EXPOSE 8080

# Run the WAR using webapp-runner (packaged via pom in your example)
# Assuming the webapp-runner jar is inside the WAR or dependencies folder
CMD ["java","-jar","/app/app.war"]
