# Gemfire-Native10

# Prerequisite

1.You need to download a gemfire 9.7.4 installer(zip version) and native client 10 from pivotal network, then put this zip file under `gemfireproductlist` folder.
`pivotal-gemfire-9.7.4.tgz`
`pivotal-gemfire-native-10.0.3-build.2-Ubuntu16-64bit.tar.gz`

Download URL:
https://network.pivotal.io/products/pivotal-gemfire#/releases/445769
https://network.pivotal.io/products/pivotal-gemfire#/releases/530741

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
/______/_/      /______/_/    /_/    9.7.4

Monitor and Manage Pivotal GemFire
gfsh>start locator
Starting a Geode Locator in /opt/pivotal/reach-uninterested-iota...
.......
Locator in /opt/pivotal/reach-uninterested-iota on 174f8c79be82[10334] as reach-uninterested-iota is currently online.Process ID: 53Uptime: 9 secondsGeode Version: 9.7.4Java Version: 1.8.0_241Log File: /opt/pivotal/reach-uninterested-iota/reach-uninterested-iota.logJVM Arguments: -Dgemfire.enable-cluster-configuration=true -Dgemfire.load-cluster-configuration-from-dir=false -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806Class-Path: /opt/pivotal/pivotal-gemfire-9.7.4/lib/geode-core-9.7.4.jar:/opt/pivotal/pivotal-gemfire-9.7.4/lib/geode-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.7.4/extensions/gemfire-greenplum-3.4.0.jar

Successfully connected to: JMX Manager [host=174f8c79be82, port=1099]

Cluster configuration service is up and running.
```

```
gfsh>start server --locators=localhost[10334]
Starting a Geode Server in /opt/pivotal/turn-helpful-beta...
......
Server in /opt/pivotal/turn-helpful-beta on 174f8c79be82[40404] as turn-helpful-beta is currently online.Process ID: 144Uptime: 6 secondsGeode Version: 9.7.4Java Version: 1.8.0_241Log File: /opt/pivotal/turn-helpful-beta/turn-helpful-beta.logJVM Arguments: -Dgemfire.locators=localhost[10334] -Dgemfire.start-dev-rest-api=false -Dgemfire.use-cluster-configuration=true -XX:OnOutOfMemoryError=kill -KILL %p -Dgemfire.launcher.registerSignalHandlers=true -Djava.awt.headless=true -Dsun.rmi.dgc.server.gcInterval=9223372036854775806Class-Path: /opt/pivotal/pivotal-gemfire-9.7.4/lib/geode-core-9.7.4.jar:/opt/pivotal/pivotal-gemfire-9.7.4/lib/geode-dependencies.jar:/opt/pivotal/pivotal-gemfire-9.7.4/extensions/gemfire-greenplum-3.4.0.jar

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

# Copy a transation example into container
# Compile and Run the transation example.

```
$docker cp main.cpp zealous_gates:/opt/pivotal/
```

```
g++ \
-D_REENTRANT \
-O3 \
-Wall \
-m64 \
-I$GEODE/include \
transaction.cpp \
-o transaction \
-L$GEODE/lib \
-Wl,-rpath,$GEODE/lib \
-lpivotal-gemfire \
-std=c++11 \
-lstdc++ \
-lgcc_s \
-lc
```

```
root@082a59848980:/opt/pivotal# ./transaction 
[config 2019/04/19 07:41:28.829781 UTC 082a59848980:1659 139866341607360] Using Geode Native Client Product Directory: /opt/pivotal/pivotal-gemfire-native
[config 2019/04/19 07:41:28.829827 UTC 082a59848980:1659 139866341607360] Product version: Pivotal GemFire Native 10.0.0-build.483 (64bit) 
[config 2019/04/19 07:41:28.829835 UTC 082a59848980:1659 139866341607360] Source revision: 
[config 2019/04/19 07:41:28.829851 UTC 082a59848980:1659 139866341607360] Source repository: 
[config 2019/04/19 07:41:28.829869 UTC 082a59848980:1659 139866341607360] Running on: SystemName=Linux Machine=x86_64 Host=082a59848980 Release=4.9.125-linuxkit Version=#1 SMP Fri Sep 7 08:20:28 UTC 2018
[config 2019/04/19 07:41:28.829884 UTC 082a59848980:1659 139866341607360] Current directory: /opt/pivotal
[config 2019/04/19 07:41:28.829894 UTC 082a59848980:1659 139866341607360] Current value of PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/pivotal/current_java:/opt/pivotal/current_java/bin:/opt/pivotal/pivotal-gemfire-9.7.1/bin:/opt/pivotal/pivotal-gemfire-native/bin
[config 2019/04/19 07:41:28.829964 UTC 082a59848980:1659 139866341607360] Current library path: 
[config 2019/04/19 07:41:28.829992 UTC 082a59848980:1659 139866341607360] Geode Native Client System Properties:
  archive-disk-space-limit = 0
  archive-file-size-limit = 0
  auto-ready-for-events = true
  bucket-wait-timeout = 0ms
  cache-xml-file = 
  conflate-events = server
  connect-timeout = 59000ms
  connection-pool-size = 5
  connect-wait-timeout = 0ms
  enable-chunk-handler-thread = false
  disable-shuffling-of-endpoints = false
  durable-client-id = 
  durable-timeout = 300s
  enable-time-statistics = false
  heap-lru-delta = 10
  heap-lru-limit = 0
  log-disk-space-limit = 0
  log-file = 
  log-file-size-limit = 0
  log-level = config
  max-fe-threads = 4
  max-socket-buffer-size = 66560
  notify-ack-interval = 1000ms
  notify-dupcheck-life = 300000ms
  on-client-disconnect-clear-pdxType-Ids = false
  ping-interval = 10s
  redundancy-monitor-interval = 10s
  security-client-dhalgo = 
  security-client-kspath = 
  ssl-enabled = false
  ssl-keystore = 
  ssl-truststore = 
  statistic-archive-file = statArchive.gfs
  statistic-sampling-enabled = true
  statistic-sample-rate = 1000ms
  suspended-tx-timeout = 30s
  tombstone-timeout = 480000ms
[config 2019/04/19 07:41:28.830018 UTC 082a59848980:1659 139866341607360] Starting the Geode Native Client
[info 2019/04/19 07:41:28.830168 UTC 082a59848980:1659 139866341607360] Using Native_ceaacfbfdd1659 as random data for ClientProxyMembershipID
Created cache
[info 2019/04/19 07:41:28.833244 UTC 082a59848980:1659 139866341607360] Creating region exampleRegion attached to pool pool
[info 2019/04/19 07:41:28.833339 UTC 082a59848980:1659 139866234185472] ClientMetadataService started for pool pool
Created region 'exampleRegion'
[error 2019/04/19 07:41:28.834571 UTC 082a59848980:1659 139866234185472] Failed to add endpoint 082a59848980:40404 to pool pool
[info 2019/04/19 07:41:28.845383 UTC 082a59848980:1659 139866234185472] Updated client meta data
Committed transaction - exiting
[info 2019/04/19 07:41:28.877275 UTC 082a59848980:1659 139866234185472] ClientMetadataService stopped for pool pool
[config 2019/04/19 07:41:28.877944 UTC 082a59848980:1659 139866341607360] Stopped the Geode Native Client
```
