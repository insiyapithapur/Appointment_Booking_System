# Build stage
FROM maven:3.8-openjdk-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Run stage
FROM eclipse-temurin:21-jdk

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Tomcat version
ARG TOMCAT_VERSION=8.5.99

# Download and install Tomcat
RUN mkdir -p "$CATALINA_HOME" && \
curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -o tomcat.tar.gz && \
tar -xf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" && \
rm tomcat.tar.gz && \
rm -rf $CATALINA_HOME/webapps/ROOT $CATALINA_HOME/webapps/examples $CATALINA_HOME/webapps/docs && \
chmod -R +x $CATALINA_HOME/bin

# Create Tomcat user
RUN groupadd -r tomcat && \
useradd -r -g tomcat -d $CATALINA_HOME -s /bin/false tomcat && \
chown -R tomcat:tomcat $CATALINA_HOME

# Copy your WAR file from the build stage
COPY --from=build /app/target/AppointmentBookingSystem-0.0.1-SNAPSHOT.war $CATALINA_HOME/webapps/ROOT.war

# Copy the Oracle Wallet into container
COPY Wallet_ABS /app/wallet/

# Set TNS_ADMIN environment variable inside the container
ENV TNS_ADMIN=/app/wallet

# Oracle JDBC driver configuration
RUN mkdir -p $CATALINA_HOME/lib

# Expose HTTP port
EXPOSE 8080

# For Render, set the PORT environment variable
ENV PORT 8080
ENV JAVA_OPTS="-Dserver.port=${PORT}"

# Start Tomcat
CMD ["catalina.sh", "run"]