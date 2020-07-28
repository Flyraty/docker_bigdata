FROM ubuntu

ENV AZKABAN_VERSION 3.90.0

ENV AZKABAN_EXEC_DIR azkaban-exec-server/build/distributions

ENV DEBIAN_FRONTEND noninteractive

ENV TERM linux

ENV MYSQL_JDBC_VERSION 8.0.11


WORKDIR /root

RUN apt-get update -yqq \
   && apt-get install -yqq \
   curl \
   vim \
   netcat \
   mysql-client \
   wget \ 
   openjdk-8-jdk \ 
   git \
   && apt-get clean 

RUN wget https://github.com/azkaban/azkaban/archive/$AZKABAN_VERSION.tar.gz  \
   && mkdir azkaban \
   && tar -xzvf $AZKABAN_VERSION.tar.gz -C azkaban 
   

WORKDIR /root/azkaban/azkaban-$AZKABAN_VERSION


# build azkaban-exec-server
RUN ./gradlew clean build -p azkaban-exec-server -x test
RUN tar -zxvf $AZKABAN_EXEC_DIR/azkaban-exec-server-0.1.0-SNAPSHOT.tar.gz -C /root 

RUN mv /root/azkaban-exec-server-0.1.0-SNAPSHOT /root/azkaban-exec-server

# add azkaban.properties
ADD azkaban_exec.properties /root/azkaban-exec-server/conf/azkaban.properties

# exec server port
EXPOSE 12321

WORKDIR /root

ADD run.sh /root/run.sh

ADD create-all-sql-0.1.0-SNAPSHOT.sql /root/create-all-sql-0.1.0-SNAPSHOT.sql

RUN chmod +x run.sh

WORKDIR /root/azkaban-exec-server

# add mysql-connector-java-8.0.11
RUN wget http://dev.mysql.com/get/Downloads/connector/j/mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz \
   && tar -xzvf mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz \
   && rm -rf lib/mysql-connector-java-*.jar \
   && mv mysql-connector-java-${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}.jar lib/

# start and active azkaban-executor
CMD ["/bin/bash","/root/run.sh"]








