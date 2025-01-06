FROM openjdk:17-alpine
WORKDIR /build
RUN mvn clean install
COPY target/demo-0.0.1-SNAPSHOT.jar /build
ENTRYPOINT ["java", "-jar", "demo-0.0.1-SNAPSHOT.jar"]
EXPOSE 8085

