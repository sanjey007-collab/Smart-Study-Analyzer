FROM openjdk:8-jdk-slim

WORKDIR /app

# Copy all project files
COPY . .

# Download all required JAR dependencies into lib/
RUN mkdir -p lib && \
    cd lib && \
    curl -O https://repo1.maven.org/maven2/org/apache/tomcat/embed/tomcat-embed-core/9.0.82/tomcat-embed-core-9.0.82.jar && \
    curl -O https://repo1.maven.org/maven2/org/apache/tomcat/embed/tomcat-embed-jasper/9.0.82/tomcat-embed-jasper-9.0.82.jar && \
    curl -O https://repo1.maven.org/maven2/org/apache/tomcat/embed/tomcat-embed-el/9.0.82/tomcat-embed-el-9.0.82.jar && \
    curl -O https://repo1.maven.org/maven2/org/eclipse/jdt/ecj/3.33.0/ecj-3.33.0.jar && \
    curl -O https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar

# Compile Main.java
RUN javac -cp "lib/*" Main.java

# Build the executable JAR
RUN jar cvfm study-analyzer.jar MANIFEST.MF *.jsp WEB-INF Main.class

EXPOSE 8080

CMD ["java", "-jar", "study-analyzer.jar"]