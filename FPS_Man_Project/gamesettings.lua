local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local myData = require( "mydata" )
local utility = require( "utility" ) 
local device = require( "device" )

local params

-- Handle press events for the switches
local function onSoundSwitchPress( event )
    local switch = event.target

    if switch.isOn then
        myData.settings.soundOn = true
    else
        myData.settings.soundOn = false
    end
    utility.saveTable(myData.settings, "settings.json")
end

local function onMusicSwitchPress( event )
    local switch = event.target

    if not switch.isOn then
        myData.settings.musicOn = true
        print("Switch is now: " .. tostring(myData.settings.musicOn) .. " music is supposed to start")
        local backgroundMusicChannel = audio.play( audio.loadStream( "audio/menuMusic.mp3" ), { channel=1, loops=-1 } )
    else
        myData.settings.musicOn = false
        print("Switch is now: " .. tostring(myData.settings.musicOn) .. " music is supposed to end")
        audio.stop()
    end
    utility.saveTable(myData.settings, "settings.json")
end

-- Function to handle button events
local function handleButtonEvent( event )
    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end
end

-- Function to handle button events
local function handleChangeNameButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.showOverlay("username_overlay", { effect = "crossFade", time = 333, isModal = true })
    end
end



--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    local background = display.newImageRect("images/Background/sky_low.png", display.contentWidth*2, display.contentHeight*2 )
    sceneGroup:insert( background )

    local title = display.newImageRect("images/Logo.png", 400, 75) -- create title
    title.x = display.contentCenterX
    title.y = 40
    sceneGroup:insert( title )

    local soundLabel = display.newText("Sound Effects", 100, 32, native.systemFont, 18 )
    soundLabel.x = display.contentCenterX - 75
    soundLabel.y = 100
    soundLabel:setFillColor( 1 )
    sceneGroup:insert( soundLabel )

    local soundOnOffSwitch = widget.newSwitch({
        style = "onOff",
        id = "soundOnOffSwitch",
        initialSwitchState = myData.settings.soundOn,
        print(myData.settings.soundOn),
        onPress = onSoundSwitchPress
    })
    soundOnOffSwitch.x = display.contentCenterX + 100
    soundOnOffSwitch.y = soundLabel.y
    sceneGroup:insert( soundOnOffSwitch )

    local musicLabel = display.newText("Music", 100, 32, native.systemFont, 18 )
    musicLabel.x = display.contentCenterX - 75
    musicLabel.y = 150
    musicLabel:setFillColor( 1 )
    sceneGroup:insert( musicLabel )

    local musicOnOffSwitch = widget.newSwitch({
        style = "onOff",
        id = "musicOnOffSwitch",
        print("Switch is now: " .. tostring(myData.settings.musicOn)),
        initialSwitchState = myData.settings.musicOn,
        onPress = onMusicSwitchPress
    })
    musicOnOffSwitch.x = display.contentCenterX + 100
    musicOnOffSwitch.y = musicLabel.y
    sceneGroup:insert( musicOnOffSwitch )

    --[[
    -- change name Button
    local changeNameButton = display.newRect(display.contentCenterX, 200, 150, 32)

    changeNameButton:addEventListener("tap", handleChangeNameButtonEvent)
    changeNameButton:setFillColor(0.2,0.2,0.2)
    sceneGroup:insert( changeNameButton )

    local changeNameButtonText = display.newText("Change Username", display.contentCenterX, 200, native.systemFont, 15)
    sceneGroup:insert( changeNameButtonText )
    ]]

    -- Create change name button
    local changeNameButton = widget.newButton({
        id = "button2",
        label = "Change Username",
        --labelColor = {default = {1,1,1}},
        --fillColor = {default = {0,0,0,0}},
        width = 150,
        height = 32,
        onEvent = handleChangeNameButtonEvent
    })
    changeNameButton.x = display.contentCenterX 
    changeNameButton.y = 200
    sceneGroup:insert( changeNameButton )

    -- Done Button --
    local doneButton = display.newImageRect("images/Buttons/Pause/button_confirm.png", 32+16, 32+16)
    doneButton.pushed = "images/Buttons/Pause/button_confirm_pushed.png"
    doneButton.unpushed = "images/Buttons/Pause/button_confirm.png"
    doneButton.x = display.contentWidth*0.5
    doneButton.y = 260
    doneButton:addEventListener("touch", handleButtonEvent)
    sceneGroup:insert( doneButton )
end

function scene:show( event )
    local sceneGroup = self.view
    params = event.params

    if event.phase == "did" then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
