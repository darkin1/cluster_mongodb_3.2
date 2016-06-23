#!/bin/bash

echo "Intializing replica set"

replicate='rs.initiate({
   _id: "rs1",
   members: [
      { _id: 0, host: "rs1_srv1:27017" },
      { _id: 1, host: "rs1_srv2:27017" },
      { _id: 2, host: "rs1_srv3:27017" }
   ]
})';

docker exec -it mongodb_rs1_srv1_1 bash -c "echo '${replicate}' | mongo"