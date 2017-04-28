if window.location.protocol == 'https:'
    ws_scheme = 'wss://'
else
    ws_scheme = 'ws://'

server = new ReconnectingWebSocket(ws_scheme + location.host + "/server")

name = ''

server.onmessage = (message) ->
    message = JSON.parse(message.data)
    console.out(message)
    if message.type == 'welcome'
        $('#ready').css(
            'display', 'inline'
        )
    if message.type == 'start'
        $('#ready').css(
            'display', 'none'
        )
        $('#draw').css(
            'display', 'inline'
        )
    return

$('#ready').click((e) ->
    e.preventDefault()
    type = 'ready'
    data = ''
    message = JSON.stringify({name: name, type: type, data: data})
    console.log(message)
    server.send(message)
    return
)

$('#draw').click((e) ->
    e.preventDefault()
    type = 'draw'
    data = ''
    message = JSON.stringify({name: name, type: type, data: data})
    console.log(message)
    server.send(message)
    return
)

$('#enter').on('submit', (e) ->
    e.preventDefault()
    if $('#name')[0].value != ''
        name = $('#name')[0].value
        type = 'add'
        data = ''
        message = JSON.stringify({name: name, type: type, data: data})
        console.log(message)
        server.send(message)
    return
)