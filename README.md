# MongoDB-Backup-Script

# Table of Contents

- [Introduction](https://github.com/adel-bz/MongoDB-Bcakup-Script#introduction)
- [Features](https://github.com/adel-bz/MongoDB-Bcakup-Script/blob/main/README.md#features)
- [Requirements](https://github.com/adel-bz/MongoDB-Bcakup-Script#requirements)
- [Usage](https://github.com/adel-bz/MongoDB-Bcakup-Script#usage)
- [Environment Variables](https://github.com/adel-bz/MongoDB-Bcakup-Script#environment-variables)
- [Contributing](https://github.com/adel-bz/MongoDB-Bcakup-Script#contributing)

# Introduction
This bash script project is for the Backup of your data from the MongoDB database on a Docker container and the project Assets files.
This project Backup all your necessary data such as users' images and videos, and other information on the database. In addition, sends data to a backup server.


![Screenshot from 2023-07-10 12-37-10](https://github.com/adel-bz/MongoDB-Bcakup-Script/assets/45201934/7380833e-21e8-4146-bd49-2d4090251c33)

Also, you can use this project on all OS that can run the bash script.

# Features
- Automated MongoDB database backups.
- Automated project's assets backups.
- Configurable backup schedules.
- Backup compression to save storage space.
- Removing old backups automatically.
- Support for local and remote backup destinations.
- Alert notifications for backup status.
- Highly customizable through environment variables.
- Open-source and easily extendable.

# Requirements
- A Linux-based operating system (e.g., Ubuntu, CentOS).
- Bash shell (usually pre-installed on Linux systems).
- FTP server (Backup server) for remote backups.
- MongoDB installed and configured. (as a Docker container)


# Usage
### Clone Project
Clone the project and go to the project directory.
```
git clone https://github.com/adel-bz/MongoDB-Bcakup-Script.git
cd MongoDB-Bcakup-Scrip.
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

```bash /dir/MongoDB-Bcakup-Script/backup.sh```  This command runs the backup script.

> **Note**
> 
> That cronjob was an example, and you should change ```/dir``` with your backup script directory location on the server.

```>> /var/log/backup.log``` All logs after running the backup script will write on ```backup.log``` in ```/var/log/``` directory.

# Environment Variables
You can find all Variables on the ```.env```file.

![Screenshot from 2023-07-10 15-03-24](https://github.com/adel-bz/MongoDB-Bcakup-Script/assets/45201934/d0c7f876-ff0b-439b-bb53-26e882fbcfee)

### Database ENV

```db_prefixname:``` It is just a prefix name for better-managing Backup files. As an example ```dbbackup```.

```db_container_name:``` Your database container name, like ```db-mongo```.

```db_container_volum:``` Your database data location on the container, ```/data/db``` is a default location for MongoDB.

```db_host_volume:``` This is your database data location on the server, this location is mounted with ```/data/db``` on your Docker container, like the below code in a docker-compose file:

```
volumes:
   - /srv/adel-db:/data/db:z  ### db_host_volume:/srv/adel-db
```

```db_port:``` Your database port, ```27017``` is the default port for MongoDB.

```db_user:``` MongoDB username, As an example ```adel```.

```db_pass:``` MongoDB password, As an example ```adelpass```.

### Assests ENV

```assets_prefixname:``` It is just a prefix name for better managing Backup files. As an example ```assetbackup```.

```assets_host_volume:``` This is your assets files location on the server, this location is mounted with your project assets location on a docker container, like the below code in a docker-compose file:

```
volumes:
  - /srv/adel-assets:/app/public/uploads:z  ### assets_host_volume:/srv/adel-assets
```

```assets_dir_name:```Your assets directory name, for instance ```adel-assets```.

> **Note**
> 
> Your ```assets_dir_name``` must be the same with the ```assets_host_volume``` directory. For example, if your ```assets_host_volume``` is ```/srv/adel-assets```  therefor ```assets_dir_name``` will be ```adel-assets```.


### Backup Host ENV

```backup_host:``` Your backup server URL or IP.

```backup_host_user:``` Your Backup server username.

```backup_host_pass:``` Your Backup server password.

```db_backuphost_dir:``` Your database Backup directory on the Backup server.

```assets_backuphost_dir:``` Your assets directory on the Backup server.


### Other ENV

```date:``` For get the date and set on Backup files.

```GREEN, RED, NC:``` Colors.

```rmdate:```Removing's date for removing old backup.

```slack_url:``` Slack webhook for sending an alert to Slack.

```discord_url:``` Discord webhook for sending an alert to Discord.


# Contributing
We welcome contributions from the community to improve the MongoDB Backup Script. To contribute:

1. Fork the repository.

2. Create a new branch for your feature/fix:
```
git checkout -b feature-name
```
3. Commit your changes and push to your forked repository:
```
git commit -m "Add a descriptive commit message"
git push origin feature-name
```
4. Create a pull request. Your changes will be reviewed, and once approved, they will be merged into the main branch.

Please ensure your code adheres to the project's coding standards.
