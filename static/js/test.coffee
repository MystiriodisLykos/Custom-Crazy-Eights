if window.location.protocol == 'https:'
  ws_scheme = 'wss://'
else
  ws_scheme = 'ws://'

test = new ReconnectingWebSocket(ws_scheme + location.host + "/submit")

test.onmessage = (message) ->
  data = JSON.parse(message.data);
  console.log data
  return