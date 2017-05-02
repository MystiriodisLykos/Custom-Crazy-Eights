// Generated by CoffeeScript 1.12.4
(function() {
  var cards, name, players, ws_scheme;

  if (window.location.protocol === 'https:') {
    ws_scheme = 'wss://';
  } else {
    ws_scheme = 'ws://';
  }

  window.server = new ReconnectingWebSocket(ws_scheme + location.host + "/server");

  name = '';

  cards = [];

  players = {};

  window.server.onmessage = function(message) {
    message = JSON.parse(message.data);
    console.log(message);
    switch (message.type) {
      case 'welcome':
        players[message['data']] = {
          'cards': 0,
          'ready': false
        };
        break;
      case 'start':
        console.log('start');
        break;
      case 'error':
        console.log('error');
        break;
      case 'give':
        console.log('give');
        break;
      case 'uno':
        console.log('uno');
        break;
      case 'turn':
        console.log('turn');
        break;
      case 'gg':
        console.log('gg');
        break;
      default:
        console.log('unknown response');
    }
  };

}).call(this);

//# sourceMappingURL=server.js.map
