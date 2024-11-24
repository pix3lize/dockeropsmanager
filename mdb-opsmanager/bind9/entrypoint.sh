#!/bin/bash
set -e

# Define the main application start function
appStart() {
    # Detecting if MongoDB is running on localhost
    local IP="localhost"
    
    # Check if the MongoDB service is running
    if nc -z $IP 27017; then
        echo "MongoDB is already running."
    else
        echo "Starting MongoDB..."
        # Create data directory and set ownership
        mkdir -p /data/db
        chown -R mongodb:mongodb /data/db

        echo "Data directories created."

        # Start MongoDB on port 27017
        sudo systemctl start mongod 

        # Wait for MongoDB to start
        until nc -z $IP 27017; do
            echo "Waiting for MongoDB to start on port 27017..."
            sleep 1
        done
    fi
}

# Call the appStart function
appStart

#exec "$@"

# Keep the container running
exec tail -f /dev/null
