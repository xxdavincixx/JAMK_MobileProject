local composer = require( "composer" )
local scene = composer.newScene()
 
function scene:create( event ) 
 print( "((create scene restart's view))" ) 
 local params = event.params
 print(params.myData)
end --function scene:create( event )
 
function scene:show( event ) 
 local phase = event.phase 
 if "did" == phase then
  print( "((show scene restart's view))" ) 
  composer.removeScene( "level1" ) 
  composer.gotoScene( "level1", "fade", 0 )  
 end
end
 
function scene:hide( event ) 
 local phase = event.phase 
 if "will" == phase then
  print( "((hiding scene restart's view))" )  
 end
end
 
function scene:destroy( event )
 print( "((destroying scene restart's view))" )
end
 
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene