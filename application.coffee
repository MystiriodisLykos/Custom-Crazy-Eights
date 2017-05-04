app = new PIXI.Application(window.innerWidth - 25, window.innerHeight - 25, {
    backgroundColor: 0x1099bb
})

graphics = new PIXI.Graphics()
PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST
ca = ["uno cards/green_6.png", "uno cards/blue_6.png", "uno cards/wild.png", "uno cards/green_9.png",
    "uno cards/yellow_9.png", "uno cards/red_1.png", "uno cards/green_3.png", "uno cards/blue_7.png",
    "uno cards/red_skip.png", "uno cards/yellow_8.png", "uno cards/green_reverse.png", "uno cards/yellow_4.png",
    "uno cards/red_1.png", "uno cards/blue_9.png"]


#ca = ['uno cards/wild.png', 'uno cards/red_1.png', 'uno cards/green_3.png']

start = 1
scale = 0.2
cardWidth = 586
cardHeight = 878
max = 9
end = 9
playerName = ""
rightArr = PIXI.Sprite.fromImage('buttons/rightArrow.png')
leftArr = PIXI.Sprite.fromImage('buttons/leftArrow.png')
ubutt = PIXI.Sprite.fromImage('buttons/ubutton.png')
noplay = PIXI.Sprite.fromImage('buttons/no.png')
join = PIXI.Sprite.fromImage('buttons/join.png')
ready = PIXI.Sprite.fromImage('buttons/ready.png')
input = new PixiTextInput()
faceDown = PIXI.Sprite.fromImage('uno cards/face_down.png')
red = PIXI.Sprite.fromImage('colors/radam.png')
blue = PIXI.Sprite.fromImage('colors/blue.png')
green = PIXI.Sprite.fromImage('colors/grain.png')
yellow = PIXI.Sprite.fromImage('colors/yellow.png')
pickColor = new PIXI.Text("Choose a color:", nameStyle)
gb = PIXI.Sprite.fromImage('buttons/grainCheck.png')

cardSprites = []
#card = PIXI.Sprite.fromImage('uno cards/face_down.png')

nameCount = 0

nameStyle = new PIXI.TextStyle(
    fontFamily: 'Arial',
    fontSize: 24,
    wordwrap: true
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

# Global dictionary to store player's names and Y value
listDict = {}
ca2 = []
# listDict['Brendan'] = 2

document.body.appendChild(app.view)

class Card
    constructor: (@hue, @value) ->
        return

card1 = new Card('green', '7')
card2 = new Card('blue', '5')
card3 = new Card('yellow', '7')
card4 = new Card('wild','10')
card5 = new Card('wild', '11')
card6 = new Card('yellow', '9')
card7 = new Card('blue', '7')
card8 = new Card('red', '4')
card9 = new Card('red', '5')
card10 = new Card('blue', '8')
currentCard = new Card('green', '5')

ca2 = [card1,card2,card3,card4,card5,card6,card7,card8,card9,card10]

window.onload = (e) ->
    welcome()
#    draw()
#    wild()
    leftArr.on('pointerdown', onClickLeft)
    rightArr.on('pointerdown', onClickRight)
    ubutt.on('pointerdown', onClickUno)
    noplay.on('pointerdown', onClickNo)
    join.on('pointerdown', onClickJoin)
    ready.on('pointerdown', onClickReady)
#    card.on('pointerdown', clickCard)
    red.on('pointerdown', clickRed)
    blue.on('pointerdown', clickBlue)
    green.on('pointerdown', clickGreen)
    yellow.on('pointerdown', clickYellow)
    return

window.onresize = (e) ->
    w = window.innerWidth - 25
    h = window.innerHeight - 25
    app.view.style.width = w + 'px'
    app.view.style.height = h + 'px'
    renderer.resize(w, y)
    return

readyToPlay = ->
# Draws the check mark to indicate ready
    ready = PIXI.Sprite.fromImage('buttons/ready.png')
    ready.anchor.set(.5)
    ready.scale.x = ready.scale.y *= .04
    ready.x = (window.innerWidth / 2) - 180
    ready.y = (window.innerHeight / 2) + 55
    ready.interactive = true
    ready.buttonMode = true
    app.stage.addChild(ready)

    # text for ready click
    check = new PIXI.Text("Click check mark when ready", nameStyle)
    check.scale.x = check.scale.y = scale
    check.x = (window.innerWidth / 2) - 555
    check.y = (window.innerHeight / 2) + 25
    app.stage.addChild(check)

    # Removes the join button
    app.stage.removeChild(join)
    return

welcome = ->
    getName('Test')
    getName('Bubba')
    # Draws the join button
    join = PIXI.Sprite.fromImage('buttons/join.png')
    join.anchor.set(.5)
    join.scale.x = join.scale.y *= .35
    join.x = (window.innerWidth / 2) - 55
    join.y = (window.innerHeight / 2) - 32.5
    join.interactive = true
    join.buttonMode = true
    app.stage.addChild(join)

    border = PIXI.Sprite.fromImage('buttons/border.png')
    border.anchor.set(.5)
    border.scale.x = border.scale.y *= .45
    border.x = (window.innerWidth / 2) + 415
    border.y = (window.innerHeight / 2) + 40
    app.stage.addChild(border)

    # text for no play button
    welcomePageHead = new PIXI.Text("Welcome to UNO!", welcStyle)
    welcomePageHead.scale.x = welcomePageHead.scale.y *= 1.01
    welcomePageHead.x = (window.innerWidth / 2) - 610
    welcomePageHead.y = (window.innerHeight / 2) - 300
    app.stage.addChild(welcomePageHead)

    boxStyle = new PIXI.TextStyle(
        fontFamily: 'Comic Sans MS',
        fontSize: 30
    )
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

#    Text box to enter player's name
#    input = new PixiTextInput()
#    input.scale.x = input.scale.y = scale
    input.width = 150
    input.height = 40
    input.position.x = (window.innerWidth / 2) - 315
    input.position.y = (window.innerHeight / 2) - 53
    input.text = "Name"
    input.change = ->
        console.log 'text is: ' + input.text
    app.stage.addChild(input)
    return

# Function that takes a name and displays in the border/ player list
getName = (Pname) ->
    listDict[Pname] = nameCount
    nameCount++
    for key, value of listDict
        listName = new PIXI.Text(Pname, nameStyle)
        listName.x = window.innerWidth / 2 + 300
        listName.y = window.innerHeight / 2 + ((75 * nameCount) - 200)
        app.stage.addChild(listName)
    getCheck(Pname)
    return

# And/or takes the name and a boolean that they are ready and puts a check mark in the list next to the name
getCheck = (Pname) ->
    number = listDict[Pname]
    ready = PIXI.Sprite.fromImage('buttons/grainCheck.png')
#    ready.anchor.set(.5)
    ready.scale.x = ready.scale.y = scale
    ready.x = window.innerWidth / 2 + 300 + 100
    ready.y = window.innerHeight / 2 + ((75 * number) - 125)
    app.stage.addChild(ready)
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
    noplay.scale.x = noplay.scale.y *= 1.01
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
    welcomeToUno.scale.x = welcomeToUno.scale.y *= 1.01
    welcomeToUno.x = (window.innerWidth / 2) - 500
    welcomeToUno.y = (window.innerHeight) - 650
    app.stage.addChild(welcomeToUno)

    #Draw current card
    upCard = PIXI.Sprite.fromImage("uno cards/" + currentCard.hue + "_" + currentCard.value + ".png")
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
    for cardStr, index in ca2
        if index <= end and index >= start
            index -= start
            offset = 5 - index
            imageBuild = "uno cards/" + cardStr.hue + "_" + cardStr.value + ".png"
            card = PIXI.Sprite.fromImage(imageBuild)
            card.anchor.set(.5)
            card.y = 500
            card.x = app.renderer.width / 2
            card.x += (cardWidth * scale / 2) * offset
            card.scale.x = card.scale.y = scale
            card.interactive = true
            card.buttonMode = true
            card.name = imageBuild.split('/')[1]
            card.on('pointerdown', clickCard)
            app.stage.addChild(card)
    #    for child in app.stage.schildren
    #        child.on('pointerdown', () -> child.scale.x *= 2)
    return

wildFour = ->
    for cardStr, index in ca2
        if index <= end and index >= start
            index -= start
            offset = 5 - index
            imageBuild = "uno cards/" + cardStr.hue + "_" + cardStr.value + ".png"
            card = PIXI.Sprite.fromImage(imageBuild)
            card.anchor.set(.5)
            card.y = 500
            card.x = app.renderer.width / 2
            card.x += (cardWidth * scale / 2) * offset
            card.scale.x = card.scale.y = scale
            card.interactive = true
            card.buttonMode = true
            card.name = imageBuild.split('/')[1]
            card.on('pointerdown', clickCard)
            app.stage.addChild(card)
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

onClickLeft = ->
    clearStage()
    if start != 0
        start -= 1
        end -= 1
    draw()
    return

onClickRight = ->
    clearStage()
    clearStage()
    clearStage()
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
#  TODO Need to implement rule for Wild +4
    console.log("Card hue: " + (@name.split('_')[1]).split('.')[0] + "  Current Card hue: " + currentCard.value)
    if @name.indexOf('wild') != -1
        wild()
#        if (@name.split('_')[1]).split('.')[0] == 11

    if @name.split('_')[0] == currentCard.hue or (@name.split('_')[1]).split('.')[0] == currentCard.value
        @scale.x *= 1.2
        @scale.y *= 1.2

onClickJoin = ->
# When clicked, needs to send name to the server should be stored in text.input
    console.log("This is the player's name: " + input.text)
    playerName = input.text
    getName(playerName)
    clearStage()
    clearStage()
    clearStage()
    draw()
    return

onClickReady = ->
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


