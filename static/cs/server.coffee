if window.location.protocol == 'https:'
    ws_scheme = 'wss://'
else
    ws_scheme = 'ws://'

server = new ReconnectingWebSocket(ws_scheme + location.host + "/server")

name = ''
cards = []

players = {}

server.onmessage = (message) ->
    message = JSON.parse(message.data)
    switch message.type
        when 'welcome'
            players[message['data']] = {'cards': 0, 'ready': false}
            # TODO add this player to list of players
        when 'start'
            # TODO start game
            console.log 'start'
        when 'error'
            # TODO show error message to screen
            console.log 'error'
        when 'give'
            # TODO add card to array
            console.log 'give'
        when 'uno'
            # TODO show message saying you forgot to call UNO
            console.log 'uno'
        when 'turn'
            # TODO figure out what cards can be played if it's my turn
            # TODO update the player board with the current person's turn and remain cards
            console.log 'turn'
        when 'gg'
            # TODO end game sequence
            console.log 'gg'
        else
            # TODO display that an unknown type was recived
            console.log 'unknown response'
    return