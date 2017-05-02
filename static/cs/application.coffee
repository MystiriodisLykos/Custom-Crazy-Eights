app = new PIXI.Application(window.innerWidth - 25, window.innerHeight - 25, {
    backgroundColor: 0x1099bb
})

graphics = new PIXI.Graphics()
PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST
ca = ["../static/assets/uno cards/green_6.png",
      "../static/assets/uno cards/blue_6.png",
      "../static/assets/uno cards/wild.png",
      "../static/assets/uno cards/green_9.png",
      "../static/assets/uno cards/yellow_9.png",
      "../static/assets/uno cards/red_1.png",
      "../static/assets/uno cards/green_3.png",
      "../static/assets/uno cards/blue_7.png",
      "../static/assets/uno cards/red_skip.png",
      "../static/assets/uno cards/yellow_8.png",
      "../static/assets/uno cards/green_reverse.png", 
      "../static/assets/uno cards/yellow_4.png",
      "../static/assets/uno cards/red_1.png",
      "../static/assets/uno cards/blue_9.png"]

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
upCard = PIXI.Sprite.fromImage('../static/assets/uno cards/green_7.png')
join = PIXI.Sprite.fromImage('../static/assets/buttons/join.png')
ready = PIXI.Sprite.fromImage('../static/assets/buttons/ready.png')
input = new PixiTextInput()
faceDown = PIXI.Sprite.fromImage('../static/assets/uno cards/face_down.png')

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
# listDict['Brendan'] = 2

document.body.appendChild(app.view)

window.onload = (e) ->
    welcome()
#    draw()
    return

window.onresize = (e) ->
    w = window.innerWidth - 25
    h = window.innerHeight - 25
    app.view.style.width = w + 'px'
    app.view.style.height = h + 'px'
    renderer.resize(w, y)
    return

# TODO Another function that takes a name to add check mark next to player's name. Use dictionary from getName
# TODO A function to pop up graphics to have player choose color when a WILD card is played
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

    # text for ready click
    check = new PIXI.Text("Click check mark when ready", nameStyle)
    check.x = (window.innerWidth / 2) - 555
    check.y = (window.innerHeight / 2) + 25
    app.stage.addChild(check)

    # Removes the join button
    app.stage.removeChild(join)
    return

welcome = ->
    getName('Test')
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
#    input.scale.x = input.scale.y = scale
    input.width = 150
    input.height = 40
    input.position.x = (window.innerWidth / 2) - 315
    input.position.y = (window.innerHeight / 2) - 53
    input.text= "Name"
    app.stage.addChild(input)

    join.on('pointerdown', onClickJoin)
    ready.on('pointerdown', onClickReady)

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
    ready = PIXI.Sprite.fromImage('../static/assets/buttons/ready.png')
#    ready.anchor.set(.5)
    ready.scale.x = ready.scale.y = scale * .25
    ready.x = window.innerWidth / 2 + 300 + 100
    ready.y = window.innerHeight / 2 + ((75 * number) - 200)
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
    leftArr.x = 400
    leftArr.y = 500
    leftArr.interactive = true
    leftArr.buttonMode = true
    app.stage.addChild(leftArr)

    # draw the right triangle for carousel
    rightArr.anchor.set(.5)
    rightArr.scale.x = rightArr.scale.y = scale
    rightArr.x = 1060
    rightArr.y = 500
    rightArr.interactive = true
    rightArr.buttonMode = true
    app.stage.addChild(rightArr)

    # draw the uno button
    ubutt.anchor.set(.5)
    ubutt.scale.x = ubutt.scale.y = scale
    ubutt.x = 250
    ubutt.y = 500
    ubutt.interactive = true
    ubutt.buttonMode = true
    app.stage.addChild(ubutt)

    # draw the no play button
    noplay.anchor.set(.5)
    noplay.scale.x = noplay.scale.y = scale
    noplay.x = 100
    noplay.y = 500
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
    unableToPlay.x = 75
    unableToPlay.y = 525
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
    @scale.x *= 1.2
    @scale.y *= 1.2

onClickJoin = ->
# When clicked, needs to send name to the server should be stored in text.input
    playerName = input.text
    message = JSON.stringify({name: playerName, type: 'add', data: ''})
    console.log(message)
    window.server.send(message)
    getName(playerName)
#  TODO make JOIN button change on click (push-in or change color) so that user knows they clicked it)
    return

onClickReady = ->
# Needs to send flag to server to indicate that player is ready to play
    return

clearStage = ->
    for child in app.stage.children
        app.stage.removeChild(child)
    return
