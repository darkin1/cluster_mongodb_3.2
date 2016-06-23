#!/bin/bash

for (( rs = 1; rs < 3; rs++ )); do
  echo "Intializing replica ${rs} set"
  replicate="rs.initiate();
  sleep(1000); 
  cfg = rs.conf(); 
  cfg.members[0].host = \"mongodb_rs1_srv${rs}_1\";
  rs.reconfig(cfg); 
  rs.add(\"mongodb_rs1_srv${rs}_1\"); 
  rs.add(\"mongodb_rs1_srv${rs}_2\"); 
  rs.status();"
  
  docker exec -it mongodb_router${rs}_1 bash -c "echo '${replicate}' | mongo"
done

sleep 2
# Add better mechanisum to wait for mongos connectivity to be
# established by tailing docker log for connection readiness

docker exec -it mongodb_router1_1 bash -c "echo \"sh.addShard('configReplSet/mongodb_rs1_srv1_1:27017');\" | mongo "