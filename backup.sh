# !/bin/bash

### Reading ENV ###
source $(dirname $BASH_SOURCE)/.env

### Database Backup ###
printf ""$GREEN"......... BACKUP START ......... "$NC" \t "$date" \t Done\n"
sudo docker exec "$db_container_name" mongodump --host=localhost --port="$db_port" --username="$db_username" --password="$db_pass" --out="$db_container_volume"/"$db_prefixname"_"$date"|
sleep 2
mv "$db_host_volume"/"$db_prefixname"_"$date" .
tar -czvf "$db_prefixname"_"$date".tar.gz --absolute-names "$db_prefixname"_"$date"


### Assets Backup ###
sleep 2
cp -rf "$assets_host_volume" .
tar -czvf "$assets_prefixname"_"$date".tar.gz --absolute-names "$assets_dir_name"
echo ".........."


### Uploading Backups to Backup Server && Sending Alert to Slack ###
curl -T "$db_prefixname"_"$date".tar.gz ftp://"$backup_host"/"$db_backuphost_dir"/"$db_prefixname"_"$date".tar.gz --user "$backup_host_user":"$backup_host_pass"
if [ $? == 0 ]
then
  printf ""$GREEN"####### Upload Database Success"$NC""
  echo ".........."
curl -T "$assets_prefixname"_"$date".tar.gz ftp://"$backup_host"/"$assets_backuphost_dir"/"$assets_prefixname"_"$date".tar.gz --user "$backup_host_user":"$backup_host_pass"
  if [ $? == 0 ]
  then
    curl -X POST -H 'Content-type: application/json' --data '{"text":"*#### Backup - database & assets Backup success "}' "$slack_url"
    printf ""$GREEN"####### Upload Assets Success "$NC""
    echo ".........."
  else
    curl -X POST -H 'Content-type: application/json' --data '{"text":"*#### Backup - database Backup success but assets Backup faild "}' "$slack_url"
    printf ""$RED"####### Database Backup And Upload Success But Assets Upload Or Backup Faild"
    echo ".........."
  fi
else
  curl -X POST -H 'Content-type: application/json' --data '{"text":"*#### Backup - database & assets Backup faild "}' "$slack_url"
  printf ""$RED"####### Database & Assets Backup Or Upload Failds"
  echo ".........."
fi

### Cleaning ###
rm -r "$db_prefixname"* "$assets_dir_name"
rm *.gz
echo ".........."
printf ""$GREEN"####### Cleaned "$NC" \t "$date" \t Done\n"

printf ""$GREEN"......... BACKUP FINISHED ......... "$NC" \t "$date" \t Done\n"
