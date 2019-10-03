FROM alpine/git as clone
WORKDIR /app
RUN git clone https://github.com/Karumien/adochazka-client
RUN git clone https://github.com/Karumien/ais-service

FROM maven:3.5-jdk-8-alpine as build
WORKDIR /adochazka
COPY --from=clone /app/adochazka-client /adochazka
RUN mvn install
WORKDIR /app
COPY --from=clone /app/ais-service /app
RUN mvn install

FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=build /app/target/ais-service-1.0.0-SNAPSHOT.jar /app
EXPOSE 2201
ENTRYPOINT ["sh", "-c"]
CMD ["java -jar ais-service-1.0.0-SNAPSHOT.jar"]
