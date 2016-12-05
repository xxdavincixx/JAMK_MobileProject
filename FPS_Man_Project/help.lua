local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local device = require( "device" )
 
local params 

local scrollView
local icons = {}




local function handleButtonEvent( event )
    if ( "began" == event.phase ) then
        local btnPushed = { type="image", filename=event.target.pushed }
        event.target.fill = btnPushed
    elseif ( "ended" == event.phase ) then
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
        local btnUnpushed = { type="image", filename=event.target.unpushed }
        event.target.fill = btnUnpushed
    end
    return true
end

local function buttonListener( event )
    local id = event.target.id

    if event.phase == "moved" then
        local dx = math.abs( event.x - event.xStart ) -- Get the x-transition of the touch-input
        if dx > 5 then
            scrollView:takeFocus( event ) -- If the x- or y-transition is more than 5 put the focus to your scrollview
        end
    elseif event.phase == "ended" then
        -- do whatever you need to do if the object was touched
        print("object",id, "was touched")
        timer.performWithDelay( 10, function() scrollView:removeSelf(); scrollView = nil; end)
    end
    return true
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

    --local title = display.newBitmapText( titleOptions )
    local title = display.newImageRect("images/Logo.png", 400, 75) -- create title
    title.x = display.contentCenterX
    title.y = 40
    sceneGroup:insert( title )

    local doneButton = display.newImageRect("images/Buttons/Pause/button_resume.png", 32+16, 32+16)
    doneButton.pushed = "images/Buttons/Pause/button_resume_pushed.png"
    doneButton.unpushed = "images/Buttons/Pause/button_resume.png"
    doneButton.x = display.contentWidth*0.075
    doneButton.y = 32+16
    doneButton:scale( -1,1 )
    doneButton:addEventListener("touch", handleButtonEvent)
    sceneGroup:insert( doneButton )

    local gameText = display.newText("this is the place where we can describe our game in more detail", 1, 1, 500, 100, native.systemFont, 18)
    gameText.x = display.contentCenterX
    gameText.y = title.y + 100
    gameText:setTextColor(1,1,1)
    sceneGroup:insert (gameText)

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
