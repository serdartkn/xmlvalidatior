FROM openjdk:8u111
ARG JAR_FILE=target/*.jar
COPY ./src/main/java/nilvera/xmlvalidator/business/utilities/UBL-ApplicationResponse-2.1.xsd /etc
COPY ./src/main/java/nilvera/xmlvalidator/business/utilities/UBL-CreditNote-2.1.xsd /etc
COPY ./src/main/java/nilvera/xmlvalidator/business/utilities/UBL-DespatchAdvice-2.1.xsd /etc
COPY ./src/main/java/nilvera/xmlvalidator/business/utilities/UBL-Invoice-2.1.xsd /etc
COPY ./src/main/java/nilvera/xmlvalidator/business/utilities/UBL-ReceiptAdvice-2.1.xsd /etc
COPY ./src/main/java/nilvera/xmlvalidator/business/utilities/UBL-TR_Main_Schematron.xsl /etc
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]