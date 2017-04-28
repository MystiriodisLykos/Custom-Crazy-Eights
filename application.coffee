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
max = 10
end = 4
rightArr = PIXI.Sprite.fromImage('buttons/rightArrow.png')
leftArr = PIXI.Sprite.fromImage('buttons/leftArrow.png')
ubutt = PIXI.Sprite.fromImage('buttons/ubutton.png')
noplay = PIXI.Sprite.fromImage('buttons/no.png')
upCard = PIXI.Sprite.fromImage('uno cards/green_7.png')
faceDown = PIXI.Sprite.fromImage('uno cards/face_down.png')

document.body.appendChild(app.view)

window.onload = (e) ->
    draw()
    leftArr.on('pointerdown', onClickLeft)
    rightArr.on('pointerdown', onClickRight)
    ubutt.on('pointerdown', onClickUno)
    noplay.on('pointerdown', onClickNo)

    return

window.onresize = (e) ->
    w = window.innerWidth - 25
    h = window.innerHeight - 25
    app.view.style.width = w + 'px'
    app.view.style.height = h + 'px'
    renderer.resize(w, y)
    return

draw = ->
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
    rightArr.x = 1250
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
        fontSize: 36
    )

    welcomeToUno = new PIXI.Text("Welcome to UNO! For 2-10 players, ages 7+", style1)
    welcomeToUno.x = (window.innerWidth / 2) - 350
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
            app.stage.addChild(card)
    return

onClickRight = ->
    clearStage()
    if start != 0
        start -= 1
        end -= 1
    draw()
    return

onClickLeft = ->
    clearStage()
    if end != ca.length-1
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

clearStage = ->
    for child in app.stage.children
        app.stage.removeChild(child)
    return