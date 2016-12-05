local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local myData = require( "mydata" )
local gameNetwork = require( "gameNetwork" )
local device = require( "device" )

local params
local newHighScore = false

local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        local options = {
            effect = "crossFade",
            time = 500,
            params = {
                someKey = "someValue",
                someOtherKey = 10
            }
        }
        
        composer.removeScene(composer.getSceneName("previous"))
        composer.gotoScene( "menu", options )
    end
    return true
end

local function showLeaderboard( event )
    if event.phase == "ended" then
        gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime"}} )
    end
    return true
end

local function postToGameNetwork()
    local category = "com.yourdomain.yourgame.leaderboard"
    if myData.isGPGS then
        category = "CgkIusrvppwDJFHJKDFg"
    end
    gameNetwork.request("setHighScore", {
        localPlayerScore = {
            category = category, 
            value = myData.settings.bestScore
        },
        listener = postScoreSubmit
    })
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
local function restartFunction(event)
    --parentScene
    if event.phase == "ended" then
        composer.removeScene(composer.getSceneName("previous"))
        composer.gotoScene(composer.getSceneName("previous"), options)
    end
    return true   
end

local function toMenuFunction(event)
    composer.hideOverlay( "crossFade", 333 )
    composer.removeScene( "menu" )                      
    composer.gotoScene( "menu", { time= 500, effect = "crossFade" } )
    return true  
end

    local background = display.newRect( 0, 0, 570, 360)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background:setFillColor( 0 )
    sceneGroup:insert(background)

    local gameOverText = display.newText("0 Frames Per Second", 0, 0, native.systemFontBold, 24 )
    gameOverText:setFillColor( 204/255, 0, 25/255 )
    gameOverText.x = display.contentCenterX
    gameOverText.y = 100
    sceneGroup:insert(gameOverText)

    local gameOverText = display.newText("Time has stopped. You lose.", 0, 0, native.systemFontBold, 24 )
    gameOverText:setFillColor( 204/255, 0, 25/255 )
    gameOverText.x = display.contentCenterX
    gameOverText.y = 130
    sceneGroup:insert(gameOverText)

    --local gameOverText = display.newText("You lose.", 0, 0, native.systemFontBold, 32 )
    --gameOverText:setFillColor( 204/255, 0, 25/255 )
    --gameOverText.x = display.contentCenterX
    --gameOverText.y = 150
    --sceneGroup:insert(gameOverText)

    local restartIcon = display.newImageRect( "images/Buttons/Gameover/button_restart_game_over.png", 72, 72 )
    restartIcon.x = display.contentWidth -60
    restartIcon.y = display.contentHeight -60
    sceneGroup:insert(restartIcon)
    restartIcon:addEventListener("touch", restartFunction)

    local toMenuIcon = display.newImageRect( "images/Buttons/Gameover/button_menu_game_over.png", 72, 72 )
    toMenuIcon.x = 60
    toMenuIcon.y = display.contentHeight -60
    sceneGroup:insert(toMenuIcon)
    toMenuIcon:addEventListener("touch", toMenuFunction)

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
        --
        -- Hook up your score code here to support updating your leaderboards
        --[[
        if newHighScore then
            local popup = display.newText("New High Score", 0, 0, native.systemFontBold, 32)
            popup.x = display.contentCenterX
            popup.y = display.contentCenterY
            sceneGroup:insert( popup )
            postToGameNetwork(); 
        end
        --]]
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
