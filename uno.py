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
        self.turn_order = []
        self.deck = []
        self.discard = []
        self.in_progress = False
        for c in UnoGame.colors:
            self.deck += [Card(c, v) for v in UnoGame.values]
        self.deck += [Card(c, '0') for c in UnoGame.colors]
        self.deck += [Card('wild', v) for v in ['', '+4']]
        shuffle(self.deck)

    def add(self, ws, name):
        self.players[name] = {'ws': ws, 'ready': False, 'cards': 0}
        self.turn_order.append(name)
        self.send(name)
        self.cast(json.dumps({'type': 'test', 'data': str(name) + ' has entered'}))

    def draw(self, name):
        card = self.deck[0].dictionary()
        del self.deck[0]
        data = json.dumps({'type': 'give', 'data': card})
        self.players[name]['cards'] += 1
        self.send(name, data)

    def ready(self, name):
        self.players[name]['ready'] = True
        ready = [player['ready'] for player in self.players.values()]
        self.send(name, json.dumps({'ready': ready}))
        if all(ready) and len(self.players) > 2:
            self.cast(json.dumps({'type': 'start', 'data': ''}))
            self.start_game()

    def start_game(self):
        for player in self.players.keys():
            for i in range(7):
                self.draw(player)
        fst = self.deck[0]
        while fst.color == 'wild':
            shuffle(self.deck)
            fst = self.deck[0]
        self.discard.append(fst)
        del self.deck[0]
        last, self.turn_order = self.turn_order[0], self.turn_order[1:]
        self.in_progress = True
        self.turn()
        self.turn_order.append(last)

    def turn(self):
        if self.discard[-1].value == 'skip':
            self.turn_order = self.turn_order[1:] + self.turn_order[0]
        elif self.discard[-1].value == 'reverse':
            self.turn_order = self.turn_order[::-1]
        elif self.discard[-1].value == '+2':
            [self.draw(self.turn_order[0]) for i in range(2)]
            self.turn_order = self.turn_order[1:] + self.turn_order[0]
        elif self.discard[-1].value == '+4':
            [self.draw(self.turn_order[0]) for i in range(4)]
            self.turn_order = self.turn_order[1:] + self.turn_order[0]
        data = {'players': [{'player': name,
                             'cards': value['cards'],
                             'playing': name == self.turn_order[0]}
                            for name, value in self.players.iteritems()],
                'card': self.discard[0].dictionary()}
        self.cast(json.dumps({'type': 'turn', 'data': data}))
        self.turn_order = self.turn_order[1:] + self.turn_order[0]

    def send(self, player, data = None):
        try:
            if not data:
                data = json.dumps({'type': 'welcome', 'data': player})
            self.players[player]['ws'].send(data)
        except Exception:
            self.players[player] = None

    def cast(self, data):
        for player in self.players.keys():
            self.send(player, data)

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

            elif message['type'] == 'draw':
                backend.draw(message['name'])

            elif message['type'] == 'ready':
                backend.ready(message['name'])
