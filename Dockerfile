FROM tomcat:9-jdk11

EXPOSE 8080

COPY ./WebContent/WEB-INF/lib/mssql-jdbc-11.2.0.jre11.jar /usr/local/tomcat/lib/
COPY ./WebContent /usr/local/tomcat/webapps/ROOT

CMD ["catalina.sh", "run"]
