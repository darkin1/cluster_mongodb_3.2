docker-compose -p mongodb up -d
 

https://www.digitalocean.com/community/tutorials/how-to-create-a-sharded-cluster-in-mongodb-using-an-ubuntu-12-04-vps

docker rm mongodb_router1_1 mongodb_router2_1 mongodb_configsvr3_1 mongodb_configsvr2_1 mongodb_configsvr1_1 mongodb_rs1_srv1_1 mongodb_rs1_srv2_1 mongodb_rs1_srv3_1 mongodb_rs2_srv1_1 mongodb_rs2_srv2_1 mongodb_rs2_srv3_1


Ustawiamy shard
```
> docker exec -it mongodb_router1_1 bash
> mongo
> show dbs (nie ma bazy)
  - use config
  - db.databases.find()

> use dc
> db.dc.ensureIndex( { _id : "hashed" } )
> show dbs (pojawi sie baza)
> sh.shardCollection("dc.test", { "_id": "hashed" } )
```

Sprawdzamy Shardy rs1
```
> docker exec -it mongodb_rs1_srv1_1 bash
> mongo
> show dbs
> use dc
> show collections (powinniśmy zobaczyć kolekcje test)
> db.test.find() (na razie pusto)
```

Sprawdzamy Shardy rs2
```
> docker exec -it mongodb_rs2_srv1_1 bash
reszta ta sama co powyżej
```

Wypełniamy danymi
```
> docker exec -it mongodb_router1_1 bash
> mongo
> use dc
> for (var i = 1; i <= 500; i++) db.test.insert( { x : i } )
> db.test.find()
```

Sprawdzamy dane w szardzie rs1
```
> docker exec -it mongodb_rs1_srv1_1 bash
> mongo
> db.test.find()
```

Sprawdzamy dane w szardzie rs2
```
> docker exec -it mongodb_rs2_srv1_1 bash
> mongo
> db.test.find()
```

komenda `it` pokazuję więcej

Jak widać część danych zostało zapisane do szardu rs1, a część danych do szardu rs2
