# Gemfire-Native10

# prerequisite

1.You need to download a gemfire 9.7.1 installer(zip version) and native client 10 from pivotal network, then put this zip file under `gemfireproductlist` folder.
`pivotal-gemfire-9.7.1.tgz`
`pivotal-gemfire-native-10.0.0-build.483-Ubuntu16-64bit.tar.gz`

Download URL:
https://network.pivotal.io/products/pivotal-gemfire#/releases/318130
https://network.pivotal.io/products/pivotal-gemfire#/releases/321210

2.Tested with `Docker Community Edition for Mac 18.05.0-ce-mac66`
https://docs.docker.com/docker-for-mac/install/

# Building the container image
The current Dockerfile is based on a ubuntu:16.04 image + JDK8u201 + Gemfire9.7.1 + NativeClient10.0.0

Run the below command to compile the dockerfile to build the image:
```
docker build . -t nativeclient10:0.1
```

```
XXXXXnoMacBook-puro:NativeClient10 User1$ docker build . -t nativeclient10:0.1
Sending build context to Docker daemon  281.9MB
Step 1/37 : FROM ubuntu:16.04
 ---> 52b10959e8aa
Step 2/37 : MAINTAINER GemfireGSS <xxxxxxxxx@gmail.com>
 ---> Running in a2e24babd433
Removing intermediate container a2e24babd433
 ---> 8686ee79c7a9
Step 3/37 : ENV JAVA_VERSION 8u201
 ---> Running in 81abc8f0499d
Removing intermediate container 81abc8f0499d
 ---> f5d4fb5897c2
Step 4/37 : ENV BUILD_VERSION b09
 ---> Running in b56bf7baa2d8
Removing intermediate container b56bf7baa2d8
 ---> f8a4bb6edff3
Step 5/37 : ENV JAVA_SUB_VERSION 201
 ---> Running in 03835336d054
Removing intermediate container 03835336d054
 ---> 0aa68636379b
Step 6/37 : ENV JDK_HASH_VALUE 42970487e3af4f5aa5bca3f542482c60
 ---> Running in ec230304b624
Removing intermediate container ec230304b624
 ---> a79df2ea6a2e
Step 7/37 : ENV GEMFIREVERSION 9.7.1
 ---> Running in 8a64fce41113
Removing intermediate container 8a64fce41113
 ---> c072fcbc9c5c
Step 8/37 : WORKDIR /opt/pivotal
 ---> Running in accbc2e4581f
Removing intermediate container accbc2e4581f
 ---> e977d00ff5cc
Step 9/37 : RUN apt-get update && apt-get install -y wget
..............
-- Installing: /usr/local/share/cmake-3.14/include/cmCPluginAPI.h
-- Installing: /usr/local/share/cmake-3.14/editors/vim/indent
-- Installing: /usr/local/share/cmake-3.14/editors/vim/indent/cmake.vim
-- Installing: /usr/local/share/cmake-3.14/editors/vim/syntax
-- Installing: /usr/local/share/cmake-3.14/editors/vim/syntax/cmake.vim
-- Installing: /usr/local/share/cmake-3.14/editors/emacs/cmake-mode.el
-- Installing: /usr/local/share/aclocal/cmake.m4
-- Installing: /usr/local/share/cmake-3.14/completions/cmake
-- Installing: /usr/local/share/cmake-3.14/completions/cpack
-- Installing: /usr/local/share/cmake-3.14/completions/ctest
Removing intermediate container 821463bfc880
 ---> ca1a7324ddce
Step 36/36 : ADD ./gemfireproductlist/pivotal-gemfire-native-$NCVERSION-build.483-Ubuntu16-64bit.tar.gz /opt/pivotal/
 ---> 1bfeb727ca9a
Successfully built 1bfeb727ca9a
Successfully tagged nativeclient10:0.1
```

# Login into container

Run the below command to run the container instance(you need to modify the volume directory according to your machine's path):
```
docker run -it nativeclient10:0.1 bash
```

# Start a locator and a cacheserver from container. 
```
root@174f8c79be82:/opt/pivotal# gfsh
    _________________________     __
   / _____/ ______/ ______/ /____/ /
  / /  __/ /___  /_____  / _____  / 
 / /__/ / ____/  _____/ / /    / /  
/______/_/      /______/_/    /_/    9.7.1

Monitor and Manage Pivotal GemFire
gfsh>start locator
Starting a Geode Locator in /opt/pivotal/reach-uninterested-iota...
.......
Locator in /opt/pivotal/reach-uninterested-iota on 174f8c79be82[10334] as reach-uninterested-iota is currently online.Process ID: 53Uptime: 9 secondsGeode Version: 9.7.1Java Version: 1.8.0_201Log File: /opt/pivotal/reach-uninterested-iota/reach-uninterested-iota.logJVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806Class-Path: /opt/pivotal/pivotal-gemfire-9.7.1/lib/geode-core-9.7.1.jar:/opt/pivotal/pivotal-gemfire-9.7.1/lib/geode-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.7.1/extensions/gemfire-greenplum-3.4.0.jar

Successfully connected to: JMX Manager [host=174f8c79be82, port=1099]

Cluster configuration service is up and running.
```

```
gfsh>start server --locators=localhost[10334]
Starting a Geode Server in /opt/pivotal/turn-helpful-beta...
......
Server in /opt/pivotal/turn-helpful-beta on 174f8c79be82[40404] as turn-helpful-beta is currently online.Process ID: 144Uptime: 6 secondsGeode Version: 9.7.1Java Version: 1.8.0_201Log File: /opt/pivotal/turn-helpful-beta/turn-helpful-beta.logJVM Arguments: -Dgemfire.locators=localhost[10334] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -XX:OnOutOfMemoryError=kill -KILL %p -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806Class-Path: /opt/pivotal/pivotal-gemfire-9.7.1/lib/geode-core-9.7.1.jar:/opt/pivotal/pivotal-gemfire-9.7.1/lib/geode-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.7.1/extensions/gemfire-greenplum-3.4.0.jar

gfsh>list members
         Name           | Id
----------------------- | --------------------------------------------------------------------------
reach-uninterested-iota | 172.17.0.2(reach-uninterested-iota:53:locator)<ec><v0>:41000 [Coordinator]
turn-helpful-beta       | 172.17.0.2(turn-helpful-beta:144)<v1>:41001
```
# Create a partition region: exampleRegion and custom_orders(for remotequery example)

```
gfsh>create region --name=exampleRegion --type=PARTITION
     Member       | Status
----------------- | ------------------------------------------------------
turn-helpful-beta | Region "/exampleRegion" created on "turn-helpful-beta"

gfsh>create region --name=custom_orders --type=PARTITION
    Member      | Status
--------------- | ----------------------------------------------------
hold-happy-cake | Region "/custom_orders" created on "hold-happy-cake"

gfsh>exit
```

# Compiled the examples by cmake 
# Run the remotequery example for verification.

```
$ cd /opt/pivotal/pivotal-gemfire-native/examples
$ mkdir build
$ cd build
$ cmake .. -DGeodeNative_ROOT="/opt/pivotal/pivotal-gemfire-native"
$ cmake --build . 
```

```
root@e9856e4a6b6d:/opt/pivotal/pivotal-gemfire-native/examples/build# cmake .. -DGeodeNative_ROOT="/opt/pivotal/pivotal-gemfire-native"
-- The CXX compiler identification is GNU 7.4.0
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Found GemFireNative: /opt/pivotal/pivotal-gemfire-native/lib/libpivotal-gemfire.so (found version "1.0") 
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/continuousquery/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/continuousquery/stopserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/dataserializable/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/dataserializable/stopserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/functionexecution/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/functionexecution/stopserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/pdxserializable/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/pdxserializable/stopserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/pdxserializer/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/pdxserializer/stopserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/putgetremove/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/putgetremove/stopserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/remotequery/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/remotequery/stopserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/transaction/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/transaction/stopserver.sh
-- Found GemFireNative: /opt/pivotal/pivotal-gemfire-native/lib/libpivotal-gemfire.so (found version "1.0") 
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/sslputget/startserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/sslputget/stopserver.sh
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/sslputget/ClientSslKeys
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/sslputget/ClientSslKeys/client_keystore.password.pem
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/sslputget/ClientSslKeys/client_truststore.pem
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/sslputget/ServerSslKeys
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/sslputget/ServerSslKeys/server_truststore.jks
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/cpp/sslputget/ServerSslKeys/server_keystore.jks
-- The C compiler identification is GNU 7.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Found Geode: /opt/pivotal/pivotal-gemfire-9.7.1/bin/gfsh (found version "9.7.1") 
-- Found Java: /opt/pivotal/current_java/bin/java (found version "1.8.0_201") 
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/utilities/ClientSslKeys
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/utilities/ClientSslKeys/client_keystore.password.pem
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/utilities/ClientSslKeys/client_truststore.pem
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/utilities/ServerSslKeys
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/utilities/ServerSslKeys/server_truststore.jks
-- Installing: /opt/pivotal/pivotal-gemfire-native/examples/build/utilities/ServerSslKeys/server_keystore.jks
-- Configuring done
-- Generating done
CMake Warning:
  Manually-specified variables were not used by the project:

    GeodeNative_ROOT


-- Build files have been written to: /opt/pivotal/pivotal-gemfire-native/examples/build
root@e9856e4a6b6d:/opt/pivotal/pivotal-gemfire-native/examples/build# ls
CMakeCache.txt  CMakeFiles  Makefile  cmake_install.cmake  cpp  utilities
root@e9856e4a6b6d:/opt/pivotal/pivotal-gemfire-native/examples/build# cmake --build .
Scanning dependencies of target cpp-continuousquery
[  3%] Building CXX object cpp/continuousquery/CMakeFiles/cpp-continuousquery.dir/main.cpp.o
[  7%] Building CXX object cpp/continuousquery/CMakeFiles/cpp-continuousquery.dir/Order.cpp.o
[ 11%] Linking CXX executable cpp-continuousquery
[ 11%] Built target cpp-continuousquery
Scanning dependencies of target cpp-dataserializable
[ 14%] Building CXX object cpp/dataserializable/CMakeFiles/cpp-dataserializable.dir/main.cpp.o
[ 18%] Building CXX object cpp/dataserializable/CMakeFiles/cpp-dataserializable.dir/Order.cpp.o
[ 22%] Linking CXX executable cpp-dataserializable
[ 22%] Built target cpp-dataserializable
Scanning dependencies of target cpp-functionexecution
[ 25%] Building CXX object cpp/functionexecution/CMakeFiles/cpp-functionexecution.dir/main.cpp.o
[ 29%] Linking CXX executable cpp-functionexecution
[ 29%] Built target cpp-functionexecution
Scanning dependencies of target cpp-pdxserializable
[ 33%] Building CXX object cpp/pdxserializable/CMakeFiles/cpp-pdxserializable.dir/main.cpp.o
[ 37%] Building CXX object cpp/pdxserializable/CMakeFiles/cpp-pdxserializable.dir/Order.cpp.o
[ 40%] Linking CXX executable cpp-pdxserializable
[ 40%] Built target cpp-pdxserializable
Scanning dependencies of target cpp-pdxserializer
[ 44%] Building CXX object cpp/pdxserializer/CMakeFiles/cpp-pdxserializer.dir/main.cpp.o
[ 48%] Building CXX object cpp/pdxserializer/CMakeFiles/cpp-pdxserializer.dir/Order.cpp.o
[ 51%] Building CXX object cpp/pdxserializer/CMakeFiles/cpp-pdxserializer.dir/OrderSerializer.cpp.o
[ 55%] Linking CXX executable cpp-pdxserializer
[ 55%] Built target cpp-pdxserializer
Scanning dependencies of target cpp-putgetremove
[ 59%] Building CXX object cpp/putgetremove/CMakeFiles/cpp-putgetremove.dir/main.cpp.o
[ 62%] Linking CXX executable cpp-putgetremove
[ 62%] Built target cpp-putgetremove
Scanning dependencies of target cpp-remotequery
[ 66%] Building CXX object cpp/remotequery/CMakeFiles/cpp-remotequery.dir/main.cpp.o
[ 70%] Building CXX object cpp/remotequery/CMakeFiles/cpp-remotequery.dir/Order.cpp.o
[ 74%] Linking CXX executable cpp-remotequery
[ 74%] Built target cpp-remotequery
Scanning dependencies of target cpp-transaction
[ 77%] Building CXX object cpp/transaction/CMakeFiles/cpp-transaction.dir/main.cpp.o
[ 81%] Linking CXX executable cpp-transaction
[ 81%] Built target cpp-transaction
Scanning dependencies of target cpp-sslputget
[ 85%] Building CXX object cpp/sslputget/CMakeFiles/cpp-sslputget.dir/main.cpp.o
[ 88%] Linking CXX executable cpp-sslputget
[ 88%] Built target cpp-sslputget
Scanning dependencies of target example
[ 92%] Building Java objects for example.jar
Note: Some input files use or override a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
Note: /opt/pivotal/pivotal-gemfire-native/examples/utilities/ExampleMultiGetFunction.java uses unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
[ 96%] Generating CMakeFiles/example.dir/java_class_filelist
[100%] Creating Java archive example.jar
[100%] Built target example
```

```
root@e9856e4a6b6d:/opt/pivotal/pivotal-gemfire-native/examples/build/cpp/remotequery# ./cpp-remotequery 
Create orders
Storing orders in the region
Getting the orders from the region
The following orders have a quantity greater than 30:
OrderID: 6 Product Name: product z Quantity: 42
OrderID: 2 Product Name: product y Quantity: 37
OrderID: 4 Product Name: product z Quantity: 102
```
