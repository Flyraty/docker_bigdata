
DB_LOOPS="20"
MYSQL_HOST="mysql"
MYSQL_PORT="3306"
START_CMD="bin/start-web.sh"

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

/bin/bash bin/start-web.sh

sleep 100