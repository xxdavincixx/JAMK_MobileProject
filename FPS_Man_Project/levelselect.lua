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

local function handleButtonEvent( event )                                       -- get back to menu function

    if ( "ended" == event.phase ) then
        composer.removeScene( "menu", false )                                   -- remove current menu scene
        composer.gotoScene( "menu", { effect = "crossFade", time = 333 } )      -- go to menu
    end
end

local function handleChangeNameEvent( event )
    if ( event.phase == "ended" ) then 
        composer.showOverlay( "username_overlay" , { effect = "crossFade", time = 333, isModal = true } )   -- change the current name
    end
end

local function levelSelect( event )                                             -- important to have this function as empty listener function for scrollViewLevelList. otherwise the snapping wouldn't work
end

local function selectLevel( event )                                             
    if ( event.phase == "moved" ) then                                          -- if finger is moved above the scrollList
        local dy = math.abs( ( event.y - event.yStart ) )                       -- calculates how far finger is moved
        if ( dy > 15 ) then                                                     -- if finger was moved more than 15px
            scrollViewLevelList:takeFocus( event )                              -- set a new focus
        end
    end
    if ( event.phase == "ended" ) then                                          -- if button is released
        local buttonLevel = event.target.id                                     -- get the id of pressed button
        local levelName = "level"..buttonLevel                                  -- concatenate "level" with level id e.g. "level1"
        if ( myData.settings.musicOn ) then                                     -- if music is enabled
            audio.stop()                                                        -- stop current music
            local backgroundMusicChannel = audio.play( audio.loadStream("audio/menu.mp3"), { channel=1, loops=-1, fadein = 1000 } ) -- start level music
        end
        composer.removeScene(levelName, false)                                  -- remove level you want to move to
        composer.gotoScene(levelName, {effect = "crossFade", time = 333})       -- go to level selected
    end
end


local function handleLevelSelect( event )                                       -- copy a button and put it in position of pressed button
 
    if ( event.phase == "moved" ) then                                          -- if finger is moved above the scrollList
        local dy = math.abs( ( event.y - event.yStart ) )                       -- calculates how far finger is moved
        if ( dy > 15 ) then                                                     -- if finger was moved more than 15px
            scrollViewLevelList:takeFocus( event )                              -- set a new focus
        end
    end
    
    if ( "ended" == event.phase ) then                                          -- if button is released
        button.id = event.target.id                                             -- copy pressed button
        button:setLabel("Start Level " .. event.target.id)                      -- copy pressed button
        button.x = event.target.x                                               -- copy pressed button position
        button.y = event.target.y+1                                             -- copy pressed button position

        if ( event.target.id == "1") then                                       -- this statement has to be changed! we have to ask if level is already completed
            levelCompleteText.text = "Level " .. event.target.id .. " completed"    -- e.g. write "Level 1 completed"
            levelCompleteText.alpha = 1                                         -- set text visible
            levelHighscoreText.alpha = 1                                        -- set highscore visible
            levelHighscoreText.text = "Highscore: " .. myData.settings.levels[tostring(event.target.id)] .. " s"                          -- we have to get the highscore of the currently selected level
        else
            levelCompleteText.text = "Level " .. event.target.id .. " not completed"    -- if level is not completed yet
            levelCompleteText.alpha = 1                                         -- set text visible
            levelHighscoreText.alpha = 0                                        -- set highscore invisible
        end
    end
end

--
-- Start the composer event handlers
--

function scene:create( event )

    local sceneGroup = self.view
    local background = display.newRect( 0, 0, 570, 360 )                        -- create background
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )
 
    local title = display.newText("Frames per second", 100, 32, native.systemFontBold, 32 ) -- create title
    title.x = display.contentCenterX
    title.y = 40
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    scrollViewLevelList = widget.newScrollView                                  -- create scrollView for levelselection
    {
        x = ( display.contentWidth/3 ) * 2,
        y = ( display.contentHeight/3 ) * 2,
        width = ( display.contentWidth/3 ) * 2,
        height = ( display.contentHeight/3 ) * 2,
        horizontalScrollDisabled = true,                                        -- enable to scroll horizontal
        listener = levelSelect                                                  -- constructor needs a listener to enable scrolling without snapping back. listener can be empty
    }

    button = widget.newButton({                                                 -- create Button to start a level
        id = "",
        label = "",                                                             -- empty in the beginning, will become "Start Level 1" e.g.
        name = "copyOfButton",
        width = scrollViewLevelList.width,                                      -- same width as scrollView
        height = 50,
        x = -2000,                                                              -- in the beginning out of view
        y = -2000,                                                              -- in the beginning out of view
        onEvent = selectLevel
    })

    local levelOneButton = widget.newButton({                                   -- create button for level selection
        id = "1",
        label = "Level 1",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = 50/2-2,
        onEvent = handleLevelSelect
    })
    
    local levelTwoButton = widget.newButton({                                   -- create button for level selection
        id = "2",
        label = "Level 2",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = levelOneButton.y + 48,                                              -- just beneathe upper button
        onEvent = handleLevelSelect
    })
    
    local levelThreeButton = widget.newButton({                                 -- create button for level selection
        id = "3",
        label = "Level 3",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = levelTwoButton.y + 48,                                              -- just beneathe upper button
        onEvent = handleLevelSelect
    })
    
    local levelFourButton = widget.newButton({                                  -- create button for level selection
        id = "4",
        label = "Level 4",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = levelThreeButton.y + 48,                                            -- just beneathe upper button
        
        onEvent = handleLevelSelect
    })
    
    local levelFiveButton = widget.newButton({                                  -- create button for level selection
        id = "5",
        label = "Level 5",
        name = "button",
        width = scrollViewLevelList.width,
        height = 52,
        x = scrollViewLevelList.contentWidth - scrollViewLevelList.contentWidth/2,
        y = levelFourButton.y + 48,                                             -- just beneathe upper button
        onEvent = handleLevelSelect
    })

    scrollViewLevelList:insert( levelOneButton )
    scrollViewLevelList:insert( levelTwoButton )
    scrollViewLevelList:insert( levelThreeButton )
    scrollViewLevelList:insert( levelFourButton )
    scrollViewLevelList:insert( levelFiveButton )
    scrollViewLevelList:insert( button )
    

    -- area where the name will be displayed in
    local userNameDisplay = display.newRoundedRect ( xLevelInformationRectangle, yLevelInformationRectangle+1 - ( display.contentHeight/9 ) * 3, display.contentWidth/3-10, ( display.contentHeight/9 ) * 2, 16)
    userNameDisplay:setFillColor( 0.75 )
    -- area where information of selected level will be displayed in
    local levelInformationRectangle = display.newRoundedRect( xLevelInformationRectangle, yLevelInformationRectangle+3, display.contentWidth/3 -10, ( display.contentHeight/9 ) * 4, 16 )
    levelInformationRectangle:setFillColor ( 0.75 )
    
    local userNameOptions = {
        text = myData.settings.username,                                        -- get the current username
        x = xLevelInformationRectangle+10,
        y = levelInformationRectangle.y - levelInformationRectangle.height + userNameDisplay.height/2,
        width = display.contentWidth/3-20,
        font = native.systemFontBold,
        fontSize = 15,
        align = "left"
    }
    userNameText = display.newText( userNameOptions )                           -- set options of userName to the text display

    local changeNameButton = widget.newButton({                                 -- create button to change username
        id = "changeName",
        label = "change Name",        
        width = userNameDisplay.width/2,
        height = 30,
        x = userNameDisplay.width/2 + userNameDisplay.width/4,
        y = userNameOptions.y,
        fontSize = 10,
        onEvent = handleChangeNameEvent                                         -- this method will save the username in our app-settings
    })
    
    local levelCompleteOptions = {                                              -- set options for level information
        text = "Level completed", 
        x = xLevelInformationRectangle, 
        y = yLevelInformationRectangle - 40, 
        width = levelInformationRectangle.width - 15,
        font = native.systemFontBold, 
        fontSize = 14,
        align = "left"
    }
    levelCompleteText = display.newText( levelCompleteOptions )                 -- set options of level information to that text
    levelCompleteText.alpha = 0                                                 -- default invisible to have no level information in the beginning of levelselection without selected level
    
    local levelHighscoreOptions = {                                             -- set options for level information
        text = "",
        x = xLevelInformationRectangle,
        y = yLevelInformationRectangle - 5 ,     
        width = levelInformationRectangle.width - 15,
        font = native.systemFontBold,
        fontSize = 14,
        align = "left"
    }
    levelHighscoreText = display.newText( levelHighscoreOptions )
    levelHighscoreText.alpha = 0                                                -- default invisible to have no level information in the beginning of levelselection without selected level

    sceneGroup:insert( userNameDisplay )
    sceneGroup:insert( userNameText )
    sceneGroup:insert( levelInformationRectangle )
    sceneGroup:insert( levelCompleteText )
    sceneGroup:insert( levelHighscoreText )
    sceneGroup:insert( changeNameButton )
    
    scrollViewLevelList:setScrollHeight( levelFiveButton.y + levelFiveButton.height/2 ) -- limitate the scrollable height beneathe the last level button
    params = event.params


    

    local doneButton = widget.newButton({
        id = "button1",
        label = "Back to menu",
        width = 120,
        height = 32,
        onEvent = handleButtonEvent
    })
    doneButton.x = display.contentCenterX
    doneButton.y = title.y + doneButton.height + 10
    sceneGroup:insert( doneButton )

    sceneGroup:insert( scrollViewLevelList )
end

function scene:show( event )
    local sceneGroup = self.view
    params = event.params

    if event.phase == "did" then
    end
    local myListener = function( event )
        if ( userNameText.text ~= myData.settings.username ) then               -- if name in userNameDisplay is unequal to string saved in app
            userNameText.text = myData.settings.username                        -- save string from userNameDisplay in app
        end
    end
    Runtime:addEventListener( "enterFrame", myListener )                        -- runtime listener for eachframe for changing displaytext at runtime
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
