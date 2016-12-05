local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" ) 
local device = require( "device" )

local params


local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
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
    local background = display.newRect( 0, 0, 570, 360)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)

    local title = display.newImageRect("images/Logo.png", 400, 75) -- create title
    title.x = display.contentCenterX
    title.y = 40
    sceneGroup:insert( title )

    local doneButton = display.newImageRect("images/Buttons/Pause/button_resume.png", 32+16, 32+16)
    doneButton.x = display.contentWidth*0.075
    doneButton.y = 32+16
    doneButton:scale( -1,1 )
    doneButton:addEventListener("touch", handleButtonEvent)
    sceneGroup:insert( doneButton )

    local creditText = display.newText( "This game was developed by: ", 250, 250, native.systemFont, 23 )
    creditText:setFillColor( 0)
    creditText.x = display.contentCenterX
    creditText.y = display.contentCenterY - 65
    sceneGroup:insert(creditText)

    local nameArthur = display.newText( "Arthur Jaks", 250,250, native.systemFont, 16)
    nameArthur:setFillColor( 0 )
    nameArthur.x = display.contentCenterX
    nameArthur.y = display.contentCenterY - 25
    sceneGroup:insert(nameArthur)

    local nameJanis = display.newText( "Janis Clausen", 250,250, native.systemFont, 16)
    nameJanis:setFillColor( 0 )
    nameJanis.x = display.contentCenterX
    nameJanis.y = display.contentCenterY
    sceneGroup:insert(nameJanis)

    local nameLeo = display.newText( "Leonard Bartling", 250,250, native.systemFont, 16)
    nameLeo:setFillColor( 0 )
    nameLeo.x = display.contentCenterX
    nameLeo.y = display.contentCenterY + 25
    sceneGroup:insert(nameLeo)

    local nameTimothy = display.newText( "Timothy Lizotte", 250,250, native.systemFont, 16)
    nameTimothy:setFillColor( 0 )
    nameTimothy.x = display.contentCenterX
    nameTimothy.y = display.contentCenterY + 50
    sceneGroup:insert(nameTimothy)
    -- http://www.freesfx.co.uk
    -- http://www.freesound.org

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
