#jupyter
cd /var/www/jupyter
source venv/bin/activate
jupyter notebook --ip=0.0.0.0 --port=8159 --no-browser --notebook-dir=/var/www/scripts > jupyter.log 2>&1 &
deactivate

#superset
pip3 freeze > requirements.txt
pip3 install sqlalchemy
pip3 install pymssql
pip3 install psycopg2

mssql+pymssql://huadong:xxx@192.168.0.231:1433/portrait
postgresql+psycopg2://xsd:xxx@127.0.0.1:5432/xueshandai

cd /var/www/spst
source venv/bin/activate
gunicorn superset:app -b 0.0.0.0:8158 > superset.log 2>&1 &
deactivate


#etl
cd /var/www/scripts/datax
python3 etl_schedule.py > etl.log 2>&1 &

注意当前采用supervisor无法启动，采用如上人工方式

