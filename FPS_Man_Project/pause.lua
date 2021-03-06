local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )


local bg
local title
local button
local pauseTitleText
local parentScene


local function resumeFunction(event)
    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then            
        composer.hideOverlay( "crossFade", 333 )
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end

    return true
end

local function restartFunction(event)

    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then            
        
        local restartString = "restartLvl" .. event.target.cLevelNumber
        composer.gotoScene( tostring(restartString), { time= 100, effect = "crossFade" } )
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end

    return true   
end

local function toMenuFunction(event)
    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then            
        composer.hideOverlay( "crossFade", 333 )
        composer.removeScene( "levelselect" )                      
        composer.gotoScene( "levelselect", { time= 500, effect = "crossFade" } )
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end

    return true  
end

-- create()
function scene:create( event )

    local sceneGroup = self.view
    parentScene = event.parent
    params = event.params

    print("####### " .. params.cLevelNumber)

    bg = display.newImageRect("images/Background/sky_low.png", display.contentWidth*2, display.contentHeight*2)
    bg:setFillColor(1,1,1)
    --bg:scale(0.80, 0.80)
    sceneGroup:insert(bg)

    pauseTitleText = display.newText("PAUSE", display.contentCenterX, 50, native.systemFontBold, 64)
    pauseTitleText:setFillColor(1,1,1)
    sceneGroup:insert(pauseTitleText)


    local resumeIcon = display.newImageRect( "images/Buttons/Pause/button_resume.png", 128, 128 )
    resumeIcon.pushed = "images/Buttons/Pause/button_resume_pushed.png"
    resumeIcon.unpushed = "images/Buttons/Pause/button_resume.png"
    resumeIcon.x = display.contentWidth * 0.20
    resumeIcon.y = display.contentHeight * 0.65
    sceneGroup:insert(resumeIcon)
    resumeIcon:addEventListener("touch", resumeFunction)

    local restartIcon = display.newImageRect( "images/Buttons/Pause/button_restart.png", 128, 128 )
    restartIcon.pushed = "images/Buttons/Pause/button_restart_pushed.png"
    restartIcon.unpushed = "images/Buttons/Pause/button_restart.png"
    restartIcon.cLevelNumber = params.cLevelNumber
    restartIcon.x = display.contentWidth * 0.5
    restartIcon.y = display.contentHeight * 0.65
    sceneGroup:insert(restartIcon)
    restartIcon:addEventListener("touch", restartFunction)

    local toMenuIcon = display.newImageRect( "images/Buttons/Pause/button_backtomenu.png", 128, 128 )
    toMenuIcon.pushed = "images/Buttons/Pause/button_backtomenu_pushed.png"
    toMenuIcon.unpushed = "images/Buttons/Pause/button_backtomenu.png"
    toMenuIcon.x = display.contentWidth * 0.80
    toMenuIcon.y = display.contentHeight * 0.65
    sceneGroup:insert(toMenuIcon)
    toMenuIcon:addEventListener("touch", toMenuFunction)

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen



    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

        -- Call the "resumeGame()" function in the parent scene
        parent:resumeGame()

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
