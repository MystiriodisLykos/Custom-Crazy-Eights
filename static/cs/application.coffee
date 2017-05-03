app = new PIXI.Application(window.innerWidth - 25, window.innerHeight - 25, {
    backgroundColor: 0x1099bb
})

graphics = new PIXI.Graphics()
PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST

ca = []
#ca = ["../static/assets/uno cards/green_6.png",
#      "../static/assets/uno cards/blue_6.png",
#      "../static/assets/uno cards/wild.png",
#      "../static/assets/uno cards/green_9.png",
#      "../static/assets/uno cards/yellow_9.png",
#      "../static/assets/uno cards/red_1.png",
#      "../static/assets/uno cards/green_3.png",
#      "../static/assets/uno cards/blue_7.png",
#      "../static/assets/uno cards/red_skip.png",
#      "../static/assets/uno cards/yellow_8.png",
#      "../static/assets/uno cards/green_reverse.png",
#      "../static/assets/uno cards/yellow_4.png",
#      "../static/assets/uno cards/red_1.png",
#      "../static/assets/uno cards/blue_9.png"]

#ca = ['uno cards/wild.png', 'uno cards/red_1.png', 'uno cards/green_3.png']

start = 1
scale = 0.2
cardWidth = 586
cardHeight = 878
max = 9
end = 9
playerName = ""

rightArr = PIXI.Sprite.fromImage('../static/assets/buttons/rightArrow.png')
leftArr = PIXI.Sprite.fromImage('../static/assets/buttons/leftArrow.png')
ubutt = PIXI.Sprite.fromImage('../static/assets/buttons/ubutton.png')
noplay = PIXI.Sprite.fromImage('../static/assets/buttons/no.png')
upCard = PIXI.Sprite.fromImage('../static/assets/cards/green_7.png')
join = PIXI.Sprite.fromImage('../static/assets/buttons/join.png')
ready = PIXI.Sprite.fromImage('../static/assets/buttons/ready.png')
input = new PixiTextInput()
faceDown = PIXI.Sprite.fromImage('../static/assets/cards/face_down.png')
red = PIXI.Sprite.fromImage('../static/assets/colors/radam.png')
blue = PIXI.Sprite.fromImage('../static/assets/colors/blue.png')
green = PIXI.Sprite.fromImage('../static/assets/colors/grain.png')
yellow = PIXI.Sprite.fromImage('../static/assets/colors/yellow.png')
pickColor = new PIXI.Text("Choose a color:", nameStyle)

cardSprites = []
#card = PIXI.Sprite.fromImage('uno cards/face_down.png')

nameCount = 0

nameStyle = new PIXI.TextStyle(
    fontFamily: 'Arial',
    fontSize: 24,
    wordwrap: true
)

# Global dictionary to store player's names and Y value
listDict = {}
#ca2 = []
# listDict['Brendan'] = 2

document.body.appendChild(app.view)

window.onload = (e) ->
    welcome()
#    draw()
    return

#Card = (color, num) ->
#  @color = color
#  @num = num
##  @getInfo = getCardInfo
#  return

#card1 = new Card('green', '7')
#card2 = new Card('blue', '6')
#card3 = new Card('yellow', '7')
#
#ca2 = [card1,card2,card3]

window.onresize = (e) ->
    w = window.innerWidth - 25
    h = window.innerHeight - 25
    app.view.style.width = w + 'px'
    app.view.style.height = h + 'px'
    renderer.resize(w, y)
    return

# TODO Need game play functionality to gray out cards that can't not legally be played. (or can not click on them)

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
    ready.on('pointerdown', onClickReady)
    # text for ready click
    check = new PIXI.Text("Click check mark when ready", nameStyle)
    check.x = (window.innerWidth / 2) - 555
    check.y = (window.innerHeight / 2) + 25
    app.stage.addChild(check)

    # Removes the join button
    app.stage.removeChild(join)
    return

welcome = ->
    # Draws the join button
    join = PIXI.Sprite.fromImage('../static/assets/buttons/join.png')
    join.anchor.set(.5)
    join.scale.x = join.scale.y *= .35
    join.x = (window.innerWidth / 2) - 55
    join.y = (window.innerHeight / 2) - 32.5
    join.interactive = true
    join.buttonMode = true
    app.stage.addChild(join)

    border = PIXI.Sprite.fromImage('../static/assets/buttons/border.png')
    border.anchor.set(.5)
    border.scale.x = border.scale.y *= .45
    border.x = (window.innerWidth / 2) + 400
    border.y = (window.innerHeight / 2) + 40
    app.stage.addChild(border)

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

    # text for no play button
    welcomePageHead = new PIXI.Text("Welcome to UNO!", welcStyle)
    welcomePageHead.x = (window.innerWidth / 2) - 610
    welcomePageHead.y = (window.innerHeight / 2) - 300
    app.stage.addChild(welcomePageHead)

    boxStyle = new PIXI.TextStyle(
        fontFamily: 'Comic Sans MS',
        fontSize: 30
    )
    # text for enter name here
    nameHere = new PIXI.Text("Enter your username:", nameStyle)
    nameHere.x = (window.innerWidth / 2) - 575
    nameHere.y = (window.innerHeight / 2) - 45
    app.stage.addChild(nameHere)

    #Players Heading
    playas = new PIXI.Text("PLAYERS", boxStyle)
    playas.x = (window.innerWidth / 2) + 340
    playas.y = (window.innerHeight / 2) - 190
    app.stage.addChild(playas)

#    Text box to enter player's name
    input.width = 150
    input.height = 40
    input.position.x = (window.innerWidth / 2) - 315
    input.position.y = (window.innerHeight / 2) - 53
    input.text= "Name"
    app.stage.addChild(input)

    join.on('pointerdown', onClickJoin)
    return

draw = ->
    clearStage()
    #  offset = 0
    #  if ca.length % 2 == 0
    #    offset = cardWidth*scale/4
    # draw the left triangle for carousel
    leftArr.anchor.set(.5)
    leftArr.scale.x = leftArr.scale.y = scale
    leftArr.x = (window.innerWidth / 2) - 290
    leftArr.y = (window.innerHeight / 2) + 150
    leftArr.interactive = true
    leftArr.buttonMode = true
    app.stage.addChild(leftArr)

    # draw the right triangle for carousel
    rightArr.anchor.set(.5)
    rightArr.scale.x = rightArr.scale.y = scale
    rightArr.x = (window.innerWidth / 2) + 385
    rightArr.y = (window.innerHeight / 2) + 150
    rightArr.interactive = true
    rightArr.buttonMode = true
    app.stage.addChild(rightArr)

    # draw the uno button
    ubutt.anchor.set(.5)
    ubutt.scale.x = ubutt.scale.y = scale
    ubutt.x = (window.innerWidth / 2) - 420
    ubutt.y = (window.innerHeight / 2) + 150
    ubutt.interactive = true
    ubutt.buttonMode = true
    app.stage.addChild(ubutt)

    # draw the no play button
    noplay.anchor.set(.5)
    noplay.scale.x = noplay.scale.y = scale
    noplay.x = (window.innerWidth / 2) - 575
    noplay.y = (window.innerHeight / 2) + 150
    noplay.interactive = true
    noplay.buttonMode = true
    app.stage.addChild(noplay)

    # style for text for no play button
    style = new PIXI.TextStyle(
        fontFamily: 'Arial',
        fontSize: 11
        wordWrap: true,
        wordWrapWidth: 75
    )

    # text for no play button
    unableToPlay = new PIXI.Text("Click red button if you do not have a card to play", style)
    unableToPlay.x = (window.innerWidth / 2) - 610
    unableToPlay.y = (window.innerHeight / 2) + 175
    app.stage.addChild(unableToPlay)

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

    welcomeToUno = new PIXI.Text("Let's Play UNO!!!", style1)
    welcomeToUno.x = (window.innerWidth / 2) - 500
    welcomeToUno.y = (window.innerHeight) - 650
    app.stage.addChild(welcomeToUno)

    #Draw current card
    upCard.anchor.set(.5)
    upCard.scale.x = upCard.scale.y = scale
    upCard.x = (window.innerWidth / 2) + 75
    upCard.y = (window.innerHeight / 2) - 75
    app.stage.addChild(upCard)

    #Draw face down card
    faceDown.anchor.set(.5)
    faceDown.scale.x = faceDown.scale.y = scale
    faceDown.x = (window.innerWidth / 2) - 75
    faceDown.y = (window.innerHeight / 2) - 75
    app.stage.addChild(faceDown)

    # display cards in hand (up to max)
    for cardStr, index in ca
        if index <= end and index >= start
            index -= start
            offset = 5 - index
            start = '../static/assets/cards/'
            cardStr = start + cardStr.color + "_" + cardStr.value + ".png"
            card = PIXI.Sprite.fromImage(cardStr)
            card.anchor.set(.5)
            card.y = 500
            card.x = app.renderer.width / 2
            card.x += (cardWidth * scale / 2) * offset
            card.scale.x = card.scale.y = scale
            card.interactive = true
            card.buttonMode = true
            card.name = cardStr
            card.on('pointerdown', clickCard)
            app.stage.addChild(card)
    leftArr.on('pointerdown', onClickLeft)
    rightArr.on('pointerdown', onClickRight)
    ubutt.on('pointerdown', onClickUno)
    noplay.on('pointerdown', onClickNo)
    return

wild = ->
    red.scale.x = red.scale.y = scale
    red.anchor.set(.5)
    red.x = (window.innerWidth / 2) - 450
    red.y = (window.innerHeight / 2) - 100
    red.interactive = true
    red.buttonMode = true
    red.on('pointerdown', clickRed)
    app.stage.addChild(red)

    blue.scale.x = blue.scale.y = scale
    blue.anchor.set(.5)
    blue.x = (window.innerWidth / 2) - 350
    blue.y = (window.innerHeight / 2) - 100
    blue.interactive = true
    blue.buttonMode = true
    blue.on('pointerdown', clickBlue)
    app.stage.addChild(blue)

    yellow.scale.x = yellow.scale.y = scale
    yellow.anchor.set(.5)
    yellow.x = (window.innerWidth / 2) - 450
    yellow.y = (window.innerHeight / 2)
    yellow.interactive = true
    yellow.buttonMode = true
    yellow.on('pointerdown', clickYellow)
    app.stage.addChild(yellow)

    green.scale.x = green.scale.y = scale
    green.anchor.set(.5)
    green.x = (window.innerWidth / 2) - 350
    green.y = (window.innerHeight / 2)
    green.interactive = true
    green.buttonMode = true
    green.on('pointerdown', clickGreen)
    app.stage.addChild(green)

    pickColor = new PIXI.Text("Choose a color:", nameStyle)
    pickColor.x = (window.innerWidth / 2) - 490
    pickColor.y = (window.innerHeight / 2) - 180
    app.stage.addChild(pickColor)
    return

onClickRight = ->
    clearStage()
    if start != 0
        start -= 1
        end -= 1
    draw()
    return

onClickLeft = ->
    if end != ca.length - 1
        start += 1
        end += 1
    draw()
    return

onClickUno = ->
    ubutt.scale.x *= 1.25
    ubutt.scale.y *= 1.25
    return

onClickNo = ->
    return

clickCard = ->
    if @name.indexOf('wild') != -1
        wild()

onClickJoin = ->
# When clicked, needs to send name to the server should be stored in text.input
    playerName = input.text
    message = JSON.stringify({name: playerName, type: 'add', data: ''})
#    console.log(message)
    server.send(message)
#  TODO make JOIN button change on click (push-in or change color) so that user knows they clicked it)
    return

onClickReady = ->
    message = JSON.stringify({name: playerName, type: 'ready', data: ''})
    console.log(message)
    server.send(message)
    return
    return

clickRed = (color) ->
    color = 'red'
    app.stage.removeChild(red)
    app.stage.removeChild(blue)
    app.stage.removeChild(green)
    app.stage.removeChild(yellow)
    app.stage.removeChild(pickColor)
    return color

clickBlue = (color) ->
    color = 'blue'
    app.stage.removeChild(red)
    app.stage.removeChild(blue)
    app.stage.removeChild(green)
    app.stage.removeChild(yellow)
    app.stage.removeChild(pickColor)
    return color

clickGreen = (color) ->
    color = 'green'
    app.stage.removeChild(red)
    app.stage.removeChild(blue)
    app.stage.removeChild(green)
    app.stage.removeChild(yellow)
    app.stage.removeChild(pickColor)
    return color

clickYellow = (color) ->
    color = 'yellow'
    app.stage.removeChild(red)
    app.stage.removeChild(blue)
    app.stage.removeChild(green)
    app.stage.removeChild(yellow)
    app.stage.removeChild(pickColor)
    return color

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
#    ready.anchor.set(.5)
    ready.scale.x = ready.scale.y = scale * .25
    ready.x = window.innerWidth / 2 + 300 + 100
    ready.y = window.innerHeight / 2 + ((75 * number) - 200)
    app.stage.addChild(ready)
    return

if window.location.protocol == 'https:'
    ws_scheme = 'wss://'
else
    ws_scheme = 'ws://'

server = new ReconnectingWebSocket(ws_scheme + location.host + "/server")

server.onmessage = (message) ->
    message = JSON.parse(message.data)
    console.log(message)
    switch message.type
        when 'welcome'
            if not (message.data of listDict)
                getName(message.data)
                readyToPlay()
            # TODO add this player to list of players
        when 'ready'
            getCheck(message.data)
        when 'start'
            # TODO start game
            clearStage()
            clearStage()
            clearStage()
            draw()
        when 'error'
            # TODO show error message to screen
            console.log 'error'
        when 'give'
            # TODO add card to array
            ca.push(message.data)
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
