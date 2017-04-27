import os
import gevent
import json
from flask import Flask, render_template
from flask_sockets import Sockets
from random import shuffle

app = Flask(__name__)
app.debug = 'DEBUG' in os.environ

sockets = Sockets(app)


class Card:
    def __init__(self, color, value):
        self.color = color
        self.value = value

    def dictionary(self):
        return {'color': self.color, 'value': self.value}


class UnoGame(object):
    colors = ['red', 'blue', 'green', 'blue']
    values = [str(x) for x in range(1, 10)] + ['skip'] + ['reverse'] + ['+2']

    def __init__(self):
        self.players = {}
        self.deck = []
        for c in UnoGame.colors:
            self.deck += [Card(c, v) for v in UnoGame.values]
        self.deck += [Card(c, '0') for c in UnoGame.colors]
        self.deck += [Card('wild', v) for v in ['', '+4']]
        shuffle(self.deck)

    def add(self, ws, name):
        self.players[name] = {'ws': ws, 'ready': False}

    def draw(self, name):
        try:
            card = self.deck[0].dictionary()
            del self.deck[0]
            data = json.dumps({'type': 'give', 'data': card})
            self.send(name, data)
        except Exception:
            pass

    def ready(self, name):
        self.players[name]['ready'] = True
        ready = all([player['ready'] for player in self.players])
        if ready:
            for player in self.players.keys():
                data = 'cards'
                data = json.dumps({'type': 'start', 'data': data})
                self.send(player, data)

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

            elif message['type'] == 'draw':
                backend.draw(message['name'])

            elif message['type'] == 'ready':
                backend.ready(message['name'])
