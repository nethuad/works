PATH="/usr/local/bin:/usr/bin:/bin"
JAVA_HOME=/usr/local/java/jdk1.8.0_161
PATH=/usr/local/pgsql/bin:$JAVA_HOME/bin:$PATH

cd /var/www/scripts/datax
sh demo/demo_run.sh>>demo/demo.log 2>&1 &
