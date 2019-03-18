#!/bin/bash

gfsh <<!
start locator --name=locator1 --port=10334 --initial-heap=256m --max-heap=256m
#start locator --name=locator1 --port=10334 --properties-file=config/locator.properties --initial-heap=256m --max-heap=256m

#configure pdx --portable-auto-serializable-classes=".*";

start server --name=server1 --locators=localhost[10334] --initial-heap=512m --max-heap=512m
#start server --name=server2 --server-port=0 --properties-file=config/gemfire.properties --initial-heap=1g --max-heap=1g

# deploy the functions
#undeploy --jar=functions-1.0.0.jar
#deploy --jar=../functions/target/functions-1.0.0.jar

create region --name=exampleRegion --type=PARTITION
create region --name=customer --type=PARTITION

list members;
list regions;
exit;
!
