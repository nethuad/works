pg_dump -h 192.168.0.158 -U xsd -O -t demo -d xueshandai > demo.sql  

psql -U xueshandai -d xueshandai < demo.sql


-------------------------------------------------------------------------------------

pg_dump -h 192.168.0.158 -U xsd -O -t nginxlog -d xueshandai > nginxlog.sql

psql -U xueshandai -d xueshandai < nginxlog.sql

-----------------------------------------------------------------------------------------



pg_dump -h 192.168.0.158 -U xsd -O -t demo -d xueshandai | psql -U xueshandai -d xueshandai


psql -U xueshandai -d xueshandai demo.sql

pg_dump -h host1 dbname | psql -h host2 dbname



