# FROM openjdk:17-alpine
# WORKDIR /build
# COPY target/demo-0.0.1-SNAPSHOT.jar /build
# ENTRYPOINT ["java", "-jar", "demo-0.0.1-SNAPSHOT.jar"]
# EXPOSE 8085

FROM maven AS build
RUN apt update && apt install git -y
WORKDIR /maven
RUN git clone https://github.com/githubprabha/Java-Springboot.git /maven
RUN  mvn clean install

FROM openjdk:17-jdk
WORKDIR /app
COPY --from=build /maven/target/demo-0.0.1-SNAPSHOT.war /app/demo-0.0.1-SNAPSHOT.war
CMD ["java", "-jar", "demo-0.0.1-SNAPSHOT.war"]
# ENTRYPOINT ["java", "-jar", "demo-0.0.1-SNAPSHOT.war"]
EXPOSE 8080