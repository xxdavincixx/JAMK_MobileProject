local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local ads = require( "ads" )

local params
local playButton

local myData = require( "mydata" )


if ( myData.settings.musicOn == true) then
        local backgroundMusicChannel = audio.play( audio.loadStream( "audio/menuMusic.mp3" ), { channel=1, loops=-1 } )
end

if ( myData.settings.username == "") then
    composer.showOverlay( "username_overlay" , { effect = "crossFade", time = 333, isModal = true } )
end


local function handlePlayButtonEvent( event )
    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then            
            composer.removeScene( "levelselect", false )
            composer.gotoScene("levelselect", { effect = "crossFade", time = 333 })
            local btnUnpushed = { type="image", filename=event.target.unpushed }
            event.target.fill = btnUnpushed
    end
end

local function handleHelpButtonEvent( event )
    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then        
        composer.gotoScene("help", { effect = "crossFade", time = 333, isModal = true })
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end
end

local function handleCreditsButtonEvent( event )    
    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then
        composer.gotoScene("gamecredits", { effect = "crossFade", time = 333 })
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end
end

local function handleSettingsButtonEvent( event )
    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then
        composer.gotoScene("gamesettings", { effect = "crossFade", time = 333 })
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end
end

--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params

    local sceneGroup = scene.view
    
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    local background = display.newImageRect( "images/Titelbildschirm.png", display.contentWidth, display.contentHeight )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )


    local playButton = display.newImageRect( "images/Buttons/Main Menu/button_play.png", 132, 40 )
    playButton.pushed = "images/Buttons/Main Menu/button_play_pushed.png"
    playButton.unpushed = "images/Buttons/Main Menu/button_play.png"
    playButton.x = display.contentCenterX + 70
    playButton.y = display.contentCenterY - 40
    playButton:addEventListener("touch", handlePlayButtonEvent)
    sceneGroup:insert( playButton )

    local settingsButton = display.newImageRect( "images/Buttons/Main Menu/button_settings.png", 132, 40 )
    settingsButton.pushed = "images/Buttons/Main Menu/button_settings_pushed.png"
    settingsButton.unpushed = "images/Buttons/Main Menu/button_settings.png"
    settingsButton.x = display.contentCenterX + 70
    settingsButton.y = display.contentCenterY + 10
    settingsButton:addEventListener("touch", handleSettingsButtonEvent) 
    sceneGroup:insert( settingsButton )

    local helpButton = display.newImageRect( "images/Buttons/Main Menu/button_help.png", 132, 40 )
    helpButton.pushed = "images/Buttons/Main Menu/button_help_pushed.png"
    helpButton.unpushed = "images/Buttons/Main Menu/button_help.png"
    helpButton.x = display.contentCenterX + 70
    helpButton.y = display.contentCenterY + 60
    helpButton:addEventListener("touch", handleHelpButtonEvent)
    sceneGroup:insert( helpButton )

    local creditsButton = display.newImageRect( "images/Buttons/Main Menu/button_credits.png", 132, 40 )
    creditsButton.pushed = "images/Buttons/Main Menu/button_credits_pushed.png"
    creditsButton.unpushed = "images/Buttons/Main Menu/button_credits.png"
    creditsButton.x = display.contentCenterX + 70
    creditsButton.y = display.contentCenterY + 110
    creditsButton:addEventListener("touch", handleCreditsButtonEvent)
    sceneGroup:insert( creditsButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params
    utility.print_r(event)

    if params then
        print(params.someKey)
        print(params.someOtherKey)
    end

    if event.phase == "did" then
        composer.removeScene( "game" ) 
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
