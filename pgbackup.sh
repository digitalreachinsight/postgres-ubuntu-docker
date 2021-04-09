DATETIME=`date +%Y%m%d-%H%M%S`
echo $DATETIME
HOST=`hostname`;
echo $HOST;
cd /backups/
mkdir /backups/
chmod 777 /backups/

for I in $(su postgres -c 'psql -c "SELECT datname FROM pg_database WHERE datistemplate = false;" -t');
#  do mysqldump -u root $I | gzip > "/tmp/db-backups/$I.sql.gz";
  do
  echo $I;
  su postgres -c "pg_dump $I > \"/backups/postgres-$HOST-$I-$DATETIME.sql\""
  gzip /backups/postgres-$HOST-$I-$DATETIME.sql
  #mysqldump --lock-all-tables --add-drop-table -u root $I > "/tmp/db-backups/$HOST-$I-$DATETIME.sql";
done
