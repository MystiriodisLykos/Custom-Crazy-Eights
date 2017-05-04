if window.location.protocol == 'https:'
    ws_scheme = 'wss://'
else
    ws_scheme = 'ws://'

server = new ReconnectingWebSocket(ws_scheme + location.host + "/server")

app = new PIXI.Application(window.innerWidth - 25, window.innerHeight - 25, {
    backgroundColor: 0x1099bb
})

PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST

ca = []
listDict = {}

start = 1
end = 9
nameCount = 0
scale = 0.2
cardWidth = 586
cardHeight = 878
playing = false
red = blue = green = yellow = pickColor = input = join = playerName = currentCard = ''

nameStyle = new PIXI.TextStyle(
    fontFamily: 'Arial',
    fontSize: 24,
    wordwrap: true
)

document.body.appendChild(app.view)

window.onload = (e) ->
    welcome()
    return

boxStyle = new PIXI.TextStyle(
    fontFamily: 'Comic Sans MS',
    fontSize: 30
)

homeBox = new PIXI.TextStyle(
    fontFamily: 'Comic Sans MS'
    fontSize: 20
)

welcStyle = new PIXI.TextStyle(
    fontFamily: 'Arial',
    fontSize: 100
    fontWeight: 'bold',
    fill: ['#ffe702', '#ff130a'],
    stroke: '#121000',
    strokeThickness: 5,
    dropShadow: true,
    dropShadowColor: '#000000',
    dropShadowBlur: 4,
    dropShadowAngle: Math.PI / 6,
    dropShadowDistance: 6,
)


window.onresize = (e) ->
    w = window.innerWidth - 25
    h = window.innerHeight - 25
    app.view.style.width = w + 'px'
    app.view.style.height = h + 'px'
    renderer.resize(w, y)
    return


readyToPlay = ->
    # Draws the check mark to indicate ready
    ready = PIXI.Sprite.fromImage('../static/assets/buttons/ready.png')
    ready.anchor.set(.5)
    ready.scale.x = ready.scale.y *= .04
    ready.x = (window.innerWidth / 2) - 180
    ready.y = (window.innerHeight / 2) + 55
    ready.interactive = true
    ready.buttonMode = true
    app.stage.addChild(ready)
    ready.on('pointerdown', () ->
        message = JSON.stringify({name: playerName, type: 'ready', data: ''})
        console.log(message)
        server.send(message)
        return
    )

    # text for ready click
    check = new PIXI.Text("Click check mark when ready", nameStyle)
    check.x = (window.innerWidth / 2) - 555
    check.y = (window.innerHeight / 2) + 25
    app.stage.addChild(check)

    # Removes the join button
    app.stage.removeChild(join)
    return

welcome = ->
    welcStyle = new PIXI.TextStyle(
        fontFamily: 'Arial',
        fontSize: 100
        fontWeight: 'bold',
        fill: ['#ffe702', '#ff130a'],
        stroke: '#121000',
        strokeThickness: 5,
        dropShadow: true,
        dropShadowColor: '#000000',
        dropShadowBlur: 4,
        dropShadowAngle: Math.PI / 6,
        dropShadowDistance: 6,
    )

    boxStyle = new PIXI.TextStyle(
        fontFamily: 'Comic Sans MS',
        fontSize: 30
    )

    # Draws the join button
    join = PIXI.Sprite.fromImage('../static/assets/buttons/join.png')
    join.anchor.set(.5)
    join.scale.x = join.scale.y *= .35
    join.x = (window.innerWidth / 2) - 55
    join.y = (window.innerHeight / 2) - 32.5
    join.interactive = true
    join.buttonMode = true
    join.on('pointerdown', () ->
        playerName = input.text
        message = JSON.stringify({name: playerName, type: 'add', data: ''})
        # console.log(message)
        server.send(message)
        return
    )
    app.stage.addChild(join)

    border = PIXI.Sprite.fromImage('../static/assets/buttons/border.png')
    border.anchor.set(.5)
    border.scale.x = border.scale.y *= .45
    border.x = (window.innerWidth / 2) + 400
    border.y = (window.innerHeight / 2) + 40
    app.stage.addChild(border)

    # Text for no play button
    welcomePageHead = new PIXI.Text("Welcome to UNO!", welcStyle)
    welcomePageHead.scale.x = welcomePageHead.scale.y *= 1.01
    welcomePageHead.x = (window.innerWidth / 2) - 610
    welcomePageHead.y = (window.innerHeight / 2) - 300
    app.stage.addChild(welcomePageHead)

    # text for enter name here
    nameHere = new PIXI.Text("Enter your username:", nameStyle)
    nameHere.scale.x = nameHere.scale.y *= 1.1
    nameHere.x = (window.innerWidth / 2) - 575
    nameHere.y = (window.innerHeight / 2) - 45
    app.stage.addChild(nameHere)

    #Players Heading
    playas = new PIXI.Text("PLAYERS", boxStyle)
    playas.scale.x = playas.scale.y *= 1.1
    playas.x = (window.innerWidth / 2) + 340
    playas.y = (window.innerHeight / 2) - 190
    app.stage.addChild(playas)

    input = new PixiTextInput()
    input.width = 150
    input.height = 40
    input.position.x = (window.innerWidth / 2) - 315
    input.position.y = (window.innerHeight / 2) - 53
    input.text= "Name"
    app.stage.addChild(input)
    return

game = ->
    clearStage()
    # style for text for no play button
    style = new PIXI.TextStyle(
        fontFamily: 'Arial',
        fontSize: 11
        wordWrap: true,
        wordWrapWidth: 75
    )
    
    style1 = new PIXI.TextStyle(
        fontFamily: 'Arial',
        fontSize: 100
        fontWeight: 'bold',
        fill: ['#ffe702', '#ff130a'],
        stroke: '#121000',
        strokeThickness: 5,
        dropShadow: true,
        dropShadowColor: '#000000',
        dropShadowBlur: 4,
        dropShadowAngle: Math.PI / 6,
        dropShadowDistance: 6,
    )

    stefan = PIXI.Sprite.fromImage('../static/assets/buttons/border.png')
    stefan.anchor.set(.5)
    stefan.scale.x *= .4
    stefan.scale.y *= .25
    stefan.x = (window.innerWidth / 2) - 430
    stefan.y = (window.innerHeight / 2) - 30
    app.stage.addChild(stefan)

    dusty = new PIXI.Text("PLAYERS       # of cards", homeBox)
    dusty.scale.x = dusty.scale.y *= 1.1
    dusty.x = (window.innerWidth / 2) - 550
    dusty.y = (window.innerHeight / 2) - 160
    app.stage.addChild(dusty)

    leftArr = PIXI.Sprite.fromImage('../static/assets/buttons/leftArrow.png')
    leftArr.anchor.set(.5)
    leftArr.scale.x = leftArr.scale.y = scale
    leftArr.x = (window.innerWidth / 2) - 290
    leftArr.y = (window.innerHeight / 2) + 150
    leftArr.interactive = true
    leftArr.buttonMode = true
    leftArr.on('pointerdown', () ->
        if start != 0
            start--
            end--
        drawHand()
        return
    )
    app.stage.addChild(leftArr)

    # draw the right triangle for carousel
    rightArr = PIXI.Sprite.fromImage('../static/assets/buttons/rightArrow.png')
    rightArr.anchor.set(.5)
    rightArr.scale.x = rightArr.scale.y = scale
    rightArr.x = (window.innerWidth / 2) + 385
    rightArr.y = (window.innerHeight / 2) + 150
    rightArr.interactive = true
    rightArr.buttonMode = true
    rightArr.on('pointerdown', () ->
        if end != ca.length - 1
            start++
            end++
        drawHand()
        return
    )
    app.stage.addChild(rightArr)

    # draw the uno button
    ubutt = PIXI.Sprite.fromImage('../static/assets/buttons/ubutton.png')
    ubutt.anchor.set(.5)
    ubutt.scale.x = ubutt.scale.y = scale
    ubutt.x = (window.innerWidth / 2) - 420
    ubutt.y = (window.innerHeight / 2) + 150
    ubutt.interactive = true
    ubutt.buttonMode = true
    ubutt.on('pointerdown', () ->
        # TODO: send UNO message to the server
        console.log 'uno'
        return
    )
    app.stage.addChild(ubutt)

    # draw the no play button
    noplay = PIXI.Sprite.fromImage('../static/assets/buttons/no.png')
    noplay.anchor.set(.5)
    noplay.scale.x = noplay.scale.y = scale
    noplay.x = (window.innerWidth / 2) - 575
    noplay.y = (window.innerHeight / 2) + 150
    noplay.interactive = true
    noplay.buttonMode = true
    noplay.on('pointerdown', () ->
        message = JSON.stringify({type: 'play', name: playerName, data: ''})
        server.send(message)
        return
    )
    app.stage.addChild(noplay)

    # text for no play button
    unableToPlay = new PIXI.Text("Click red button if you do not have a card to play", style)
    unableToPlay.x = (window.innerWidth / 2) - 610
    unableToPlay.y = (window.innerHeight / 2) + 175
    noplay.scale.x = noplay.scale.y *= 1.01
    app.stage.addChild(unableToPlay)

    welcomeToUno = new PIXI.Text("Let's Play UNO!!!", style1)
    welcomeToUno.scale.x = welcomeToUno.scale.y *= 1.01
    welcomeToUno.x = (window.innerWidth / 2) - 500
    welcomeToUno.y = (window.innerHeight) - 650
    app.stage.addChild(welcomeToUno)

    #Draw face down card
    faceDown = PIXI.Sprite.fromImage('../static/assets/cards/face_down.png')
    faceDown.anchor.set(.5)
    faceDown.scale.x = faceDown.scale.y = scale
    faceDown.x = (window.innerWidth / 2) - 75
    faceDown.y = (window.innerHeight / 2) - 75
    app.stage.addChild(faceDown)
    drawHand()
    return

updateCard = ->
    #Draw current card
    starter = '../static/assets/cards/'
    upCard = starter + currentCard.color + "_" + currentCard.value + ".png"
    upCard.anchor.set(.5)
    upCard.scale.x = upCard.scale.y = scale
    upCard.x = (window.innerWidth / 2) + 75
    upCard.y = (window.innerHeight / 2) - 75
    app.stage.addChild(upCard)

drawHand = ->
    clickCard = ->
        if playing
            play = false
            if @color.indexOf('wild') != -1
                if @value == '11' and wildFour() == true
                    alert("You can not play a Wild +4 at this time.")
                else
                    play = true
                    play(this)
            play = play or @color == currentCard.color or @value == currentCard.value
            if wild
                data = {color: @color, value: @value}
                message = JSON.stringify(name: playerName, type: 'play', data: data)
                server.send(message)
                for s in app.stage.children
                    if s.color and s.value
                        if s.color == @color and s.value = @value
                            app.stage.removeChile(s)
                            break
        return

    # display cards in hand (up to max)
    for s in app.stage.children
        if s and s.color
            app.stage.removeChild(s)
    for cardO, index in ca
        if index <= end and index >= start
            index -= start
            offset = 5 - index
            starter = '../static/assets/cards/'
            cardStr = starter + cardO.color + "_" + cardO.value + ".png"
            card = PIXI.Sprite.fromImage(cardStr)
            card.anchor.set(.5)
            card.y = 500
            card.x = app.renderer.width / 2
            card.x += (cardWidth * scale / 2) * offset
            card.scale.x = card.scale.y = scale
            card.interactive = true
            card.buttonMode = true
            card.color = cardO.color
            card.value = cardO.value
            card.on('pointerdown', clickCard)
            app.stage.addChild(card)
    return

wild = (card) ->
    click = ->
        app.stage.removeChild(red)
        app.stage.removeChild(blue)
        app.stage.removeChild(green)
        app.stage.removeChild(yellow)
        app.stage.removeChild(pickColor)
        return

    red = PIXI.Sprite.fromImage('../static/assets/colors/radam.png')
    red.scale.x = red.scale.y = scale
    red.anchor.set(.5)
    red.x = (window.innerWidth / 2) - 450
    red.y = (window.innerHeight / 2) - 100
    red.card = card
    red.interactive = true
    red.buttonMode = true
    red.on('pointerdown', () ->
        @card.color = 'red'
        click()
    )
    app.stage.addChild(red)

    blue = PIXI.Sprite.fromImage('../static/assets/colors/blue.png')
    blue.scale.x = blue.scale.y = scale
    blue.anchor.set(.5)
    blue.x = (window.innerWidth / 2) - 350
    blue.y = (window.innerHeight / 2) - 100
    blue.card = card
    blue.interactive = true
    blue.buttonMode = true
    blue.on('pointerdown', () ->
        @card.color = 'blue'
        click()
    )
    app.stage.addChild(blue)

    yellow = PIXI.Sprite.fromImage('../static/assets/colors/yellow.png')
    yellow.scale.x = yellow.scale.y = scale
    yellow.anchor.set(.5)
    yellow.x = (window.innerWidth / 2) - 450
    yellow.y = (window.innerHeight / 2)
    yellow.card = card
    yellow.interactive = true
    yellow.buttonMode = true
    yellow.on('pointerdown', () ->
        @card.color = 'yellow'
        click()
    )
    app.stage.addChild(yellow)

    green = PIXI.Sprite.fromImage('../static/assets/colors/grain.png')
    green.scale.x = green.scale.y = scale
    green.anchor.set(.5)
    green.x = (window.innerWidth / 2) - 350
    green.y = (window.innerHeight / 2)
    green.card = card
    green.interactive = true
    green.buttonMode = true
    green.on('pointerdown', () ->
        @card.color = 'green'
        click()
    )
    app.stage.addChild(green)

    pickColor = new PIXI.Text("Choose a color:", nameStyle)
    pickColor = new PIXI.Text("Choose a color:", nameStyle)
    pickColor.x = (window.innerWidth / 2) - 490
    pickColor.y = (window.innerHeight / 2) - 180
    app.stage.addChild(pickColor)
    return

clearStage = ->
    for child in app.stage.children
        app.stage.removeChild(child)
    return

# Function that takes a name and displays in the border/ player list
getName = (Pname) ->
    listDict[Pname] = nameCount
    nameCount++
    listName = new PIXI.Text(Pname, nameStyle)
    listName.x = window.innerWidth / 2 + 300
    listName.y = window.innerHeight / 2 + ((75 * nameCount) - 200)
    app.stage.addChild(listName)
    return

# And/or takes the name and a boolean that they are ready and puts a check mark in the list next to the name
getCheck = (Pname) ->
    number = listDict[Pname]
    ready = PIXI.Sprite.fromImage('../static/assets/buttons/ready.png')
    ready.scale.x = ready.scale.y = scale * .25
    ready.x = window.innerWidth / 2 + 300 + 100
    ready.y = window.innerHeight / 2 + ((75 * number) - 200)
    app.stage.addChild(ready)
    return

server.onmessage = (message) ->
    message = JSON.parse(message.data)
    console.log(message)
    switch message.type
        when 'welcome'
            if not (message.data of listDict)
                getName(message.data)
                readyToPlay()
        when 'ready'
            getCheck(message.data)
        when 'start'
            clearStage()
            clearStage()
            clearStage()
            clearStage()
            game()
        when 'error'
            alert(message.data)
        when 'give'
            ca.push(message.data)
        when 'uno'
            alert("#{message.data} forgot to say uno")
        when 'turn'
            current = ''
            for p in message.data.players
                if p.playing
                    current = p
                getName2(p.name)
                getNumber(p.name, p.cards)
            getCheck(current.name)
            playing = current.name == playerName
            currentCard = message.data.card
            updateCard()
            console.log 'turn'
        when 'gg'
            # TODO end game sequence
            console.log 'gg'
        else
            # TODO display that an unknown type was recived
            console.log 'unknown response'
    return

wildFour = ->
    for card, index in ca
        if card.color == currentCard.color or card.value == currentCard.value
            return true
    return false

getName2 = (Pname) ->
    count = listDict[Pname]
    listName = new PIXI.Text(Pname, nameStyle)
    listName.x = (window.innerWidth / 2) - 530
    listName.y = (window.innerHeight/2) - 120 + (40 * count)
    app.stage.addChild(listName)
    return

getNumber = (Pname, norwhatever) ->
    for p in app.stage.children
        if p.number
            app.stage.remove(p)
    count = listDict[Pname]
    listNum = new PIXI.Text(norwhatever, nameStyle)
    listNum.x = (window.innerWidth / 2) - 380
    listNum.y = (window.innerHeight/2) - 120 + (40 * count)
    listNum.number = norwhatever
    app.stage.addChild(listNum)
    return

setTurn = (Pname) ->
    for p in app.stage.children
        if p.turn
            app.stage.remove(p)
    count = listDict[Pname]
    arrow = new PIXI.Sprite.fromImage('../static/assets/buttons/grainCheck.png')
    arrow.scale.x = arrow.scale.y = scale
    arrow.x = (window.innerWidth / 2) - 560
    arrow.y = (window.innerHeight/2) - 120 + (40 * count)
    app.stage.addChild(arrow)
    return
