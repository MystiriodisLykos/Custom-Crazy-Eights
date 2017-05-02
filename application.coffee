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
upCard = PIXI.Sprite.fromImage('uno cards/green_7.png')
join = PIXI.Sprite.fromImage('buttons/join.png')
ready = PIXI.Sprite.fromImage('buttons/ready.png')
input = new PixiTextInput()
faceDown = PIXI.Sprite.fromImage('uno cards/face_down.png')

cardSprites = []
#card = PIXI.Sprite.fromImage('uno cards/face_down.png')

nameStyle = new PIXI.TextStyle(
    fontFamily: 'Arial',
    fontSize: 24,
    wordwrap: true
)

document.body.appendChild(app.view)

window.onload = (e) ->
    welcome()
#    draw()
    leftArr.on('pointerdown', onClickLeft)
    rightArr.on('pointerdown', onClickRight)
    ubutt.on('pointerdown', onClickUno)
    noplay.on('pointerdown', onClickNo)
    join.on('pointerdown', onClickJoin)
    ready.on('pointerdown', onClickReady)
    return

window.onresize = (e) ->
    w = window.innerWidth - 25
    h = window.innerHeight - 25
    app.view.style.width = w + 'px'
    app.view.style.height = h + 'px'
    renderer.resize(w, y)
    return

#  TODO Another function that takes a name to add check mark next to player's name. Use dictionary from getName
# TODO A function to pop up graphics to have player choose color when a WILD card is played

readyToPlay = ->
#  TODO Remove the join button
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
    check.x = (window.innerWidth / 2) - 555
    check.y = (window.innerHeight / 2) + 25
    app.stage.addChild(check)
    return

welcome = ->
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
    border.x = (window.innerWidth / 2) + 400
    border.y = (window.innerHeight / 2) + 40
    border.interactive = true
    border.buttonMode = true
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

    #Enter name here
#    nameStyle = new PIXI.TextStyle(
#        fontFamily: 'Arial',
#        fontSize: 24,
#        wordwrap: true
#    )

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
    listName = new PIXI.Text(Pname, nameStyle)
    listName.x = (window.innerWidth / 2) + 300
    listName.y = (window.innerHeight / 2) - 100
# TODO Create a dictionary to store the name and the y-value to know where to place check-mark : Initialize in Global scope
    app.stage.addChild(listName)
    return

# And/or takes the name and a boolean that they are ready and puts a check mark in the list next to the name
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
    #    for child in app.stage.schildren
    #        child.on('pointerdown', () -> child.scale.x *= 2)
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
    noplay.scale.x *= 1.25
    noplay.scale.y *= 1.25
    return

clickCard = ->
    @scale.x *= 1.2
    @scale.y *= 1.2

onClickJoin = ->
# When clicked, needs to send name to the server should be stored in text.input
    console.log("This is the player's name: " + input.text)
    playerName = input.text
    getName(playerName)
    return

onClickReady = ->
# Needs to send flag to server to indicate that player is ready to play
    return

clearStage = ->
    for child in app.stage.children
        app.stage.removeChild(child)
    return
