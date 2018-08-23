from __future__ import absolute_import, unicode_literals
from celery import Celery

app = Celery('proj',
             broker='amqp://',
             backend='redis://localhost',
             include=['proj.tasks'])

# app = Celery('tasks', backend='redis://localhost', broker='pyamqp://guest@localhost//')

# Optional configuration, see the application user guide.
app.conf.update(
    result_expires=3600,
)

if __name__ == '__main__':
    app.start()