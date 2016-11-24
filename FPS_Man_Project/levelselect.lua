local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )

local params
local scrollViewLevelList
local scrollViewLevelDetail
local button
local xLevelInformationRectangle = display.contentWidth/3 - display.contentWidth/6
local yLevelInformationRectangle = ( display.contentHeight/3 ) * 2 + ( display.contentHeight/5 ) - 30
local levelCompleteText, levelHighscoreText, userNameText

local function handleButtonEvent( event )

    if ( "ended" == event.phase ) then
        composer.removeScene( "menu", false )
        composer.gotoScene( "menu", { effect = "crossFade", time = 333 } )
    end
end

local function levelSelect( event )                                             -- important to have this function as empty listener function for scrollViewLevelList. otherwise the snapping wouldn't work
end

local function selectLevel( event )
    if ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 15 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 15 ) then
            scrollViewLevelList:takeFocus( event )
        end
    end
    if ( event.phase == "ended" ) then
        local buttonLevel = event.target.id
        local levelName = "level"..buttonLevel
        composer.removeScene(levelName, false)
        composer.gotoScene(levelName, {effect = "crossFade", time = 333})
    end
end


local function handleLevelSelect( event )
    if ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 15 ) then
            scrollViewLevelList:takeFocus( event )
        end
    end
    
    if ( "ended" == event.phase ) then
        button.id = event.target.id
        button:setLabel("Start Level " .. event.target.id)
        button.x = event.target.x
        button.y = event.target.y+1

        if( event.target.id == "1") then                                                        -- this statement has to ask for the value if value is already completed
            levelCompleteText.text = "Level " .. event.target.id .. " completed"
            levelCompleteText.alpha = 1
            levelHighscoreText.alpha = 1
            levelHighscoreText.text = "Highscore: 210" -- .. getHighscoreOfCurrentLevel()
            --levelCompleteText.x = xLevelInformationRectangle - 14.5
        else
            levelCompleteText.text = "Level " .. event.target.id .. " not completed"
            levelCompleteText.alpha = 1
            levelHighscoreText.alpha = 0
            --levelCompleteText.x = xLevelInformationRectangle
        end
    end
end

--
-- Start the composer event handlers
--

function scene:create( event )

    local sceneGroup = self.view
    local background = display.newRect( 0, 0, 570, 360 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )
 
    local title = display.newText("Frames per second", 100, 32, native.systemFontBold, 32 )
    title.x = display.contentCenterX
    title.y = 40
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    scrollViewLevelList = widget.newScrollView
    {
        x = ( display.contentWidth/3 ) * 2,--left = display.contentWidth/3, --display.contentWidth/2-display.contentWidth/7,
        y = ( display.contentHeight/3 ) * 2, --top = display.contentHeight/2-display.contentHeight/7,
        width = ( display.contentWidth/3 ) * 2,--display.contentWidth/2+display.contentWidth/7,
        height = ( display.contentHeight/3 ) * 2,  -- display.contentHeight - (display.contentHeight/2-display.contentHeight/7),
        horizontalScrollDisabled = true,
        listener = levelSelect
    }
    button = widget.newButton({
        id = "",
        label = "Start Level ", --.. event.target.id,
        name = "copyOfButton",
        width = scrollViewLevelList.width,
        height = 50,
        x = -2000,
        y = -2000,--event.target.y,
        onEvent = selectLevel
    })

    local levelOneButton = widget.newButton({
        id = "1",
        label = "Level 1",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = 50/2-2,
        onEvent = handleLevelSelect
    })
    
    local levelTwoButton = widget.newButton({
        id = "2",
        label = "Level 2",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = levelOneButton.y + 48,
        onEvent = handleLevelSelect
    })
    
    local levelThreeButton = widget.newButton({
        id = "3",
        label = "Level 3",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = levelTwoButton.y + 48,
        onEvent = handleLevelSelect
    })
    
    local levelFourButton = widget.newButton({
        id = "4",
        label = "Level 4",
        name = "button",
        width = scrollViewLevelList.width,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = 225,
        height = 52,
        y = levelThreeButton.y + 48,
        onEvent = handleLevelSelect
    })
    
    local levelFiveButton = widget.newButton({
        id = "5",
        label = "Level 5",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = levelFourButton.y + 48,
        onEvent = handleLevelSelect
    })

    scrollViewLevelList:insert( levelOneButton )
    scrollViewLevelList:insert( levelTwoButton )
    scrollViewLevelList:insert( levelThreeButton )
    scrollViewLevelList:insert( levelFourButton )
    scrollViewLevelList:insert( levelFiveButton )
    scrollViewLevelList:insert( button )
    
    local userNameDisplay = display.newRoundedRect ( xLevelInformationRectangle, yLevelInformationRectangle+1 - ( display.contentHeight/9 ) * 3, display.contentWidth/3-10, ( display.contentHeight/9 ) * 2, 16)
    userNameDisplay:setFillColor( 0.75 )
    local levelInformationRectangle = display.newRoundedRect( xLevelInformationRectangle, yLevelInformationRectangle+3, display.contentWidth/3 -10, ( display.contentHeight/9 ) * 4, 16 )
    levelInformationRectangle:setFillColor ( 0.75 )
    
    local userNameOptions = {
        text = "Svenja",
        x = xLevelInformationRectangle+10,
        y = levelInformationRectangle.y - levelInformationRectangle.height + userNameDisplay.height/2,
        width = display.contentWidth/3-20,
        font = native.systemFontBold,
        fontSize = 15,
        align = "left"
    }
    userNameText = display.newText( userNameOptions )

    local changeNameButton = widget.newButton({
        id = "changeName",
        label = "change Name",        
        width = userNameDisplay.width/2,
        height = 30,
        x = userNameDisplay.width/2 + userNameDisplay.width/4,
        y = userNameOptions.y,
        fontSize = 10,
        onEvent = handleLevelSelect                                     -- this method has to be changed to Arthurs method
    })
    
    local levelCompleteOptions = {
        text = "Level completed", 
        x = xLevelInformationRectangle, 
        y = yLevelInformationRectangle - 40, 
        width = levelInformationRectangle.width - 15,
        font = native.systemFontBold, 
        fontSize = 14,
        align = "left"
    }
    levelCompleteText = display.newText( levelCompleteOptions )
    levelCompleteText.alpha = 0
    
    local levelHighscoreOptions = {
        text = "",
        x = xLevelInformationRectangle,
        y = yLevelInformationRectangle - 5 ,     
        width = levelInformationRectangle.width - 15,
        font = native.systemFontBold,
        fontSize = 14,
        align = "left"
    }
    levelHighscoreText = display.newText( levelHighscoreOptions )
    levelHighscoreText.alpha = 0

    sceneGroup:insert( userNameDisplay )
    sceneGroup:insert( userNameText )
    sceneGroup:insert( levelInformationRectangle )
    sceneGroup:insert( levelCompleteText )
    sceneGroup:insert( levelHighscoreText )
    sceneGroup:insert( changeNameButton )
    
    scrollViewLevelList:setScrollHeight( levelFiveButton.y + levelFiveButton.height/2 )
    params = event.params


    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    
   --[[ local selectLevelText = display.newText("Select a level", 125, 32, native.systemFontBold, 32)
    selectLevelText:setFillColor( 0 )
    selectLevelText.x = display.contentCenterX
    selectLevelText.y = 50
    sceneGroup:insert(selectLevelText)
--]]
    --local x = 90
    --local y = 115
    local x = 0
    local y = 0
    local buttons = {}
    local buttonBackgrounds = {}
    local buttonGroups = {}
    local levelSelectGroup = display.newGroup()
    local cnt = 1
    --[[for i = 1, 10 do
        buttonGroups[i] = display.newGroup()
        buttonBackgrounds[i] = display.newRoundedRect( x, y-15, 42, 32, 8 )
        buttonBackgrounds[i]:setFillColor( 1, 0, 1, 0.333 )
        buttonBackgrounds[i]:setStrokeColor( 1, 0, 1, 0.667 )
        buttonBackgrounds[i].strokeWidth = 1
        buttonGroups[i]:insert(buttonBackgrounds[i])
        buttonGroups[i].id = i
        if myData.settings.unlockedLevels == nil then
            myData.settings.unlockedLevels = 10
        end
        
        if i <= myData.settings.unlockedLevels then
            buttonGroups[i].alpha = 1.0
            buttonGroups[i]:addEventListener( "touch", handleLevelSelect )
        else
            buttonGroups[i].alpha = 0.5
        end
        buttons[i] = display.newText(tostring(i), 0, 0, native.systemFontBold, 28)
        buttons[i].x = x
        buttons[i].y = y -15
        buttonGroups[i]:insert(buttons[i])

        x = x + 55
        cnt = cnt + 1
        if cnt > 5 then
            cnt = 1
            x = 0
            y = y + 42
        end
        levelSelectGroup:insert(buttonGroups[i])
    end
    ]]
    sceneGroup:insert(levelSelectGroup)
    levelSelectGroup.x = display.contentCenterX - 100
    levelSelectGroup.y = 120

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

    sceneGroup:insert( scrollViewLevelList )
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
        sceneGroup:removeSelf()

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
