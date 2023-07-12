# MongoDB-Backup-Script

# Overview
This bash script project is for the Backup of your data from the MongoDB database on a Docker container and the project Assets files.
This project Backup all your necessary data such as users' images and videos, and other information on the database. In addition, sends data to a backup server.


![Screenshot from 2023-07-10 12-37-10](https://github.com/adel-bz/MongoDB-Bcakup-Script/assets/45201934/7380833e-21e8-4146-bd49-2d4090251c33)

Also, you can use this project on all os that can run the bash script.

# Requirements
- You need a backup server with a FTP connection.
- You should install FTP and tar package on your server. (if doesn't exist)

# Usage
### Clone Project
Clone the project and go to the project directory.
```
git clone https://github.com/adel-bz/MongoDB-Bcakup-Script.git
cd MongoDB-Bcakup-Script
```
### Change Variables
Change the Environment Variables on the ```.env``` file. Those variables are instances.

You can find some information about Environment Variables [here](#environment-variables).

### Run Script
You can run the script manually with the below command:
```
sudo bash backup.sh
```
Or you can set a cronjob on your server, and then the server runs the script by cronjob automatically.
```
sudo crontab -e
```
Add the blowe line to the crontab.
```
30 7 * * * bash /dir/MongoDB-Bcakup-Script/backup.sh >> /var/log/backup.log
```

```30 7 * * * ```  It means the command runs at AM 7:30 every day.

You can use the below link to write a schedule for running cronjob.

https://crontab.guru/

```bash /dir/MongoDB-Bcakup-Script/backup.sh```  This command runs backup script.

> **Note**
> 
> That cronjob was an example, and you should change ```/dir``` with your backup script directory location on the server.

```>> /var/log/backup.log``` All logs after running the backup script will write on ```backup.log``` in ```/var/log/``` directory.

# Backup Strategy
Our Backup strategy has four steps, we'll talk about these steps and you can get some information about this project.

### Database Backup
We have three lines of commands for this step. first of all, we create a dump from our database and move that file to ```/data/db``` which is mounted with the host.
After that, we move the dump file from the mounted directory to the directory we want. and for the last move in this step, we compress the dump file.

### Assets Backup
This is the second step and is very simple. we just copy the assets directory from their location on the host to a directory we want and then we compress the assets directory.

![Screenshot from 2023-07-12 12-53-40](https://github.com/adel-bz/MongoDB-Bcakup-Script/assets/45201934/bff8d80f-dff5-4dda-af44-8f47ed3da7a6)

### Uploading Backups to Backup Server && Sending Alert to Slack
This is one of the most important steps. In this step, we upload our backups and send alerts to Slack. Also if uploading is unsuccessful, we'll get an unsuccessful alert on Slack.
![Screenshot from 2023-07-12 14-01-19](https://github.com/adel-bz/MongoDB-Bcakup-Script/assets/45201934/3aeec435-0550-4267-9a48-7e594ebff965)

### Cleaning
In the last step, we remove all backup files from the host.
![Screenshot from 2023-07-12 14-14-12](https://github.com/adel-bz/MongoDB-Bcakup-Script/assets/45201934/2bb19d75-2482-4195-9820-82e9b0f3fe6f)

# Environment Variables
You can find all Variables on the ```.env```file.

![Screenshot from 2023-07-10 15-03-24](https://github.com/adel-bz/MongoDB-Bcakup-Script/assets/45201934/d0c7f876-ff0b-439b-bb53-26e882fbcfee)

### Database ENV

```db_prefixname:``` It is just a prefix name for better-managing Backup files. As an example ```dbbackup```.

```db_container_name:``` Your database container name, like ```db-mongo```.

```db_container_volum:``` Your database data location on container, ```/data/db``` is a default location for MongoDB.

```db_host_volume:``` This is your database data location on the server, this location is mounted with ```/data/db``` on your Docker container, like the below code in a docker-compose file:

```
volumes:
   - /srv/adel-db:/data/db:z ### db_host_volume:/srv/adel-db
```

```db_port:``` Your database port, ```27017``` is default port for MongoDB.

```db_user:``` MongoDB username, As an example ```adel```.

```db_pass:``` MongoDB password, As an example ```adelpass```.

### Assests ENV

```assets_prefixname:``` It is just a prefix name for better-managing Backup files. As an example ```assetbackup```.

```assets_host_volume:``` This is your assets files location on the server, this location is mounted with your project assets location on a docker container, like the below code in a docker-compose file:

```
volumes:
  - /srv/adel-assets:/app/public/uploads:z  ### assets_host_volume:/srv/adel-assets
```

```assets_dir_name:```Your assets directory name, for instance ```adel-assets```.

> **Note**
> 
> Your ```assets_dir_name``` must be same with ```assets_host_volume``` directory. For example if your ```assets_host_volume``` is ```/srv/adel-assets```  therefor ```assets_dir_name``` will be ```adel-assets```.


### Backup Host ENV

```backup_host:``` Your backup server URL or IP.

```backup_host_user:``` Your Backup server username.

```backup_host_pass:``` Your Backup server password.

```db_backuphost_dir:``` Your database Backup directory on the Backup server.

```assets_backuphost_dir:``` Your assets directory on the Backup server.


### Other ENV

```date:``` For get the date and set on Backup files.

```GREEN, RED, NC:``` Colors.

```slack_url:``` Slack webhook for sending an alert to Slack.
