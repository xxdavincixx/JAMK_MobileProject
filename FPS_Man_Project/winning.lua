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

--[[
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
]]
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
    local background = display.newRect( 0, 0, 570, 360)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background:setFillColor( 1 )
    sceneGroup:insert(background)

    local gameOverText = display.newText("LEVEL COMPLETE", 0, 0, native.systemFontBold, 32 )
    gameOverText:setFillColor( 0 )
    gameOverText.x = display.contentCenterX
    gameOverText.y = 50
    sceneGroup:insert(gameOverText)

    local options = {
       text = "",
       x = 290,
       width = 300,
       height = 24,
       fontSize = 24,
       align = "left"
    }
    --sceneGroup:insert(options)

    local completeFpsText = display.newText(options)
    completeFpsText.text = "Frames per second: "
    completeFpsText:setFillColor( 0 )
    completeFpsText.y = 100
    sceneGroup:insert(completeFpsText)

    local yourTimeText = display.newText(options)
    yourTimeText.text = "Your time: "
    yourTimeText:setFillColor( 0 )
    yourTimeText.y = 140
    sceneGroup:insert(yourTimeText)

    local bestTimeText = display.newText(options)
    bestTimeText.text = "Best time: "
    bestTimeText:setFillColor( 0 )
    bestTimeText.y = 180
    sceneGroup:insert(bestTimeText)

    local bestOnlineTimeText = display.newText(options)
    bestOnlineTimeText.text = "Best online time: "
    bestOnlineTimeText:setFillColor( 0 )
    bestOnlineTimeText.y = 220
    sceneGroup:insert(bestOnlineTimeText)

    local options2 = {
       text = "",
       x = 425,
       width = 125,
       height = 24,
       fontSize = 24,
       align = "left"
    }
    --sceneGroup:insert(options)

    local completeFps = display.newText(options2)
    completeFps.text = params.fps
    completeFps:setFillColor( 0 )
    completeFps.y = 100
    sceneGroup:insert(completeFps)

    local yourTime = display.newText(options2)
    yourTime.text = params.myTime
    yourTime:setFillColor( 0 )
    yourTime.y = 140
    sceneGroup:insert(yourTime)

    local bestTime = display.newText(options2)
    bestTime.text = params.localTime
    bestTime:setFillColor( 0 )
    bestTime.y = 180
    sceneGroup:insert(bestTime)

    local bestOnlineTime = display.newText(options2)
    bestOnlineTime.text = params.onlineTime
    bestOnlineTime:setFillColor( 0 )
    bestOnlineTime.y = 220
    sceneGroup:insert(bestOnlineTime)

--[[
    local leaderBoardButton = widget.newButton({
        id = "leaderboard",
        label = "Leaderboard",
        width = 125,
        height = 32,
        onEvent = showLeaderboard
    })
    leaderBoardButton.x = display.contentCenterX 
    leaderBoardButton.y = 225
    sceneGroup:insert( leaderBoardButton )
]]--

    local doneButton = widget.newButton({
        id = "button1",
        label = "Done",
        width = 100,
        height = 32,
        onEvent = handleButtonEvent
    })
    doneButton.x = display.contentCenterX
    doneButton.y = display.contentHeight - 40
    sceneGroup:insert( doneButton )
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
    print("destroy")
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
