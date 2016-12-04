local composer = require( "composer" )
local scene = composer.newScene()
 
function scene:create( event ) 
 local params = event.params
end --function scene:create( event )
 
function scene:show( event ) 
 local phase = event.phase 
 if "did" == phase then
  composer.removeScene( "level2" ) 
  composer.gotoScene( "level2", "fade", 0 )  
 end
end
 
function scene:hide( event ) 
 local phase = event.phase 
 if "will" == phase then
 end
end
 
function scene:destroy( event )
end
 
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene