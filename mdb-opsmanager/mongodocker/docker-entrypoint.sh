#!/bin/bash
set -Eeuo pipefail

# dpkgArch="$(dpkg --print-architecture)"
# case "$dpkgArch" in
# 	amd64) # https://github.com/docker-library/mongo/issues/485#issuecomment-891991814
# 		if ! grep -qE '^flags.* avx( .*|$)' /proc/cpuinfo; then
# 			{
# 				echo
# 				echo 'WARNING: MongoDB 5.0+ requires a CPU with AVX support, and your current system does not appear to have that!'
# 				echo '  see https://jira.mongodb.org/browse/SERVER-54407'
# 				echo '  see also https://www.mongodb.com/community/forums/t/mongodb-5-0-cpu-intel-g4650-compatibility/116610/2'
# 				echo '  see also https://github.com/docker-library/mongo/issues/485#issuecomment-891991814'
# 				echo
# 			} >&2
# 		fi
# 		;;

# 	arm64) # https://github.com/docker-library/mongo/issues/485#issuecomment-970864306
# 		# https://en.wikichip.org/wiki/arm/armv8#ARMv8_Extensions_and_Processor_Features
# 		# http://javathunderx.blogspot.com/2018/11/cheat-sheet-for-cpuinfo-features-on.html
# 		if ! grep -qE '^Features.* (fphp|dcpop|sha3|sm3|sm4|asimddp|sha512|sve)( .*|$)' /proc/cpuinfo; then
# 			{
# 				echo
# 				echo 'WARNING: MongoDB requires ARMv8.2-A or higher, and your current system does not appear to implement any of the common features for that!'
# 				echo '  applies to all versions ≥5.0, any of 4.4 ≥4.4.19'
# 				echo '  see https://jira.mongodb.org/browse/SERVER-71772'
# 				echo '  see https://jira.mongodb.org/browse/SERVER-55178'
# 				echo '  see also https://en.wikichip.org/wiki/arm/armv8#ARMv8_Extensions_and_Processor_Features'
# 				echo '  see also https://github.com/docker-library/mongo/issues/485#issuecomment-970864306'
# 				echo
# 			} >&2
# 		fi
# 		;;
# esac

# Define the main application start function
appStart() {
    # Detecting if MongoDB is running on localhost
    local IP="localhost"
    
    # Check if the MongoDB service is running

	echo "Starting MongoDB..."
	# Create data directory and set ownership
	mkdir -p /data/db
	chown -R mongodb:mongodb /data/db

	echo "Data directories created."

	FLAG_FILE="/data/db/setup_done"

	# Check if the flag file exists
	if [ ! -f "$FLAG_FILE" ]; then
		# Start MongoDB with the specified parameters
		sudo -u mongodb mongod --port 27017 --dbpath /data/db --logpath /data/db/mongodb.log --bind_ip_all --fork

		# Wait for MongoDB to start (sleep for a few seconds)
		sleep 5

		# Create admin user in MongoDB
		mongosh --eval 'use admin' --eval 'db.createUser({user:"root", pwd:"example", roles:[{role:"userAdminAnyDatabase", db:"admin"},{ role: "root", db: "admin" }]})'

		# Stop MongoDB
		pkill mongod

		touch "$FLAG_FILE"
	else
	echo "Setup has already been completed. Skipping initialization."
	fi

	sleep 5

# Convert DEPLOYMENT variable to lowercase
DEPLOYMENT=$(echo "$DEPLOYMENT" | tr '[:upper:]' '[:lower:]')

if [[ "$DEPLOYMENT" == "replicaset" ]]; then
    # Start MongoDB in single mode
    sudo -u mongodb mongod --port 27017 --replSet replicaset --dbpath /data/db --logpath /data/db/mongodb.log --bind_ip_all --fork --auth --keyFile /data/replicakey
    echo "Started MongoDB in replicaset mode."
else
    # Start MongoDB in authenticated mode
    sudo -u mongodb mongod --port 27017 --dbpath /data/db --logpath /data/db/mongodb.log --bind_ip_all --fork --auth
    echo "Started MongoDB in single node mode."
fi
    
}

# Call the appStart function
appStart

exec tail -f /dev/null
