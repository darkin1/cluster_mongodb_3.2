#!/bin/bash

database='dc';

#Tworzy replica set - 1
echo "Intializing replica set - rs1"

replicate_rs1='rs.initiate({
   _id: "rs1",
   members: [
      { _id: 0, host: "rs1_srv1:27017" },
      { _id: 1, host: "rs1_srv2:27017" },
      { _id: 2, host: "rs1_srv3:27017" }
   ]
})';

docker exec -it mongodb_rs1_srv1_1 bash -c "echo '${replicate_rs1}' | mongo"
##INFO: jeżeli będą kolejne replicaSet trzeba je tu dodać jak powyżej





# Tworzy replica set z serwerami konfiguracyjnymi
echo "Intializing config replica set - configReplSet"

replicate_cfg='rs.initiate({
   _id: "configReplSet",
   configsvr: true,
   members: [
      { _id: 0, host: "configsvr1:27017" },
      { _id: 1, host: "configsvr2:27017" },
      { _id: 2, host: "configsvr3:27017" }
   ]
})';

docker exec -it mongodb_configsvr1_1 bash -c "echo '${replicate_cfg}' | mongo"






# Add replica set to shard - rs1
sleep 30
echo "Add replica set to shard - rs1"
docker exec -it mongodb_configsvr1_1 bash -c "echo \"sh.addShard('rs1/rs1_srv1:27017');\" | mongo --host router1 --port 27017"

##INFO: jeżeli będą kolejne shardy również musimy je dodać
##TODO: skąd router1 wie o routerze2? - 



#Tworzymy baze na rs1 ?




# Enable Sharding for a Database
sleep 10
echo "Enable Sharding for a Database"
docker exec -it mongodb_configsvr1_1 bash -c "echo 'sh.enableSharding(\"${database}\")' | mongo --host router1 --port 27017"