import os
import gevent
from flask import Flask, render_template
from flask_sockets import Sockets
from json import dumps as json

app = Flask(__name__)
app.debug = 'DEBUG' in os.environ

sockets = Sockets(app)


class UnoBackend(object):
    def __init__(self):
        self.players = {}
        self.count = 0

    def register(self, player):
        self.players[player] = self.count
        self.count += 1

    def send(self, player, data = None):
        try:
            if not data:
                data = json({'hello': str(self.players[player])})
            player.send(data)
        except Exception:
            self.players[player] = None

    def run(self):
        for player in self.players:
            gevent.spawn(self.send, player, json({'hello': 2}))

    def start(self):
        gevent.spawn(self.run)

backend = UnoBackend()
backend.start()

@app.route('/')
def hello():
    return render_template('test.html')

@sockets.route('/submit')
def inbox(ws):
    backend.register(ws)

    gevent.sleep(.1)

    backend.send(ws)

    while not ws.closed:
        gevent.sleep(.1)
