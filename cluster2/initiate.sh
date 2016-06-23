#!/bin/bash

# Database name
database='dc';

# Create replica set - 1
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



# Create replica set - 2
echo "Intializing replica set - rs2"

replicate_rs2='rs.initiate({
   _id: "rs2",
   members: [
      { _id: 0, host: "rs2_srv1:27017" },
      { _id: 1, host: "rs2_srv2:27017" },
      { _id: 2, host: "rs2_srv3:27017" }
   ]
})';

docker exec -it mongodb_rs2_srv1_1 bash -c "echo '${replicate_rs2}' | mongo"

##INFO: You can add more replica sets





# Create configuration replica set
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
echo "Add replica set to shard - rs1 and rs2"
sleep 30
docker exec -it mongodb_router1_1 bash -c "echo \"sh.addShard('rs1/rs1_srv1:27017');\" | mongo"
docker exec -it mongodb_router1_1 bash -c "echo \"sh.addShard('rs2/rs2_srv1:27017');\" | mongo"

##INFO: You can add more shards





# Enable Sharding for a Database
echo "Enable Sharding for a Database"
sleep 10
docker exec -it mongodb_router1_1 bash -c "echo 'sh.enableSharding(\"${database}\")' | mongo"