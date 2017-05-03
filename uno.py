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
        self.deck += [Card('', v) for v in ['wild_', 'wild_+4']]
        shuffle(self.deck)

    def add(self, ws, name):
        if not self.in_progress and len(self.players) <= 5:
            for player, values in self.players.iteritems():
                message = json.dumps({'type': 'welcome', 'data': player})
                ws.send(message)
                if values['ready']:
                    message = json.dumps({'type': 'ready', 'data': player})
                    ws.send(message)
            self.players[name] = {'ws': ws,
                                  'ready': False,
                                  'cards': 0,
                                  'uno': False}
            self.turn_order.append(name)
            self.cast(json.dumps({'type': 'welcome', 'data': name}))
        elif len(self.players) <= 5:
            self.send(name, json.dumps({'type': 'error', 'data': 'Full'}))
        else:
            self.send(name, json.dumps({'type': 'error', 'data': 'In progress'}))

    def draw(self, name):
        if len(self.deck) == 0:
            if len(self.discard) != 0:
                for c in self.discard:
                    if c.value.find('wild') == -1:
                        self.deck.append(c)
                    else:
                        self.deck.append(Card('', c.value))
                shuffle(self.deck)
            else:
                for c in UnoGame.colors:
                    self.deck += [Card(c, v) for v in UnoGame.values]
                self.deck += [Card(c, '0') for c in UnoGame.colors]
                self.deck += [Card('', v) for v in ['wild_', 'wild_+4']]
        card = self.deck[0].dictionary()
        del self.deck[0]
        data = json.dumps({'type': 'give', 'data': card})
        self.players[name]['cards'] += 1
        self.send(name, data)

    def ready(self, name):
        self.players[name]['ready'] = True
        ready = [player['ready'] for player in self.players.values()]
        self.cast(json.dumps({'type': 'ready', 'data': name}))
        if all(ready) and len(self.players) > 2:
            # self.cast(json.dumps({'type': 'start', 'data': ''}))
            self.start_game()
            # self.cast(json.dumps({'type': 'start', 'data': ''}))

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
        self.cast(json.dump({'type': 'test', 'data': 'work'}))
        # self.cast(json.dumps({ 'type':'start', 'data':'' }))
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

    def play(self, name, data):
        self.players[name]['cards'] -= 1
        if self.players[name]['cards'] == 0:
            self.gg(name)
        card = Card(data['color'], data['value'])
        self.discard.append(card)
        self.turn()

    def uno(self, name):
        if self.players[name]['cards'] == 1:
            self.players[name]['uno'] = True
        else:
            for name, info in self.players.iteritems():
                if name not in self.players[0] + self.players[-2]:
                    if info['cards'] == 1 and not info['uno']:
                        [self.draw(name) for i in range(2)]
                        self.send(name, json.dumps({'type': 'uno', 'data': 'forgot'}))

    def gg(self, name):
        self.cast(json.dumps({'type': 'gg', 'data': name}))
        self.__init__()

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
    return render_template('index.html')


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

            elif message['type'] == 'play':
                backend.play(message['name'], message['data'])

            elif message['type'] == 'uno':
                backend.uno(message['name'])