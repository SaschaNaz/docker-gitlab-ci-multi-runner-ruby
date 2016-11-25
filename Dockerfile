FROM digitallumberjack/docker-gitlab-ci-multi-runner
MAINTAINER Kagami Sascha Rosylight <saschanaz@outlook.com>

RUN apt-get update

# the "/var/lib/mysql" stuff here is because the mysql-server postinst doesn't have an explicit way to disable the mysql_install_db codepath besides having a database already "configured" (ie, stuff in /var/lib/mysql/mysql)
# also, we set debconf keys to make APT a little quieter
RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server libmysql-java

RUN echo "[mysqld]\nlower_case_table_names = 1" >> /etc/mysql/my.cnf
	
# install Maven
RUN apt-get install -y maven

RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/oracle-jdk8-installer

COPY start.sh /sbin/start.sh
RUN chmod 755 /sbin/start.sh
ENTRYPOINT ["/sbin/start.sh"]

RUN cd /opt \
 && wget http://www.us.apache.org/dist/tomcat/tomcat-9/v9.0.0.M13/bin/apache-tomcat-9.0.0.M13.tar.gz \
 && tar xzf apache-tomcat-9.0.0.M13.tar.gz

ENV CATALINA_HOME="/opt/apache-tomcat-9.0.0.M13"
RUN chmod 755 $CATALINA_HOME/webapps

RUN locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV RUNNER_DESCRIPTION=itrust
ENV RUNNER_EXECUTOR=shell

ENV RUNNER_TOKEN=
ENV CI_SERVER_URL=
