import pandas as pd
from sqlalchemy import create_engine

import requests
import json

import time

import random

def getipinfo_notry3(ip):
    time.sleep(random.randint(3,5))
    try:
        api_ip="http://ip.taobao.com/service/getIpInfo.php"
        r = requests.get(api_ip, params={'ip': ip})
        return r.json()
    except :
        return '{}'
    
def getipinfo(ip):
    success = False
    attempts = 1
    while attempts < 6 and not success:
        time.sleep(random.randint(3*attempts-2,3*attempts))
        try:
            api_ip="http://ip.taobao.com/service/getIpInfo.php"
            r = requests.get(api_ip, params={'ip': ip})
            rr = r.json()
            success = True
        except :
            attempts += 1
            if attempts == 6:
                rr = '{}' 
    return rr

engine = create_engine('postgresql://xueshandai:Xueshandai123$@localhost:5432/xueshandai')
ip=pd.read_sql_table('ip_list_todo', engine)

ip['info']=''

for k in ip.index:
    info = getipinfo(ip.loc[k,'ip'])
    ip.loc[k,'info'] = json.dumps(info,ensure_ascii=False)
    print(k,ip.loc[k,'ip'],ip.loc[k,'info'])

ip.to_sql('ip_list_done', if_exists='replace',index=False, con=engine)



