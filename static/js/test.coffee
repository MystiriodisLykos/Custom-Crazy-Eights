if window.location.protocol == 'https:'
  ws_scheme = 'wss://'
else
  ws_scheme = 'ws://'

server = new ReconnectingWebSocket(ws_scheme + location.host + "/server")

server.onmessage = (message) ->
  message = JSON.parse(message.data)
  console.log(message)
  return

$('#enter').on('submit', (e) ->
  e.preventDefault()
  name = $('#name')[0].value
  type = 'add'
  data = ''
  message = JSON.stringify({name: name, type: type, data: data})
  console.log(message)
  server.send(message)
  return
)