// Generated by CoffeeScript 1.12.4
(function() {
  var test, ws_scheme;

  if (window.location.protocol === 'https:') {
    ws_scheme = 'wss://';
  } else {
    ws_scheme = 'ws://';
  }

  test = new ReconnectingWebSocket(ws_scheme + location.host + "/submit");

  test.onmessage = function(message) {
    var data;
    data = JSON.parse(message.data);
    console.log(data);
  };

}).call(this);

//# sourceMappingURL=test.js.map
