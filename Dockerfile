FROM sequenceiq/hadoop-ubuntu:2.6.0
MAINTAINER TeamDarkside

ENV SPARK_VERSION 1.3.0
ENV SPARK_HADOOP 2.4
ENV FULL_VERSION $SPARK_VERSION-bin-hadoop$SPARK_HADOOP
RUN apt-get install -y ipython
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-$FULL_VERSION.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-$FULL_VERSION spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-$FULL_VERSION/lib /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV SPARK_JAR hdfs:///spark/spark-assembly-1.3.0-hadoop2.4.0.jar
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
ENV PYSPARK_DRIVER_PYTHON ipython

CMD ["/etc/bootstrap.sh", "-d"]
