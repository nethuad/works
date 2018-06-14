
# python3 etl_schedule_test.py

import schedule
import time
import datetime
import os

def job_print():
    nowTime=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
#     print(nowTime,"start working...")
    os.system("echo " + nowTime + " start working...")
    
 
schedule.every(5).seconds.do(job_print)


while True:
    schedule.run_pending()
    time.sleep(1)
