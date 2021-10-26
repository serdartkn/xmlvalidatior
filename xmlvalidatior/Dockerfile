FROM openjdk:8u111-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ./src/main/resources/static/UBL-TR_Main_Schematron.xsl /etc
COPY ./src/main/resources/static/UBLTR_1.2.1_Paketi/xsdrt /etc
COPY ${JAR_FILE} app.jar
EXPOSE 8181
ENTRYPOINT ["java","-jar","/app.jar"]