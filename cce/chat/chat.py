import cce
import flask
import gevent
import os
import redis

REDIS_URL = os.environ['REDIS_URL']
REDIS_CHAN = 'chat'

mod = flask.Blueprint('chat', __name__)

redis = redis.from_url(REDIS_URL)

class ChatBackend(object):
    """Interface for registering and updating WebSocket clients."""

    def __init__(self, chan):
        self.chan = chan
        self.clients = list()
        self.pubsub = redis.pubsub()
        self.pubsub.subscribe(REDIS_CHAN + chan)

    def __iter_data(self):
        for message in self.pubsub.listen():
            data = message.get('data')
            if message['type'] == 'message':
                print(u'Sending message: {}'.format(data))
                yield data

    def register(self, client):
        """Register a WebSocket connection for Redis updates."""
        self.clients.append(client)

    def send(self, client, data):
        """Send given data to the registered client.
        Automatically discards invalid connections."""
        try:
            client.send(data)
        except Exception:
            self.clients.remove(client)

    def run(self):
        """Listens for new messages in Redis, and sends them to clients."""
        for data in self.__iter_data():
            for client in self.clients:
                gevent.spawn(self.send, client, data)

    def start(self):
        """Maintains Redis subscription in the background."""
        gevent.spawn(self.run)

chats = {}

@mod.route('/chat/<id>/')
def index(id):
    if id not in chats:
        chats[id] = ChatBackground(id)
    return flask.render_template('index.html')

@cce.sockets.route('/chat/<id>/submit')
def inbox(ws, id):
    """Receives incoming chat messages, inserts them into Redis."""
    while not ws.closed:
        # Sleep to prevent *constant* context-switches.
        gevent.sleep(0.1)
        message = ws.receive()

        if message:
            print(u'Inserting message: {}'.format(message))
            redis.publish(REDIS_CHAN + id, message)

@cce.sockets.route('/chat/<id>/receive')
def outbox(ws, id):
    """Sends outgoing chat messages, via `ChatBackend`."""
    print('Register')
    chats[id].register(ws)

    while not ws.closed:
        # Context switch while `ChatBackend.start` is running in the background.
        gevent.sleep(0.1)
