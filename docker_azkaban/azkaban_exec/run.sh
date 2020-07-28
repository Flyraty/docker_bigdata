AZKABAN_VERSION="3.90.0"

DB_LOOPS="20"
MYSQL_HOST="mysql"
MYSQL_PORT="3306"
START_CMD="bin/start-exec.sh"

# wait for mariadb
i=0
while ! nc $MYSQL_HOST $MYSQL_PORT >/dev/null 2>&1 < /dev/null; do
  i=`expr $i + 1`
  if [ $i -ge $DB_LOOPS ]; then
    echo "$(date) - ${MYSQL_HOST}:${MYSQL_PORT} still not reachable, giving up"
    exit 1
  fi
  echo "$(date) - waiting for ${MYSQL_HOST}:${MYSQL_PORT}..."
  sleep 1
done

# create azkaban table
echo "import azkaban create-all-sql.sql to $MYSQL_HOST"
mysql -h $MYSQL_HOST -uazkaban -pazkaban azkaban < /root/create-all-sql-0.1.0-SNAPSHOT.sql

/bin/bash bin/start-exec.sh

bash;curl -G "localhost:12321/executor?action=activate" && echo
