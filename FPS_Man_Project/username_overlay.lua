local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local ads = require( "ads" )

local myData = require( "mydata" )

local bg
local title
local button
local charLeft = 8
local usernameTextField
local usernameTxt
local feedbackTxt
local btnSaveTxt


local function usernameTextFieldEvent(event)

    if event.phase == "editing" then
      --charLeft = charLeft - event.target.text

      if string.len(event.text) > charLeft then
        -- Text too long, replace textField text with old text    
        usernameTextField.text = event.oldText -- change the "TextField" with the
                                       --name of your textfield
        print ("max length reached")
      else
        feedbackTxt.text = (charLeft -string.len(event.text)) .. " Charakters left"
      end

    end
end


local function saveName(event)

    if usernameTextField.text == nil or usernameTextField.text == "" then
      feedbackTxt.text = "Field can't be empty"
    else
      print("saved name!")
      myData.settings.username = usernameTextField.text
      utility.saveTable(myData.settings, "settings.json")
      composer.hideOverlay( "crossFade", 333 )
      usernameTextField:removeSelf()   
    end

    return true
end



-- create()
function scene:create( event )

  local sceneGroup = self.view

    bg0 = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg0:setFillColor(0.1,0.1,0.1, 0.9)
    
    sceneGroup:insert(bg0)

    bg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(1,1,1)
    bg:scale(0.80, 0.80)
    sceneGroup:insert(bg)


    --title = display.newText("Username", display.contentCenterX, 75, "", 50)
    --title:setFillColor(0,0,0)
    --sceneGroup:insert(title)
    -- Code here runs when the scene is first created but has not yet appeared on screen


    usernameTxt = display.newText("Please enter your username", display.contentCenterX, 75, native.systemFont, 32)
    usernameTxt:setFillColor(0,0,0)
    sceneGroup:insert(usernameTxt)

    -- create text field
    usernameTextField = native.newTextField(display.contentCenterX, 140, 240, 32)
    --usernameTextField.size = 38
    usernameTextField:addEventListener("userInput", usernameTextFieldEvent)
    sceneGroup:insert(usernameTextField)

    -- create a lebel to show feedback
    feedbackTxt = display.newText( charLeft .. " Charakters left", display.contentCenterX, 190, native.systemFont, 20)
    feedbackTxt:setFillColor(0,0,0)
    sceneGroup:insert(feedbackTxt)

    if(myData.settings.username ~= "") then
      usernameTextField.text = myData.settings.username
      feedbackTxt.text = (charLeft - string.len(usernameTextField.text) .. " Charakters left")
    end

    button2 = display.newRect(display.contentCenterX, 250, 200, 50)
    button2:setFillColor(0.5,0.5,0.5)
    sceneGroup:insert(button2)

    button2:addEventListener("tap", saveName)

    btnSaveTxt = display.newText("Save", display.contentCenterX, 250, native.systemFont, 28)
    btnSaveTxt:setFillColor(1,1,1)
    sceneGroup:insert(btnSaveTxt)

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

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

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
