import sys
import json


if (len(sys.argv) !=3):
    sys.exit()

tname = sys.argv[1]

sdate = sys.argv[2]

f_template = 'template/odps2postgresql-{}-template.json'.format(tname)

with open(f_template) as f:
    x=json.load(f)

y=x['job']['content'][0]['reader']['parameter']['partition']

x['job']['content'][0]['reader']['parameter']['partition']=['d='+sdate]

x['job']['content'][0]['writer']['parameter']['preSql'][0]+=" where d='{}'".format(sdate)

fout = 'day/odps2postgresql-{}-{}.json'.format(tname,sdate)

with open(fout,'w') as f2:
    json.dump(x,f2)