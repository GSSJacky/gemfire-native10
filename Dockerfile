# LICENSE GPL 2.0
#Set the base image :
FROM ubuntu:16.04


#File Author/Maintainer :
MAINTAINER GemfireGSS <xxxxxxxxx@gmail.com>

###################
# for example: 
# https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz
# --》
# "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/$JDK_HASH_VALUE/jdk-$JAVA_VERSION-linux-x64.tar.gz"
###################
ENV JAVA_VERSION 8u241
ENV BUILD_VERSION b07
ENV JAVA_SUB_VERSION 241
ENV JDK_HASH_VALUE 1f5b5a70bf22433b84d0e960903adac8


##################
# Gemfire version
##################
ENV GEMFIREVERSION 9.7.4

#Set workdir :
WORKDIR /opt/pivotal

RUN apt-get update && apt-get install -y wget

#Obtain/download Java SE Development Kit 8u172 using wget :
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/$JDK_HASH_VALUE/jdk-$JAVA_VERSION-linux-x64.tar.gz"

#Set permissions to gemfire directory to perform operations :
RUN chmod 777 /opt/pivotal

#Setup jdk1.8.x_xx and create softlink :
RUN gunzip jdk-$JAVA_VERSION-linux-x64.tar.gz
RUN tar -xvf jdk-$JAVA_VERSION-linux-x64.tar
RUN ln -s jdk1.8.0_$JAVA_SUB_VERSION current_java
RUN rm jdk-$JAVA_VERSION-linux-x64.tar

#setup unzip 
RUN apt-get update
RUN apt-get install -y unzip zip


#Add gemfire installation file
ADD ./gemfireproductlist/pivotal-gemfire-$GEMFIREVERSION.tgz /opt/pivotal/

#Set the username to root :
USER root

#Install pivotal gemfire :
#RUN tar -xvzf /opt/pivotal/pivotal-gemfire-9.7.1.tgz
#&& \
#    rm /opt/pivotal/pivotal-gemfire-$GEMFIREVERSION.tgz

#Setup environment variables :
ENV JAVA_HOME /opt/pivotal/current_java
ENV PATH $PATH:/opt/pivotal/current_java:/opt/pivotal/current_java/bin:/opt/pivotal/pivotal-gemfire-$GEMFIREVERSION/bin
ENV GEMFIRE /opt/pivotal/pivotal-gemfire-$GEMFIREVERSION
ENV GF_JAVA /opt/pivotal/current_java/bin/java

#classpath setting
ENV CLASSPATH $GEMFIRE/lib/geode-dependencies.jar:$GEMFIRE/lib/gfsh-dependencies.jar:/opt/pivotal/workdir/classes:$CLASSPATH

#COPY the scripts into container
COPY scripts /opt/pivotal/scripts

# Default ports:
# RMI/JMX 1099
# REST 8080
# PULSE 7070
# LOCATOR 10334
# CACHESERVER 40404
# UDP port: 53160
EXPOSE  8080 10334 40404 40405 1099 7070

# SET VOLUME directory
# VOLUME ["/opt/pivotal/workdir/storage"]


########################
# native client part 
########################
#pivotal-gemfire-native-10.0.3-build.2-Ubuntu16-64bit.tar.gz
ENV NCVERSION 10.0.3
ENV NCVERBUILD 2
ENV GEODE /opt/pivotal/pivotal-gemfire-native
ENV PATH $PATH:$GEODE/bin
#ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$GEODE/lib

# GCC support
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test

# Install packages
# install valgrind for memory check purpose
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  g++-7 \
  gcc-7 \
  valgrind
  
# Set up gcc/g++
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100 --slave /usr/bin/g++ g++ /usr/bin/g++-7

RUN cd /usr/local/src \ 
    && wget https://cmake.org/files/v3.14/cmake-3.14.0.tar.gz \
    && tar xvf cmake-3.14.0.tar.gz \ 
    && cd cmake-3.14.0 \
    && ./bootstrap \
    && make \
    && make install \
    && cd .. \
    && rm -rf cmake*

# native client installation
#pivotal-gemfire-native-10.0.3-build.2-Ubuntu16-64bit.tar.gz
ADD ./gemfireproductlist/pivotal-gemfire-native-$NCVERSION-build.$NCVERBUILD-Ubuntu16-64bit.tar.gz /opt/pivotal/


#RUN gunzip pivotal-gemfire-native-$NCVERSION-build.10-Linux-64bit.tar.gz
#RUN tar -xvf pivotal-gemfire-native-$NCVERSION-build.10-Linux-64bit.tar
#RUN rm pivotal-gemfire-native-$NCVERSION-build.10-Linux-64bit.tar

# compile native client c++ quickstart samples
#COPY CMakeLists.txt /opt/pivotal/pivotal-gemfire-native/SampleCode/quickstart/cpp/CMakeLists.txt
#COPY BasicOperations.cpp /opt/pivotal/pivotal-gemfire-native/SampleCode/quickstart/cpp/BasicOperations.cpp
#COPY ExecuteFunctions.cpp /opt/pivotal/pivotal-gemfire-native/SampleCode/quickstart/cpp/ExecuteFunctions.cpp
#RUN chmod a+x /opt/pivotal/scripts/nativeclientcompile.sh
#RUN /opt/pivotal/scripts/nativeclientcompile.sh
