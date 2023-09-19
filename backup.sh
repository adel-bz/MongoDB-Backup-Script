# !/bin/bash

### Reading ENV ###
source $(dirname $BASH_SOURCE)/.env

### Database Backup ###
printf ""$GREEN"......... BACKUP START ......... "$NC" \t "$date" \t Done\n"
sudo docker exec "$db_container_name" mongodump --host=localhost --port="$db_port" --username="$db_user" --password="$db_pass" --out="$db_container_volume"/"$db_prefixname"
sleep 2
mv "$db_host_volume"/"$db_prefixname" .
tar -czvf "$db_prefixname"_"$date".tar.gz --absolute-names "$db_prefixname"


### Assets Backup ###
cp -rf "$assets_host_volume" .
sleep 2
tar -czvf "$assets_prefixname"_"$date".tar.gz --absolute-names "$assets_dir_name"
echo ".........."


### Uploading Backups to Backup Server && && Removing Olds Backups $$ Sending Alert to Discord ###
curl -T "$db_prefixname"_"$date".tar.gz ftp://"$backup_host"/"$db_backuphost_dir" --user "$backup_host_user":"$backup_host_pass"
if [ $? == 0 ]
then
  printf ""$GREEN"####### Upload Database Success"$NC""
  echo ".........."
curl -T "$assets_prefixname"_"$date".tar.gz ftp://"$backup_host"/"$assets_backuphost_dir" --user "$backup_host_user":"$backup_host_pass"
  if [ $? == 0 ]
  then
    curl -X POST -H 'Content-type: application/json' -d '{"content":"*#### Backup - database & assets Backup success "}' "$discord_url"
    printf ""$GREEN"####### Upload Assets Success "$NC""
    echo ".........."
    curl -v -u "$backup_host_user":"$backup_host_pass" ftp://"$backup_host" -Q "DELE "$db_backuphost_dir"/"$db_prefixname"_"$rmdate".tar.gz"
    curl -v -u "$backup_host_user":"$backup_host_pass" ftp://"$backup_host" -Q "DELE "$assets_backuphost_dir"/"$assets_prefixname"_"$rmdate".tar.gz"
  else
    curl -X POST -H 'Content-type: application/json' -d '{"content":"*#### Backup - database Backup success but assets Backup faild "}' "$discord_url"
    printf ""$RED"####### Database Backup And Upload Success But Assets Upload Or Backup Faild"
    echo ".........."
  fi
else
  curl -X POST -H 'Content-type: application/json' -d '{"content":"*#### Backup - database & assets Backup faild "}' "$discord_url"
  printf ""$RED"####### Database & Assets Backup Or Upload Failds"
  echo ".........."
fi

### Cleaning ###
rm -r "$db_prefixname"* "$assets_dir_name"
rm *.gz
echo ".........."
printf ""$GREEN"####### Cleaned "$NC" \t "$date" \t Done\n"

printf ""$GREEN"......... BACKUP FINISHED ......... "$NC" \t "$date" \t Done\n"
