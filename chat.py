# -*- coding: utf-8 -*-

"""
Chat Server
===========
This simple application uses WebSockets to run a primitive chat server.
"""

from flask import Flask, render_template

app = Flask(__name__)
app.debug = 'DEBUG' in os.environ

@app.route('/')
def hello():
    return render_template('home.html')

@app.route('/test/')
def test():
    return 'TEST'
