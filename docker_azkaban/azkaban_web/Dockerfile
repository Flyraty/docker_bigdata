FROM ubuntu

ENV AZKABAN_VERSION 3.90.0

ENV AZKABAN_WEB_DIR azkaban-web-server/build/distributions

ENV AZKABAN_DB_DIR azkaban-db/sql

ENV TERM linux

ENV DEBIAN_FRONTEND noninteractive

ENV MYSQL_JDBC_VERSION 8.0.11

WORKDIR /root

RUN apt-get update -y \
   && apt-get install -y \
   curl \
   vim \
   netcat \
   mysql-client \
   wget \
   git \
   openjdk-8-jdk \ 
   && apt-get clean

RUN wget https://github.com/azkaban/azkaban/archive/$AZKABAN_VERSION.tar.gz  \
   && mkdir azkaban \
   && tar -xzvf $AZKABAN_VERSION.tar.gz -C azkaban 
   
WORKDIR /root/azkaban/azkaban-$AZKABAN_VERSION

# starting build azkaban-web-server
RUN ./gradlew clean build -p azkaban-web-server -x test

RUN tar -zxvf $AZKABAN_WEB_DIR/azkaban-web-server-0.1.0-SNAPSHOT.tar.gz -C /root \
    && mv /root/azkaban-web-server-0.1.0-SNAPSHOT /root/azkaban-web-server

WORKDIR /root

# add azkaban.properties
ADD azkaban_web.properties azkaban-web-server/conf/azkaban.properties

# web server port
EXPOSE 8443

ADD run.sh /root/run.sh

RUN chmod +x run.sh

WORKDIR /root/azkaban-web-server

# add mysql-connector-java-8.0.11
RUN wget http://dev.mysql.com/get/Downloads/connector/j/mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz \
   && tar -xzvf mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz \
   && rm -rf lib/mysql-connector-java-*.jar \
   && mv mysql-connector-java-${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}.jar lib/

# start 
CMD ["/bin/bash", "/root/run.sh"]
