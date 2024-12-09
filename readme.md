# MongoDB Ops Manager in docker 🐳 
This repository contains necessary information to deploy MongoDB Ops Manager 8 on Docker Desktop. That includes a dockerfile for MongoDB Ops Manager 8 and MongoDB 8 enterprise edition. 

To run MongoDB Ops Manager please clone the repository and run this docker compose 
```yaml
version: "3.5"

services:

  mongo-server1:
    image: pix3lize/mongodbenterprise8
    container_name: appsdb1
    hostname: appsdb1
    ports:
      - 27017:27017
    environment:
      DEPLOYMENT: single      

  mongo-server2:
    image: pix3lize/mongodbenterprise8
    container_name: appsdb2
    hostname: appsdb2
    volumes: 
      - ./init-replica.sh:/home/init-replica.sh
    ports:
      - 27018:27017 
    environment:
      DEPLOYMENT: script

  mongo-server3:
    image: pix3lize/mongodbenterprise8
    container_name: appsdb3
    hostname: appsdb3
    ports:
      - 27019:27017    
    environment:
      DEPLOYMENT: replicaset

  mongo-server4:
    image: pix3lize/mongodbenterprise8
    container_name: appsdb4
    hostname: appsdb4
    ports:
      - 27020:27017
    environment:
      DEPLOYMENT: replicaset

  ubuntu:
    image: pix3lize/mongodbopsmanager8
    platform: linux/amd64
    container_name: opsmanager1
    hostname: opsmanager1
    working_dir: /home/mdb    
    volumes:
      - ./conf-mms.properties:/opt/mongodb/mms/conf/conf-mms.properties      
    entrypoint: ["/bin/bash", "-c"]
    command: 
      - |
        sleep 10
        sudo /etc/init.d/mongodb-mms start
        tail -f /dev/null
    depends_on:
      - mongo-server1
    ports:
      - 8080:8080

```


<!-- # Ops Manager Command   -->
### Ops Manager Command
-------------
- Start ops manager
```bash
sudo /etc/init.d/mongodb-mms start
```
- Create backup folder
```bash
mkdir -p /backup
chown 999 /backup
```
- Ops manager config file
```bash
cd /opt/mongodb/mms/conf/
tail -F /opt/mongodb/mms/logs/daemon.log
cd /opt/mongodb/mms/logs/
```
- Ops manager log file
```bash
sudo /etc/init.d/mongodb-mms start
```

### MongoDB Agent Command
-------------
- MongoDB Agent Setup
```bash
mkdir -p /var/run/mongodb-mms-automation/
chown mongodb:mongodb /var/run/mongodb-mms-automation/
```
- MongoDB Agent start the service 
```bash
sudo systemctl start mongodb-mms-automation-agent.service
```
- MongoDB Agent start the service 
```bash
sudo systemctl stop mongodb-mms-automation-agent.service
```
- MongoDB Agent log folder
```bash
code /var/log/mongodb-mms-automation
```
