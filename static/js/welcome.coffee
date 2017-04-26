if window.location.protocol == 'https:'
  ws_scheme = 'wss://'
else
  ws_scheme = 'ws://'


$('#enter').on('submit', (e) ->
  handle = $('#handle')[0].value
  setCookie('handle', handle, .5)
  return)
