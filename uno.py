import os
import gevent
import json
from flask import Flask, render_template
from flask_sockets import Sockets

app = Flask(__name__)
app.debug = 'DEBUG' in os.environ

sockets = Sockets(app)


class UnoGame(object):
    def __init__(self):
        self.players = {}

    def add(self, ws, name):
        self.players[name] = {'ws': ws}

    def send(self, player, data = None):
        try:
            if not data:
                data = json.dumps({'type': 'welcome', 'data': player})
            self.players[player]['ws'].send(data)
        except Exception:
            self.players[player] = None

    def cast(self, data):
        for player in self.players.keys():
            gevent.spawn(self.send, player, data)

    def start(self):
        gevent.spawn(self.cast)

backend = UnoGame()
backend.start()

@app.route('/')
def hello():
    return render_template('test.html')

@sockets.route('/server')
def inbox(ws):
    while not ws.closed:
        gevent.sleep(.1)

        message = ws.receive()

        if message:
            message = json.loads(message)
            if message['type'] == 'add':
                backend.add(ws, message['name'])
                gevent.sleep(.1)
                backend.send(message['name'])
