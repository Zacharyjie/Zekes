#!/bin/bash
#
# mongodb status
# db.serverStatus().ok
# memory status
# Physical memory: db.serverStatus().mem.resident
# Virtual memory: db.serverStatus().mem.virtual
# opcounters status
# insert: db.serverStatus().opcounters.insert
# query: db.serverStatus().opcounters.query
# update: db.serverStatus().opcounters.update
# delete: db.serverStatus().opcounters.delete
# connections status
# current connections: db.serverStatus().connections.current
MONGODBPATH="/usr/local/mongodb3.2.1/bin/mongo"
HOST="127.0.0.1"
PORT="$1"
MONGODB_PA="$MONGODBPATH ${HOST}:${PORT}"

if [ $# == 3 ];then
  result=$(/bin/echo "db.serverStatus().$2.$3" | $MONGODBPATH ${HOST}:${PORT} --quiet)
  echo $result
elif [ $# == 2 ];then
  result=$(/bin/echo "db.serverStatus().$2" | $MONGODBPATH ${HOST}:${PORT} --quiet)
  echo $result
else
  echo "Usage:$0 PORT mem resident"
fi
