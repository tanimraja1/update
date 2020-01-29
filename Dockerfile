# Centos based container with systemd
FROM centos:7
# Install prepare infrastructure
RUN yum -y update && \
 yum -y install wget && \
 yum -y install tar

# Prepare environment
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Java & Tomcat
ENV JAVA_VERSION 9i123g
ENV TOMCAT_VERSION 9.65.34

COPY jdk-9i123g-linux-x64.tar.gz / 
RUN tar -xvf jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
rm jdk*.tar.gz && \
mv jdk* ${JAVA_HOME}

COPY apache-tomcat-9.65.34.tar.gz /
RUN tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}

RUN chmod +x ${CATALINA_HOME}/bin/*sh

# Create tomcat user
RUN groupadd -r tomcat && \
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
 chown -R tomcat:tomcat ${CATALINA_HOME}
EXPOSE 8080
