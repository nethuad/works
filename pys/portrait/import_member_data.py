# 从数据库导入数据

import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql+psycopg2://xueshandai:Xueshandai123%24@127.0.0.1:5432/xueshandai')

# table = 'borrow_invest_wide_correct'

# with engine.connect() as conn, conn.begin():
#     df = pd.read_sql_query("SELECT * FROM {} where invest_date>='2018-01-01';".format(table), engine)
    
# df.to_pickle('borrow_invest_wide.pkl')


table = 'portrait_member_wide_analys'

with engine.connect() as conn, conn.begin():
    df = pd.read_sql_query("SELECT * FROM {} where reg_time>='2018-01-01';".format(table), engine)
#     df = pd.read_sql_query("SELECT * FROM {};".format(table), engine)
    
df.to_pickle('portrait_member_wide_analys.pkl')
    


