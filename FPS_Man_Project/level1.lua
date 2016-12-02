-- Activate multitouch
system.activate( "multitouch" )

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local json = require( "json" )
local utility = require( "utility" )
local physics = require( "physics" )
local myData = require( "mydata" )
local perspective = require( "perspective" )

local currentScore                                                          -- used to hold the numeric value of the current score
local currentScoreDisplay                                                   -- will be a display.newText() that draws the score on the screen
local levelText                                                             -- will be a display.newText() to let you know what level you're on
local spawnTimer                                                            -- will be used to hold the timer for the spawning engine
local timerRefresh = 1000                                                   -- will be used to calculate fps-update
local fps_multiplicator = 1                                             	-- will be used to calculate fps-update
local timerDelay = 0                                                        -- will be used to calculate fps-update
local dt=1000/60                                                            -- will be used to calculate fps-update
local jumpDecrease = 0                                                      -- will be used to limitate the number of jumps a player can do
local runtime = 0
local neededtime
local timeLimit = 300
local highscoretime = 0
local endScore
local enemies = display.newGroup()
local enemie_ghosts = display.newGroup()
local levelNumber = 1
composer.removeScene(composer.getSceneName("previous"))
camera = perspective.createView()                                           -- camera is created


-- SQL Online Server Part - Start
local url = 'https://skaja.eu/fps-game/highscore.php'

local function compateWithOnlineHighscoreListener(query)
    if ( query.isError ) then
        print( "Network error!", query.response )
    else
        -- new record -> 1 back | no record -> 0 back
        if(query.response == "1") then
            print("new record!")
        else
            if(query.response == "0") then
                print("no record")
            end            
        end

        print ( "RESPONSE: " .. query.response )
    end
end

local function compateWithOnlineHighscore()

    local params = {
        body = "username=".. myData.settings.username .."&highscore=".. endScore .. "&level=".. levelNumber ..""
    };
    print("Sending Request to Server...")
    network.request(url,"POST",compateWithOnlineHighscoreListener, params)
end

-- SQL Online Server Part - End


-- save highscore local
local function compareLocalHighscore(endScore)
    local localHighscore = myData.settings.levels[tostring(levelNumber)]
    
    if(myData.settings.levels[tostring(levelNumber)] == "/") then
        myData.settings.levels[tostring(levelNumber)] = endScore
        
    else
        if(endScore < localHighscore) then
            myData.settings.levels[tostring(levelNumber)] = endScore        
        end
    end

    utility.saveTable(myData.settings, "settings.json")
end

-- Create timer  --
text = display.newText("Time left: ", 500, 10, native.systemFont, 16)
timeLeft = display.newText(timeLimit, 550, 10, native.systemFont, 16)
text:setTextColor(255,255,255)
timeLeft:setTextColor(255,255,255)


-- Function for timer --
local function timerDown()
     timeLimit = timeLimit-1
     timeLeft.text = timeLimit
      if(timeLimit==0)then
        composer.removeScene( "gameover" )                      -- if there is a gameover-scene already running we delete it
        composer.gotoScene( "gameover", { time= 500, effect = "crossFade" } )   -- switch to gameover-scene
     end
  end

local function timerUp()
    highscoretime = highscoretime+1
    neededtime = highscoretime * 10 / 100
end

local countdowntimer = timer.performWithDelay(1000,timerDown,timeLimit)
local highscoretimer = timer.performWithDelay(100,timerUp,highscoretime)


-- Creating image sheet and info for character --
local characterSheetInfo = require("fps_man_walking_spritesheet")
local characterSheet = graphics.newImageSheet("images/fps_man_walking_spritesheet.png", characterSheetInfo:getSheet() )

-- Creating image sheet and info for walker enemy --
local walkerEnemySheetInfo = require("fps_walker_spritesheet")
local walkerEnemySheet = graphics.newImageSheet("images/fps_walker_spritesheet.png", walkerEnemySheetInfo:getSheet() )

-- Creating image sheet and info for jumper enemy --
local jumperEnemySheetInfo = require("fps_jumper_spritesheet")
local jumperEnemySheet = graphics.newImageSheet("images/fps_jumper_spritesheet.png", jumperEnemySheetInfo:getSheet() )

-- looping movement walker enemy 1 --
local function walkerEnemy1MovementRight()
    local function walkerEnemy1MovementLeft()
        
        transition.to(walkerEnemy_ghost, {x = 250, time=1200, onComplete=walkerEnemy1MovementRight})
        walkerEnemy.xScale = -1/20*3
        walkerEnemy.yScale = 1/20*3
    end
    transition.to(walkerEnemy_ghost, {x = 390, time=1200, onComplete=walkerEnemy1MovementLeft})
    walkerEnemy.xScale =1/20*3-- 0.15
    walkerEnemy.yScale = 1/20*3
end

-- looping movement jumper enemy 1 --
local function jumperEnemy1MovementDown()
    local function jumperEnemy1MovementUp()
        
        transition.to(jumperEnemy_ghost, {y = 220, time=600, onComplete=jumperEnemy1MovementDown})
        jumperEnemy.xScale = 1/20*3
        jumperEnemy.yScale = 1/20*3
    end
    transition.to(jumperEnemy_ghost, {y = 275, time=600, onComplete=jumperEnemy1MovementUp})
    jumperEnemy.xScale =1/20*3-- 0.15
    jumperEnemy.yScale = 1/20*3
end

local function spawnWall( x, y, w, h )                                      -- create a wall 
    
    local wall = display.newRect( x, y, w, h)
    local wallCollisionFilter = {categoryBits=1, maskBits=15}               -- collision filter categoryBits means which number the object ist, maskBits is with which object this object will collide
    physics.addBody( wall, "static", {bounce=0.1, friction = 1, filter=wallCollisionFilter} )   -- adding physic to object: static objects are not affected by gravity, walls are not bouncy and friction is as high as possible. adding collision filter to this object

    return wall
end

local function spawnPlayer( x, y )
    player = display.newSprite(characterSheet, characterSheetInfo:getSequenceData() )            -- starting point and seize of the object (old 30x60)
    player.x = 36
    player.y = 260
    --local playerCollisionFilter = { categoryBits = 2, maskBits=5 }          -- create collision filter for object, its own number is 2 and collides with the sum of 5 (wall and platform //maybe it has to be changed when adding enemies)
    player.alpha = 1                                                        -- is visible
    player.isJumping =false                                                 -- at the start the object is not jumping
    player.prevX = player.x                                                 -- gets the start value as previous x value
    player.prevY = player.y                                                 -- gets the start value as previous y value
    player.isDead = false                                                   -- value to check if player died
    player.didFinish = false
    return player
end

local function spawnPlatform( x, y, w, h )                                  -- create a platform a player can get through by jumping at x-position (x) and y-position (y) with width (w) and height (h)

    local platform = display.newRect( x, y, w, h )
    local platformCollisionFilter = { categoryBits = 4, maskBits = 8 }      -- create collision filter, own value = 4 and collides with the sum of values equal to 8 (player_ghost)
    platform.typ = "ground"                                                 -- will set jump-counter to 0 if player is landing on platform
    platform.collType = "passthru"                                          -- a player is able to get through this platform
    physics.addBody( platform, "static", { bounce=0.0, friction=1, filter = platformCollisionFilter } )       -- adding physic to object: static objects are not affected by gravity, platform is not bouncy and friction is as high as possible

    return platform
end

local function spawnPlayerGhost( x, y )                                           -- create a ghost of player object

    local player_ghost = display.newRect( x, y, 41, 90 )             -- starting point and seize of the object
    local playerGhostCollisionFilter = { categoryBits = 8, maskBits = 21 }  -- create collision filter for ghost object, its own number is 8 and collides with the sum of 5 (wall and platform //maybe it has to be changed when adding enemies)
    player_ghost.alpha = 0                                                  -- player_ghost is not visible
    player_ghost.isJumping =false                                           -- at the start the object is not jumping
    player_ghost.prevX = player_ghost.x                                     -- gets the start value as previous x value
    player_ghost.prevY = player_ghost.y                                     -- gets the start value as previous y value
    player_ghost.direction = nil                                            -- character is not heading in a direction
    physics.addBody( player_ghost, "dynamic", { bounce = 0.1, filter=playerGhostCollisionFilter} )   -- adding physic to object, "dynamic" = affected by gravity, hardly bouncy and gets a collision filter
    
    return player_ghost
end

local function spawnIncreasingObject( x, y )                                -- create an object you can collect which increases the fps of the player

    local object = display.newRect( x, y, 20, 20 )
    local objectCollisionFilter = { categoryBits = 16, maskBits = 8 }       -- create collision filter for this object, its own number is 16 and collides with the sum of 8 (only ghost player)
    physics.addBody( object, "static", { bounce = 0.1, filter = objectCollisionFilter} )    -- adding physics to object, "static" = not affected by gravity, no bounce of object    
    object.collType = "increase"  
    object:setFillColor( 1, 0.5, 0.2 )                                      -- object is orange
    return object
end

local function spawnDecreasingObject( x, y )                                -- create an object you can collect which decreases the fps of the player

    local object = display.newRect( x, y, 20, 20 )                                           
    local objectCollisionFilter = { categoryBits = 16, maskBits = 8 }       -- create collision filter for this object, its own number is 16 and collides with the sum of 8 (only ghost player)
    physics.addBody( object, "static" , { bounce = 0.1, filter = objectCollisionFilter} )   -- adding physics to object, "static" = not affected by gravity, no bounce of object
    object.collType = "decrease"                                            -- parameter for collision to ask which object the player collides with
    object:setFillColor( 0.5, 1, 0.2 )  
    return object
end

local function spawnWalkerEnemy( x, y )
    local walkerEnemy = display.newSprite( walkerEnemySheet, walkerEnemySheetInfo:getSequenceData() )
    walkerEnemy.name = "sebastian"
    walkerEnemy.x = x
    walkerEnemy.y = y
    --local objectCollisionFilter = { categoryBits = 16, maskBits = 8 }                            -- create collision filter for this object, its own number is 16 and collides with the sum of 8 (only ghost player)
    --physics.addBody( walkerEnemy, "static" , { bounce = 0.1, filter = objectCollisionFilter} )   -- adding physics to object, "static" = not affected by gravity, no bounce of object
    --walkerEnemy.collType = "decrease"                                                            -- parameter for collision to ask which object the player collides with
    return walkerEnemy
end

local function spawnWalkerEnemyGhost( x, y )
    local walker_ghost = display.newRect( x, y, 41, 90 )             -- starting point and seize of the object
    walker_ghost.name = "conrad"
    walker_ghost.alpha = 0                                                  -- player_ghost is not visible
    local objectCollisionFilter = { categoryBits = 16, maskBits = 8 }                            -- create collision filter for this object, its own number is 16 and collides with the sum of 8 (only ghost player)
    physics.addBody( walker_ghost, "static" , { bounce = 0.1, filter = objectCollisionFilter} )   -- adding physics to object, "static" = not affected by gravity, no bounce of object
    walker_ghost.collType = "decrease"                                                            -- parameter for collision to ask which object the player collides with
      
    return walker_ghost
end

local function spawnJumperEnemy( x, y )
    local jumperEnemy = display.newSprite( jumperEnemySheet, jumperEnemySheetInfo:getSequenceData() )
    jumperEnemy.name = "sebastian"
    jumperEnemy.x = x
    jumperEnemy.y = y
    --local objectCollisionFilter = { categoryBits = 16, maskBits = 8 }                            -- create collision filter for this object, its own number is 16 and collides with the sum of 8 (only ghost player)
    --physics.addBody( jumperEnemy, "static" , { bounce = 0.1, filter = objectCollisionFilter} )   -- adding physics to object, "static" = not affected by gravity, no bounce of object
    --jumperEnemy.collType = "decrease"                                                            -- parameter for collision to ask which object the player collides with
    return jumperEnemy
end

local function spawnJumperEnemyGhost( x, y )
    local jumper_ghost = display.newRect( x, y, 41, 90 )             -- starting point and seize of the object
    jumper_ghost.name = "conrad"
    jumper_ghost.alpha = 0                                                  -- player_ghost is not visible
    local objectCollisionFilter = { categoryBits = 16, maskBits = 8 }                            -- create collision filter for this object, its own number is 16 and collides with the sum of 8 (only ghost player)
    physics.addBody( jumper_ghost, "static" , { bounce = 0.1, filter = objectCollisionFilter} )   -- adding physics to object, "static" = not affected by gravity, no bounce of object
    jumper_ghost.collType = "decrease"                                                            -- parameter for collision to ask which object the player collides with
      
    return jumper_ghost
end

local function setJumpDecrease( jd )
    jumpDecrease = jd                                                       -- function to reset the jumpDecrease variable
end

local function getButton( x, y, w, h )                                      -- create a button at x-position (x) and y-position (y) with width (w) and height (h)

    local button = display.newRect( x, y, w, h )
    return button
end

local function increase_fps()
    if ( fps_multiplicator < 10 ) then                                      -- fps can't increase in unlimited numbers, highest value = 16
        fps_multiplicator = fps_multiplicator*2                             -- fps_multiplicator starts at 1 and each time increase_fps is called it gets doubled
    end
end


local function moveLeftButton( event )                                      -- change player_ghost direction value to "left"
    --if ( event.phase == "began" ) then
    --    player_ghost.direction = "left"
    if ( event.phase == "began" ) then
        player.xScale = -0.4
        player.yScale = 0.4
    	player:setSequence("walk")
  		player:play()
        player_ghost.direction = "left"--nil
        else if (event.phase == "ended") then
            player_ghost.direction = ""
            player:pause()
            player:setSequence("idle")
        end
    end

    return true
end
local function moveRightButton( event )                                     -- change player_ghost direction value to "right"
    --if ( event.phase == "began" ) then
    --    player_ghost.direction = "right"
    if ( event.phase == "began" ) then
        player.xScale = 0.4
        player.yScale = 0.4
    	player:setSequence("walk")
	    player:play()
        player_ghost.direction = "right"--nil
        else if (event.phase == "ended") then
            player_ghost.direction = ""
            player:pause()
            player:setSequence("idle")
        end
    end
    return true
end

local function moveUpButton( event )                                        -- call function to jump with the player
    if ( event.phase == "ended" ) then
        jump()
    end
    return true
end

function jump( ) 
    if ( jumpDecrease < 1 ) then                                            -- if player did not already jumped two times
        --player_ghost:applyLinearImpulse( 0, -0.1, player_ghost.x, player_ghost.y )    -- give player a linear impuls for jumping
        player_ghost:setLinearVelocity( 0, -275 )                           -- give player a linear velocity for jumping
        jumpDecrease = jumpDecrease + 1                                     -- increase jump counter
        player:setSequence("jump")
    end

end

local function getDeltaTime( )
    local temp = system.getTimer()                                          -- Get current game time in ms
    local dt = ( temp-runtime ) / ( 1000/30 )                               -- 60 fps or 30 fps as base
    runtime = temp                                                          -- Store game time

    return dt
end

local function decrease_fps( )                                              -- function to decrease fps
    if ( fps_multiplicator >= 1 ) then                                      -- if fps_multiplicator is higher or exact 1 
        fps_multiplicator = fps_multiplicator /2                            -- fps_muliplicator is divided by 2
    end 
    if ( fps_multiplicator < 1 ) then                                       -- if fps multiplicator is smaller than 1
        player.isDead=true                                                  -- player is dead
        player_ghost.direction = nil                                        -- player stops moving
    end
end




function scene:create( event )                        
    local sceneGroup = self.view

    physics.start()                                                         -- physic has to be running to change value of gravity
    physics.setGravity( 0, 15 )                                             -- changing gravity of world (9.8 is gravity of earth)
    
    physics.pause()                                                         -- we don't need gravity by now so we stop it again
    
    physics.setDrawMode( "normal" )                                         -- can also be "hybrid" or "debug"
    
    local thisLevel = myData.settings.currentLevel

    player = spawnPlayer( 27.5, 274.5 )                                     -- create a player
    player.xScale = 0.4
    player.yScale = 0.4
    player:setFrame(10)
    player_ghost = spawnPlayerGhost( 27.5, 274.5 )                          -- create its ghost
    player_ghost.isFixedRotation = true                                     -- set its rotation to fixed so the player does not fall over when he jumps
    wallOuterLeft = spawnWall( 0, 160, 30, 320 )                                    -- adding level component
    wallOuterLeft:setFillColor( 0, 1, 0 )
    wallR = spawnWall( 1000, 160, 30, 320 )                                 -- adding level component
    wallR:setFillColor( 0, 0, 1 )
    floor = spawnPlatform( 450, 320, 900, 30 )                              -- adding level component
    floor:setFillColor( 0, 0, 0 )
    platform = spawnPlatform( 60, 200, 80, 1 )                             -- adding level component
    platform:setFillColor( 1, 0, 0 )
    platform1 = spawnPlatform( 220, 200, 80, 1 )                           -- adding level component
    increaseObject = spawnIncreasingObject( 890, 110 )                      -- adding level component
    increaseObject1 = spawnIncreasingObject( 969, 245 )                     -- adding level component
    increaseObject2 = spawnIncreasingObject( 643, 157 )                     -- adding level component
    increaseObject3 = spawnIncreasingObject( 827, 12 )                      -- adding level component
    decreaseObject = spawnIncreasingObject( 337, 253 )                      -- adding level component
    decreaseObject1 = spawnDecreasingObject( 817, 112 )                     -- adding level component
    decreaseObject2 = spawnIncreasingObject( 86, 227)                       -- adding level component
    decreaseObject3 = spawnDecreasingObject( 734, 60 )                      -- adding level component

    walkerEnemy = spawnWalkerEnemy( 250, 260 )
    walkerEnemy.xScale=0.15
    walkerEnemy.yScale=0.15
    walkerEnemy:play()
    walkerEnemy_ghost = spawnWalkerEnemyGhost( 250, 260 )
    enemies:insert( walkerEnemy )
    enemie_ghosts:insert( walkerEnemy_ghost )
    walkerEnemy1MovementRight()

    jumperEnemy = spawnJumperEnemy( 450, 275 )
    jumperEnemy.xScale=0.15
    jumperEnemy.yScale=0.15
    jumperEnemy:play()
    jumperEnemy_ghost = spawnJumperEnemyGhost( 450, 275 )
    enemies:insert( jumperEnemy )
    enemie_ghosts:insert( jumperEnemy_ghost )
    jumperEnemy1MovementDown()

    platform2 = spawnPlatform( 460, 200, 80, 10 )                           -- adding level component
    platform3 = spawnPlatform( 700, 200, 80, 10 )                           -- adding level component
    platform4 = spawnPlatform( 940, 200, 80, 10 )                           -- adding level component
    finishPlatform = spawnPlatform( 975, 310, 50, 10 )                      -- adding level component
    finishPlatform.typ = "finish"                                           -- giving this platform the typ "finish" for collision detection when player reaches the goal
    finishCoverPlatform = spawnPlatform( 950, 320, 100, 30 )                -- adding level component
    finishCoverPlatform:setFillColor( 1 )                                   -- adding level component 

    lButton = display.newRect(0,display.contentHeight,(display.contentWidth*2)/3,display.contentHeight)
    lButton:setFillColor(0,0,1)
    lButton.alpha = 0
    lButton.isHitTestable = true
    lButton:addEventListener( "touch", moveLeftButton )                     -- moveLeftButton

    rButton = display.newRect(display.contentWidth,display.contentHeight,(display.contentWidth*2)/3,display.contentHeight)
    rButton:setFillColor(0,0,1)
    rButton.alpha = 0
    rButton.isHitTestable = true
    rButton:addEventListener( "touch", moveRightButton )                    -- moveRightButton

    mButton = display.newRect(display.contentCenterX,display.contentHeight/4,display.contentWidth*2,display.contentHeight/2)
    mButton:setFillColor(0,0,1)
    mButton.alpha = 0
    mButton.isHitTestable = true
    mButton:addEventListener( "touch", jump )                               -- jumpButton    

    local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 0.6, 0.7, 0.3 )
    
    --
    -- Insert objects into the scene to be managed by Composer
    --
    
    -- these objects are not affected by the camera movement --
    sceneGroup:insert( background )
    sceneGroup:insert( lButton )
    sceneGroup:insert( rButton )
    sceneGroup:insert( mButton )
   

    -- these objects are effected by the camera movement --
    camera:add( player, 1 )
    camera:add( wallOuterLeft )
    camera:add( wallR )
    camera:add( floor ) 
    camera:add( player_ghost )
    camera:add( platform )
    camera:add( platform1 )
    camera:add( platform2 )
    camera:add( platform3 )
    camera:add( platform4 )
    camera:add( increaseObject )
    camera:add( increaseObject1 )
    camera:add( increaseObject2 )
    camera:add( increaseObject3 )
    camera:add( decreaseObject )
    camera:add( decreaseObject1 )
    camera:add( decreaseObject2 )
    camera:add( decreaseObject3 )
    camera:add( enemies ) 
    camera:add( enemie_ghosts )
    camera:add( finishPlatform )
    camera:add( finishCoverPlatform )


end

function scene:show( event )   
    local sceneGroup = self.view
    camera:setFocusY( player )                                              -- sets the camera on the right position before the game starts. 
    camera:trackY()                                                         -- camera will be focused in the y-axis of the player
    camera:cancel()                                                         -- camera stops tracking

    if ( event.phase == "did" ) then

        physics.start()                                                     -- enable physics
        
        function player_ghost:enterFrame()                                  -- each frame
            player:pause()
            for i=1, enemies.numChildren, 1 do
                enemies[i]:pause()
            end
            if ( player.y >= floor.y ) then                                 -- if the player is beneathe the lowest platform e.g. the floor
                player.isDead = true                                        -- the player is dead
            end
            if ( player.isDead ~= true ) then
                local delta = getDeltaTime()                                -- absolutely important
                --PLAYER MOVEMENT--
                
                if ( player_ghost.direction == nil ) then                   -- if player direction is nil the player should stop moving
                    player_ghost:translate( 0, 0 )
                end

                if ( player_ghost.direction == "right" ) then               -- if player direction is "right" player goes right
                    player_ghost:translate( 5*delta, 0)                     -- calculate delta to speed to prevent lagging of gameplay
                elseif ( player_ghost.direction == "left" ) then            -- if player direction is "left" player goes left
                    player_ghost:translate( -5*delta, 0)                    -- calculate delta to speed to prevent lagging of gameplay
                end
                

                if ( player_ghost.prevY ~= player_ghost.y ) then            -- if player y position is not equal to last frame
                    if ( player_ghost.y > player_ghost.prevY ) then         -- if y is smaller than in previous frame player is falling
                        player_ghost.isJumping = false                      -- set player_ghost jumping value to "false"
                    elseif ( player_ghost.y < player_ghost.prevY ) then     -- if y is bigger than in previous frame player is jumping
                        player_ghost.isJumping = true                       -- set player_ghost jumping value to "true"
                    end
                end
                
                player_ghost.prevX, player_ghost.prevY = player_ghost.x, player_ghost.y     -- synchronize players position for next frame

                --CAMERA MOVEMENT--
                if ( timerDelay >= timerRefresh/fps_multiplicator ) then    -- this method is an timer written on my own to decrease and increase the update of player with its ghost-self
                    local middleOfScreen = display.contentCenterX           -- this describes the middle of the screen
                    local endOfLevel = 1000                                 -- this descirbes the total length of the
                    player:play()
                    for i=1, enemies.numChildren, 1 do
                        enemies[i]:play()
                        walkerEnemy.x = walkerEnemy_ghost.x
                        jumperEnemy.y = jumperEnemy_ghost.y
                    end
                    player.x = player_ghost.x                               -- player position gets synchronized with its ghost-self
                    player.y = player_ghost.y                               -- player position gets synchronized with its ghost-self
                    if ( player.x < ( middleOfScreen ) ) then               -- if player did not leave start yet or goes back to start
                        camera:cancel()                                     -- camera will be disabled when there was already a camera tracking
                        camera.damping = 1
                        camera:setFocusY( player )                          -- camera will focus the player on the y-axis
                        camera:trackY()                                     -- camera will only track in y-axis
                    elseif ( player.x > ( endOfLevel - middleOfScreen ) + 15 ) then     -- if the player gets near the end
                        camera:cancel()                                     -- camera will be disabled when there was already a camera tracking
                        camera.damping = 1
                        camera:setFocusY( player )                          -- camera will focus the player on the y-axis
                        camera:trackY()                                     -- camera will be disabled when there was already a camera tracking
                    elseif ( player.isDead ~= true ) then                   -- if the player leaves the end or start area and is between both of them camera will be attached
                        camera:cancel()                                     -- camera will be disabled when there was already a camera tracking
                        camera.damping = 1                                  -- A bit more fluid tracking
                        camera:setFocus( player )                           -- Set the focus to the player
                        camera:track()                                      -- Begin auto-tracking
                    else
                        --camera:cancel()                                   -- Dead player don't need camera tracking :-P
                    end
                    
                    timerDelay=0                                            -- counter resets for working freezes
                end
                timerDelay = timerDelay +dt                                 -- increase timerDelay each frame to detect when next visible frame should be shown
            end
            if ( player.isDead == true or player.didFinish == true ) then   -- if the player finished the level or died - remove every object we created     
                if ( player.isDead == true ) then
                    composer.removeScene( "gameover" )                      -- if there is a gameover-scene already running we delete it
                    composer.gotoScene( "gameover", { time= 500, effect = "crossFade" } )   -- switch to gameover-scene
                elseif ( player.didFinish == true ) then
                    composer.removeScene( "winning" )                       -- if there is a winning-scene already running we delete it
                    composer.gotoScene( "winning", {time = 500, effect = "crossFade"} ) -- switch to winning-scene
                    endScore = neededtime
                    print(neededtime)
					compareLocalHighscore(neededtime)
                    compateWithOnlineHighscore()
                end
            end
        end
    Runtime:addEventListener( "enterFrame", player_ghost )                  -- adding eventListener "enterFrame" to the object of player_ghost
    transition.to( levelText, { time = 500, alpha = 0 } )                   -- show the name of the level and let it fade out


   function onPreCollision( self, event )

        local collideObject = event.other                                   -- get object you collided with
        if ( collideObject.collType == "passthru" and self.isJumping==true ) then   -- if object is of type "passthru" and the player is currently jumping
            if ( event.contact ~= nil ) then                                -- if event contact is a nil value ... it should not crash anymore
                event.contact.isEnabled = false                             -- disable this specific collision
            end                                                                           
        elseif ( ( collideObject.collType == "passthru" and self.isJumping==false ) or collideObject.typ == "ground" ) then     -- if object is of type "passthru" and player is not jumping or collided object is of type "ground"
            setJumpDecrease( 0 )                                            -- reset the jump counter
        end

        if ( collideObject.typ == "finish" ) then                           -- if object reaches the goal
            player.didFinish = true                                         -- player did finish the level
        end


        if ( collideObject.collType == "increase" and collideObject.alpha == 1 ) then   -- if collided object is an increasing object and visible
            timer.performWithDelay( 1, function() physics.removeBody( collideObject ) end ) -- perform a delay so we can remove the collision body
            increase_fps()                                                  -- function to increase fps
            collideObject.alpha = 0                                         -- object becomes invisible
            return true                                                     -- return true for completing collision detection
        elseif ( collideObject.collType == "decrease") then                 -- if collided object is an decreasing object and visible
            for i = 1, enemie_ghosts.numChildren, 1 do                      -- go through the enemie_ghost list
                if ( collideObject == enemie_ghosts[i] and enemies[i].alpha == 1) then  -- if collided object is found in enemy ghost list get the position and look for its representive in the enemies list and if that one is active then
                    enemies[i].alpha = 0                                    -- make it invisible
                    timer.performWithDelay( 1, function() physics.removeBody( collideObject ) end ) -- perform a delay so we can remove the collision body
                    decrease_fps()                                          -- function to decrease fps
                    return true                                             -- return true for completing collision detection
                end
            end
        end
        
    end

    player_ghost.preCollision = onPreCollision                              -- giving object a preCollision function
    player_ghost:addEventListener( "preCollision", player_ghost )           -- adding event listener "preCollision" to ghost_player

    elseif event.phase == "will" then
        
    end


end

function scene:hide( event )                                                                                            --HIDE FUNCTION
    local sceneGroup = self.view
    
    if event.phase == "will" then
        wallOuterLeft:removeSelf()
        wallR:removeSelf()
        floor:removeSelf()
        lButton:removeSelf()
        rButton:removeSelf()
        mButton:removeSelf()
        --player:removeSelf()                                               -- player can't be removed due to error occuring in camera script
        player.alpha = 0                                                    -- so we make him invisible
        Runtime:removeEventListener( "enterFrame",  player_ghost )          -- before removing the player_ghost we have to disable the runtime listener
        player_ghost:removeSelf()
        platform:removeSelf()
        platform1:removeSelf()
        platform2:removeSelf()
        platform3:removeSelf()
        platform4:removeSelf()
        increaseObject:removeSelf()
        increaseObject1:removeSelf()
        increaseObject2:removeSelf()
        increaseObject3:removeSelf()
        decreaseObject:removeSelf()
        decreaseObject1:removeSelf()
        decreaseObject2:removeSelf()
        decreaseObject3:removeSelf()
        
        transition.cancel(walkerEnemy_ghost)
        walkerEnemy:removeSelf()

        transition.cancel(jumperEnemy_ghost)
        jumperEnemy:removeSelf()

        finishPlatform:removeSelf()
        finishCoverPlatform:removeSelf()
        timer.cancel(countdowntimer)
        text:removeSelf()
        timeLeft:removeSelf()
        if ( myData.settings.musicOn ) then
            audio.stop()
            audio.play( audio.loadStream( "audio/menuMusic.mp3" ), { channel=1, loops=-1 } )
        end
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
