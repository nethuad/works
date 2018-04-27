
# python3 demo_schedule.py

import schedule
import time
import datetime
import os

def job_print():
    nowTime=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(nowTime,"start working...")
    
def job_demo_run():
    os.system("sh demo_shell_run.sh")

    
schedule.every(5).seconds.do(job_print)
schedule.every(5).seconds.do(job_demo_run)
# schedule.every(1).minutes.do(job)
# schedule.every().hour.do(job)
# schedule.every().day.at("10:30").do(job)
# schedule.every().monday.do(job)
# schedule.every().wednesday.at("13:15").do(job)

# schedule.every().day.at("15:30").do(job_print)
# schedule.every().day.at("15:30").do(job_demo_run)

while True:
    schedule.run_pending()
    time.sleep(1)
