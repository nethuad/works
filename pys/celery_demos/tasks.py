# from celery import Celery

# app = Celery('tasks', backend='redis://localhost', broker='pyamqp://guest@localhost//')

# @app.task
# def add(x, y):
#     return x + y


from __future__ import absolute_import, unicode_literals
from .celery import app


@app.task
def add(x, y):
    return x + y


@app.task
def mul(x, y):
    return x * y


@app.task
def xsum(numbers):
    return sum(numbers)