# 从数据库导入数据

import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql+psycopg2://xsd:Xsd123%24@127.0.0.1:5432/xueshandai')

table = 'p_member_mode'

with engine.connect() as conn, conn.begin():
    df = pd.read_sql_query('SELECT * FROM {};'.format(table), engine)
    
df.to_pickle('member.pkl')
    


