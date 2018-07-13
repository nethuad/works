import pandas as pd
from sqlalchemy import create_engine

import requests
import json
import time

def getipinfo(ip):
    payload = {'ip': ip}
    api_ip="http://ip.taobao.com/service/getIpInfo.php"
    r = requests.get("http://ip.taobao.com/service/getIpInfo.php", params=payload)
    res = r.json()
    return res

engine = create_engine('postgresql://xueshandai:Xueshandai123$@localhost:5432/xueshandai')
df=pd.read_sql_table('ip_to_get', engine)


ips=[]

i = 0
total = df.shape[0]

for k in df.itertuples():
    i=i+1
    print(total,i,k.ip)
    try:
        res = getipinfo(k.ip)
        ips.append(json.dumps(res,ensure_ascii=False))
    except:
        time.sleep(5)
    else:
        pass

df_ips=pd.DataFrame(ips)
df_ips.columns=['data']

df_ips.to_sql('ip_to_get_out', engine)