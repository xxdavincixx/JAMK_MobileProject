local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local physics = require( "physics" )
local myData = require( "mydata" )
local perspective = require("perspective")


local currentScore          -- used to hold the numeric value of the current score
local currentScoreDisplay   -- will be a display.newText() that draws the score on the screen
local levelText             -- will be a display.newText() to let you know what level you're on
local spawnTimer            -- will be used to hold the timer for the spawning engine
local timerRefresh = 1000   -- will be used to calculate fps-update
local fps_multiplicator = 1 -- will be used to calculate fps-update
local timerDelay = 0        -- will be used to calculate fps-update
local dt=1000/30            -- will be used to calculate fps-update
local jumpDecrease = 0      -- will be used to limitate the number of jumps a payer can do
local cameraChanged = false -- will be used to get a new camera-setup

camera = perspective.createView() -- camera is created

local function decrease_fps()       -- function to decrease fps
    if(fps_multiplicator>=1)then                    -- if fps_multiplicator is higher or exact 1 
        fps_multiplicator = fps_multiplicator /2    -- fps_muliplicator is divided by 2
    end
    if(fps_multiplicator<1)then                     -- if fps multiplicator is smaller than 1
        print("Player is dead!")
        player.isDead=true                          -- player is dead
        player:setFillColor(1,0.2,0.2)
        player_ghost.direction = nil 
    end
end

local function spawnPlayer( )
    player = display.newRect(27.5,274.5,30,60)                      -- starting point and seize of the object
    local playerCollisionFilter = {categoryBits = 2, maskBits=5}    -- create collision filter for object, its own number is 2 and collides with the sum of 5 (wall and platform //maybe it has to be changed when adding enemies)
    player.alpha = 1                                                -- is visible
    player.isJumping =false                                         -- at the start the object is not jumping
    player.prevX = player.x                                         -- gets the start value as previous x value
    player.prevY = player.y                                         -- gets the start value as previous y value
    player.isDead = false;                                          -- value to check if player died

    return player
end

local function spawnPlayerGhost()           -- create a ghost of player object

    local player_ghost = display.newRect(27.5,274.5,30,60)                  -- starting point and seize of the object
    local playerGhostCollisionFilter = {categoryBits = 8, maskBits = 5}     -- create collision filter for ghost object, its own number is 8 and collides with the sum of 5 (wall and platform //maybe it has to be changed when adding enemies)
    player_ghost.alpha = 0                                                  -- player_ghost is not visible
    player_ghost.isJumping =false                                           -- at the start the object is not jumping
    player_ghost.prevX = player_ghost.x                                     -- gets the start value as previous x value
    player_ghost.prevY = player_ghost.y                                     -- gets the start value as previous y value
    player_ghost.direction = nil                                            -- character is not heading in a direction
    physics.addBody(player_ghost,"dynamic",{bounce = 0.1, filter=playerGhostCollisionFilter})   -- adding physic to object, "dynamic" = affected by gravity, hardly bouncy and gets a collision filter
    
    return player_ghost
end

local function getPlayerGhost()
    return player_ghost
end

local function setJumpDecrease(jd)
    jumpDecrease = jd
end

local function spawnWall(x,y,w,h)                   -- create a wall 
    
    local wall = display.newRect(x,y,w,h)
    local wallCollisionFilter = {categoryBits=1, maskBits=15}                               -- collision filter categoryBits means which number the object ist, maskBits is with which object this object will collide
    physics.addBody(wall, "static", {bounce=0.1, friction = 1, filter=wallCollisionFilter}) -- adding physic to object: static objects are not affected by gravity, walls are not bouncy and friction is as high as possible. adding collision filter to this object

    return wall
end

local function spawnPlatform(x,y,w,h)               -- create a platform a player can get through by jumping at x-position (x) and y-position (y) with width (w) and height (h)

    local platform = display.newRect(x,y,w,h)
    local platformCollisionFilter = {categoryBits = 4, maskBits = 8}        -- create collision filter, own value = 4 and collides with the sum of values equal to 8 (player_ghost)
    platform.typ = "ground"                                                 -- will set jump-counter to 0 if player is landing on platform
    platform.collType = "passthru"                                          -- a player is able to get through this platform
    physics.addBody( platform, "static", { bounce=0.0, friction=1, filter = platformCollisionFilter } )       -- adding physic to object: static objects are not affected by gravity, platform is not bouncy and friction is as high as possible

    return platform
end

local function getButton(x,y,w,h)           -- create a button at x-position (x) and y-position (y) with width (w) and height (h)

    local button = display.newRect(x,y,w,h)
    rect:setFillColor(255,0,0)

    return button
end

local function increase_fps()
    if(fps_multiplicator < 10)then                  -- fps can't increase in unlimited numbers, highest value = 16
        fps_multiplicator = fps_multiplicator*2     -- fps_multiplicator starts at 1 and each time increase_fps is called it gets doubled
    end
end


local function moveLeftButton(event)                -- change player_ghost direction value to "left"
    if (event.phase == "ended") then
        getPlayerGhost().direction = "left"
    end
    return true
end
local function moveRightButton(event)               -- change player_ghost direction value to "right"
    if event.phase == "ended" then
        getPlayerGhost().direction = "right"
    end
    return true
end

local function moveUpButton(event)                  -- call function to let player jump
    if event.phase == "ended" then
        jump()
    end
    return true
end

function jump()
    if(jumpDecrease<2)then                                                                              -- if player did not already jumped two times
        --getPlayerGhost():applyLinearImpulse(0,-0.1,getPlayerGhost().x, getPlayerGhost().y)              -- give player a linear impuls for jumping
        getPlayerGhost():setLinearVelocity( 0, -275 )
        jumpDecrease = jumpDecrease + 1                                                                 -- increase jump counter
    end

end






function scene:create( event )                        
    local sceneGroup = self.view

    physics.start()
    physics.setGravity(0,9.8)
    
    physics.pause()
    
    physics.setDrawMode("normal")                               -- can also be "hybrid" or "debug"
    
    local thisLevel = myData.settings.currentLevel

    player = spawnPlayer()                                      -- create a player
    player_ghost = spawnPlayerGhost()                           -- create its ghost
    player_ghost.isFixedRotation = true                         -- set its rotation to fixed so the player does not fall over when he jumps

    wallL = spawnWall(0,160,30,320)                             --
    wallR = spawnWall(1000,160,30,320)                          -- adding level
    floor = spawnPlatform(500,320,1000,30)                      -- components
    platform = spawnPlatform(60,200,80,10)                      -- 
    platform1 = spawnPlatform(220,200,80,10)
    platform2 = spawnPlatform(460,200,80,10)
    platform3 = spawnPlatform(700,200,80,10)
    platform4 = spawnPlatform(940,200,80,10)

    lButton = widget.newButton({
        id = "lButton",
        label = "Move Left",
        width = 100,
        height = 50,
        onEvent = moveLeftButton
    })
    lButton.x, lButton.y = display.contentCenterX-150, 50

    rButton = widget.newButton({
        id = "rButton",
        label = "Move Right",
        width = 100,
        height = 50,
        onEvent = moveRightButton
    })
    rButton.x, rButton.y = display.contentCenterX+150, 50

    mButton = widget.newButton({
        id = "mButton",
        label = "Jump",
        width = 100,
        height = 50,
        onEvent = jump
    })
    mButton.x, mButton.y = display.contentCenterX, 50

    player_ghost:setFillColor(0.3,0.4,0.5)
    wallL:setFillColor(0,1,0)
    wallR:setFillColor(0,0,1)
    floor:setFillColor(0,0,0)
    platform:setFillColor(1,0,0)

    local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    background:setFillColor( 0.6, 0.7, 0.3 )

    levelText = display.newText(myData.settings.currentLevel, 0, 0, native.systemFontBold, 48 )
    levelText:setFillColor( 0 )
    levelText.x = display.contentCenterX
    levelText.y = display.contentCenterY

    currentScoreDisplay = display.newText("000000", display.contentWidth - 50, 10, native.systemFont, 16 )
   
    local decFPS = widget.newButton({               -- debug button to decrease button manually
        label = "Decrease FPS",                     -- what does the label say
        onEvent = decrease_fps                      -- adding function to button
    })
    decFPS.x = display.contentCenterX - 100         
    decFPS.y = display.contentHeight - 60

    local incFPS = widget.newButton({
        label = "Increase FPS",
        onEvent = increase_fps
    })
    incFPS.x = display.contentCenterX + 100
    incFPS.y = display.contentHeight - 60


    --
    -- Insert objects into the scene to be managed by Composer
    --
    
    -- these objects are not affected by the camera movement --
    sceneGroup:insert( background )
    sceneGroup:insert( lButton )
    sceneGroup:insert( rButton )
    sceneGroup:insert( mButton )
    sceneGroup:insert( levelText )
    sceneGroup:insert( currentScoreDisplay )
    sceneGroup:insert( decFPS )                       -- adding to scene
    sceneGroup:insert( incFPS )
    

    -- these objects are effected by the camera movement --
    camera:add(player, 1)
    camera:add(wallL,2)
    camera:add(wallR,2)
    camera:add(floor,2) 
    camera:add(player_ghost,1)
    camera:add(platform,2)
    camera:add(platform1,2)
    camera:add(platform2,2)
    camera:add(platform3,2)
    camera:add(platform4,2)


end

function scene:show( event )   
    local sceneGroup = self.view
    camera:setFocusY(player)                        -- sets the camera on the right position before the game starts. 
    camera:trackY()                                 
    camera:cancel()

    if event.phase == "did" then

        physics.start()                                 -- enable physics

        function player_ghost:enterFrame()                                      -- each frame
        if(player.isDead~=true)then
            --PLAYER MOVEMENT--
            if(getPlayerGhost().direction == nil)then                           -- if player direction is nil the player should stop moving
                getPlayerGhost().x = getPlayerGhost().x
            end

            if(getPlayerGhost().direction == "right")then                       -- if player direction is "right" player goes right
                getPlayerGhost().x = getPlayerGhost().x + 3
            elseif(getPlayerGhost().direction == "left")then                    -- if player direction is "left" player goes left
                getPlayerGhost().x = getPlayerGhost().x - 3
            end

            if getPlayerGhost().prevY ~= getPlayerGhost().y then                -- if player y position is not equal to last frame
                if getPlayerGhost().y > getPlayerGhost().prevY then             -- if y is smaller than in previous frame player is falling
                    getPlayerGhost().isJumping = false                          -- set player_ghost jumping value to "false"
                elseif getPlayerGhost().y < getPlayerGhost().prevY then         -- if y is bigger than in previous frame player is jumping
                    getPlayerGhost().isJumping = true                           -- set player_ghost jumping value to "true"
                end
            end
            
            getPlayerGhost().prevX, getPlayerGhost().prevY = getPlayerGhost().x, getPlayerGhost().y     -- synchronize players position for next frame

            --CAMERA MOVEMENT--
            if(timerDelay >= timerRefresh/fps_multiplicator)then        -- this method is an timer written on my own to decrease and increase the update of player with its ghost-self
                local middleOfScreen = display.contentCenterX           -- this describes the middle of the screen
                local endOfLevel = 1000                                 -- this descirbes the total length of the
                player.x = player_ghost.x                               -- player position gets synchronized with its ghost-self
                player.y = player_ghost.y                               -- player position gets synchronized with its ghost-self
                if(player.x < (middleOfScreen))then                     -- if player did not leave start yet or goes back to start
                    camera:cancel()                                     -- camera will be disabled when there was already a camera tracking
                    camera.damping = 1
                    camera:setFocusY(player)                            -- camera will focus the player on the y-axis
                    camera:trackY()        
                    cameraChanged = true                                                     -- camera will only track in y-axis
                elseif(player.x > (endOfLevel-middleOfScreen)+15)then   -- if the player gets near the end
                    camera:cancel()                                     -- camera will be disabled when there was already a camera tracking
                    camera.damping = 1
                    camera:setFocusY(player)                            -- camera will focus the player on the y-axis
                    camera:trackY()                                     -- camera will be disabled when there was already a camera tracking
                    cameraChanged = true
                elseif(player.isDead~=true)then                         -- if the player leaves the end or start area and is between both of them camera will be attached
                    camera:cancel()                                     -- camera will be disabled when there was already a camera tracking
                    camera.damping = 1                                 -- A bit more fluid tracking
                    camera:setFocus(player)                             -- Set the focus to the player
                    camera:track()                                      -- Begin auto-tracking
                    cameraChanged = false
                else
                    --camera:cancel()                                     -- Dead player don't need camera tracking :-P
                end
                
                timerDelay=0                                            -- counter resets for working freezes
            end
            timerDelay = timerDelay +dt                                 -- increase timerDelay each frame to detect when next visible frame should be shown
        elseif(player.isDead) then
            wallL:removeSelf()
            wallR:removeSelf()
            floor:removeSelf()
            lButton:removeSelf()
            rButton:removeSelf()
            mButton:removeSelf()
            Runtime:removeEventListener( "enterFrame",  getPlayerGhost() )
            --player:removeSelf()
            player.alpha = 0
            player_ghost:removeSelf()
            platform:removeSelf()
            platform1:removeSelf()
            platform2:removeSelf()
            platform3:removeSelf()
            platform4:removeSelf()

            composer.removeScene("gameover")
            composer.gotoScene("gameover", { time= 500, effect = "crossFade" })
        end
    end
    Runtime:addEventListener("enterFrame", getPlayerGhost())        -- adding eventListener "enterFrame" to the object of player_ghost
    transition.to( levelText, { time = 500, alpha = 0 } )           -- show the name of the level and let it fade out


   --[[ function onPreCollision( self, event )
 
        local collideObject = event.other                                                                               -- get object you collided with
        if (collideObject.collType == "passthru" and self.isJumping==true) then        -- if object is of type "passthru" and the player is currently jumping
            if(event.contact ~= nil)then                                                -- if event contact is a nil value ... it should not crash anymore
                event.contact.isEnabled = false                                         -- disable this specific collision
            end                                                                           
        elseif((collideObject.collType == "passthru" and self.isJumping==false) or collideObject.typ=="ground")then     -- if object is of type "passthru" and player is not jumping or collided object is of type "ground"
            setJumpDecrease(0)                                                                                          -- reset the jump counter
        end
    end
    getPlayerGhost().preCollision = onPreCollision                              -- giving object a preCollision function
    getPlayerGhost():addEventListener( "preCollision", getPlayerGhost())        -- adding event listener "preCollision" to ghost_player
]]
    if(player.y >= floor.y)then
        player.isDead = true
    end

    elseif event.phase == "will" then
        
    end


end

function scene:hide( event )                                                                                            --HIDE FUNCTION
    local sceneGroup = self.view
    
    if event.phase == "will" then
        physics.stop()
    end

end


function scene:destroy( event )                                                                                         --DESTROY FUNCTION
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
