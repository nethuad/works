
# nohup python3 /var/www/scripts/datax/etl_schedule.py >> etl.log 2>&1 &
# pip3 install schedule

import schedule
import time
import datetime
import os

def job_print():
    nowTime=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
#     print(nowTime,"start working...")
    os.system("echo " + nowTime + " start working...")
    
def job_etl_run():
    os.system("sh run-all.sh")

    
# schedule.every(5).seconds.do(job_print)
# schedule.every(5).seconds.do(job_etl_run)

schedule.every().day.at("4:30").do(job_print)
schedule.every().day.at("4:30").do(job_etl_run)

while True:
    schedule.run_pending()
    time.sleep(3600)

    