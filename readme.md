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
