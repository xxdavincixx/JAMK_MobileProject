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
    composer.hideOverlay( "crossFade", 333 )

    return true
end

local function restartFunction(event)
    --parentScene
    if event.phase == "ended" then
        composer.gotoScene( "restartLvl1", { time= 100, effect = "crossFade" } )
    end

    return true   
end

local function toMenuFunction(event)
    composer.hideOverlay( "crossFade", 333 )
    composer.removeScene( "menu" )                      
    composer.gotoScene( "menu", { time= 500, effect = "crossFade" } )

    return true  
end

-- create()
function scene:create( event )

    local sceneGroup = self.view
    parentScene = event.parent

    bg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(1,1,1)
    --bg:scale(0.80, 0.80)
    sceneGroup:insert(bg)

    pauseTitleText = display.newText("PAUSE MENU", display.contentCenterX, 25, native.systemFontBold, 32)
    pauseTitleText:setFillColor(0,0,0)
    sceneGroup:insert(pauseTitleText)


    local resumeIcon = display.newImageRect( "images/Buttons/Pause/button_resume.png", 32, 32 )
    resumeIcon.x = 200
    resumeIcon.y = 100
    sceneGroup:insert(resumeIcon)
    resumeIcon:addEventListener("touch", resumeFunction)

    local restartIcon = display.newImageRect( "images/Buttons/Pause/button_restart.png", 32, 32 )
    restartIcon.x = 200
    restartIcon.y = 150
    sceneGroup:insert(restartIcon)
    restartIcon:addEventListener("touch", restartFunction)

    local toMenuIcon = display.newImageRect( "images/Buttons/Pause/button_backtomenu.png", 32, 32 )
    toMenuIcon.x = 200
    toMenuIcon.y = 200
    sceneGroup:insert(toMenuIcon)
    toMenuIcon:addEventListener("touch", toMenuFunction)

    local options = {
       text = "",
       x = 375,
       width = 300,
       height = 32,
       fontSize = 32,
       align = "left"
    }
    --sceneGroup:insert(options)

    local resumeText = display.newText(options)
    resumeText.text = "RESUME"
    resumeText:setFillColor( 0 )
    resumeText.y = 100
    resumeText:addEventListener("touch", resumeFunction)
    sceneGroup:insert(resumeText)

    local restartText = display.newText(options)
    restartText.text = "RESTART"
    restartText:setFillColor( 0 )
    restartText.y = 150
    restartText:addEventListener("touch", restartFunction)
    sceneGroup:insert(restartText)

    local toMenuText = display.newText(options)
    toMenuText.text = "TO MENU"
    toMenuText:setFillColor( 0 )
    toMenuText.y = 200
    toMenuText:addEventListener("touch", toMenuFunction)
    sceneGroup:insert(toMenuText)

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
