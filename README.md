# MongoDB-Backup-Script

# Overview
This bash script project is for the Backup of your data from the MongoDB database on a Docker container and the project Assets files.
This project Backup all your necessary data such as users images and videos, and other information on the database, and then sends data to a backup server.


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

You can find some information about Environment Variables [here](#environment-variables)

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

``` 30 7 * * * ```  It means the command runs at AM 7:30 every day.

You can use the below link to write a schedule for running cronjob.

https://crontab.guru/

``` bash /dir/MongoDB-Bcakup-Script/backup.sh```  This command runs backup script.

> **Note**
> 
> That cronjob was an example, and you should change ```/dir``` with your backup script directory location on the server.

``` >> /var/log/backup.log ``` All logs after running the backup script will write on ```backup.log``` in ```/var/log/``` directory.

# Environment Variables
You can find all Variables on the ```.env```file.


![Screenshot from 2023-07-10 15-03-24](https://github.com/adel-bz/MongoDB-Bcakup-Script/assets/45201934/d0c7f876-ff0b-439b-bb53-26e882fbcfee)

### ENV

``` db_prefixname:``` is just a prefix name for better-managing Backup files. As an example ```ddbackup```.

```db_container_name:``` Your database container name, like ```db-mongo```.
