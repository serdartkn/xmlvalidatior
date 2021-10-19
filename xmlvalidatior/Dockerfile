FROM openjdk:8u111
ARG JAR_FILE=target/*.jar
COPY ./src/main/java/nilvera/xmlvalidator/business/concretes/UBL-TR_Main_Schematron.xsl /etc
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]