# Stage 1: Maven Build
FROM maven:3.9.3-eclipse-temurin-21 as builder
WORKDIR /app
COPY . .
RUN mvn clean install

# Stage 2: Tomcat Runtime
FROM eclipse-temurin:21-jdk
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ARG TOMCAT_VERSION=8.5.99

RUN mkdir -p "$CATALINA_HOME" && \
    curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -o tomcat.tar.gz && \
    tar -xf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" && \
    rm tomcat.tar.gz && \
    rm -rf $CATALINA_HOME/webapps/ROOT $CATALINA_HOME/webapps/examples $CATALINA_HOME/webapps/docs && \
    chmod -R +x $CATALINA_HOME/bin

# Copy the WAR file from builder stage
COPY --from=builder /app/target/AppointmentBookingSystem-0.0.1-SNAPSHOT.war $CATALINA_HOME/webapps/ROOT.war

# Copy Oracle Wallet (if needed)
COPY Wallet_ABS /app/wallet/
ENV TNS_ADMIN=/app/wallet

# Expose the port for Tomcat
EXPOSE 8080
ENV PORT 8080
ENV JAVA_OPTS="-Dserver.port=${PORT}"

# Start Tomcat
CMD ["catalina.sh", "run"]
