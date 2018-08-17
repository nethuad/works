import pandas as pd
from sqlalchemy import create_engine
engine = create_engine('postgresql://xueshandai:Xueshandai123$@localhost:5432/xueshandai')
ip=pd.read_sql_table('ip_to_map_province', engine)



def get_ip_value(ip):
    ip2 = ip.split('.')
    ipv = int(ip2[0])*256**3+int(ip2[1])*256**2+int(ip2[2])*256+int(ip2[3])
    return ipv

def findcountryprovince_from_db(ip):
#     print("ip:",ip)
    ipv = get_ip_value(ip)
    sql='select * from ip_store2 where ipv1<='+str(ipv)+' and ipv2>='+ str(ipv)
#     print("sql:",sql)
    data= pd.read_sql_query(sql, engine)
    if data.size>0:
        return data.loc[0,'province']
    else:
        return 'unknow'

ip['province']=''

for k in ip.index:
#     print(k,ip.loc[k,'ip'])
    ip.loc[k,'province']=findcountryprovince_from_db(ip.loc[k,'ip'])
    print(k,ip.loc[k,'ip'],ip.loc[k,'province'])

ip.to_sql('ip_do_map_province', if_exists='replace',index=False, con=engine)



# drop table ip_to_map_province;

# drop table if exists ip_do_map_province;

# create table ip_to_map_province as 
# select unnest(
# ARRAY[
# '61.149.150.38',
# '27.224.151.5'
# ]) ip
# ;


