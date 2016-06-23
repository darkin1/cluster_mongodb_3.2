use dc
rs.slaveOk()
db.test.find()

db.getCollectionNames() || show collections
db.createCollection('test')
db.test.insert({aa: "bb"})