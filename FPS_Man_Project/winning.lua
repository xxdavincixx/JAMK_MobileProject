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
local localRecordText = ""
local onlineRecordText = ""

local function toLevelSelectFunction( event )

    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then            
        local options = {
            effect = "crossFade",
            time = 500,
            params = {
                someKey = "someValue",
                someOtherKey = 10
            }
        }
        composer.removeScene(composer.getSceneName("previous"))
        composer.gotoScene( "levelselect", options )
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end
end

local function restartFunction( event )

    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then            
        local options = {
            effect = "crossFade",
            time = 500,
            params = {
                someKey = "someValue",
                someOtherKey = 10
            }
        }
        composer.removeScene(composer.getSceneName("previous"))
        composer.gotoScene(composer.getSceneName("previous"), options)
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
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
    local background = display.newImageRect("images/Background/sky_low.png", display.contentWidth*2, display.contentHeight*2 )
    sceneGroup:insert(background)

    local gameOverText = display.newText("LEVEL COMPLETE", 0, 0, native.systemFontBold, 32 )
    gameOverText:setFillColor( 1 )
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

    local completeFpsText = display.newText(options)
    completeFpsText.text = "Frames per second: "
    completeFpsText:setFillColor( 1 )
    completeFpsText.y = 100
    sceneGroup:insert(completeFpsText)

    local yourTimeText = display.newText(options)
    yourTimeText.text = "Your time: "
    yourTimeText:setFillColor( 1 )
    yourTimeText.y = 140
    sceneGroup:insert(yourTimeText)

    local bestTimeText = display.newText(options)
    bestTimeText.text = "Best time: "
    bestTimeText:setFillColor( 1 )
    bestTimeText.y = 180
    sceneGroup:insert(bestTimeText)

    local bestOnlineTimeText = display.newText(options)
    bestOnlineTimeText.text = "Best online time: "
    bestOnlineTimeText:setFillColor( 1 )
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

    local completeFps = display.newText(options2)
    completeFps.text = params.fps
    completeFps:setFillColor( 1 )
    completeFps.y = 100
    sceneGroup:insert(completeFps)

    local yourTime = display.newText(options2)
    yourTime.text = params.myTime
    yourTime:setFillColor( 1 )
    yourTime.y = 140
    sceneGroup:insert(yourTime)

    if(params.localRecord) then
        localRecordText = display.newImageRect("images/record_symbol.png", 100, 48)
        localRecordText.x = 450
        localRecordText.y = 180
        localRecordText:scale(0.75, 0.75)
        sceneGroup:insert(localRecordText)
    end

    local bestTime = display.newText(options2)
    bestTime.text = params.localTime
    bestTime:setFillColor( 1 )
    bestTime.y = 180
    sceneGroup:insert(bestTime)

    if(params.onlineRecord) then
        onlineRecordText = display.newImageRect("images/record_symbol.png", 100, 48)
        onlineRecordText.x = 450
        onlineRecordText.y = 220
        onlineRecordText:scale(0.75, 0.75)
        sceneGroup:insert(onlineRecordText)
    end

    local bestOnlineTime = display.newText(options2)
    bestOnlineTime.text = params.onlineTime
    bestOnlineTime:setFillColor( 1 )
    bestOnlineTime.y = 220
    sceneGroup:insert(bestOnlineTime)

    local restartBtn = display.newImageRect("images/Buttons/Pause/button_restart.png", 64, 64)
    restartBtn.pushed = "images/Buttons/Pause/button_restart_pushed.png"
    restartBtn.unpushed = "images/Buttons/Pause/button_restart.png"
    restartBtn:addEventListener("touch", restartFunction)
    restartBtn.x = display.contentWidth * 0.1
    restartBtn.y = display.contentHeight - 40
    sceneGroup:insert( restartBtn )

    local toLevelSelectBtn = display.newImageRect("images/Buttons/Pause/button_backtomenu.png", 64, 64)
    toLevelSelectBtn.pushed = "images/Buttons/Pause/button_backtomenu_pushed.png"
    toLevelSelectBtn.unpushed = "images/Buttons/Pause/button_backtomenu.png"
    toLevelSelectBtn:addEventListener("touch", toLevelSelectFunction)
    toLevelSelectBtn.x = display.contentWidth * 0.9
    toLevelSelectBtn.y = display.contentHeight - 40
    sceneGroup:insert( toLevelSelectBtn )

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
