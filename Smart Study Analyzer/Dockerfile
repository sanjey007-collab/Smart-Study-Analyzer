FROM tomcat:9-jdk11

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create ROOT directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# Copy ALL files from project_1 to ROOT
COPY . /usr/local/tomcat/webapps/ROOT/

# Copy ALL JAR files to Tomcat's lib (includes MySQL driver of any version)
COPY lib/*.jar /usr/local/tomcat/lib/

EXPOSE 8080

CMD ["catalina.sh", "run"]
