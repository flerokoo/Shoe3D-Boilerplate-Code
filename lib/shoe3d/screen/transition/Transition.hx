package shoe3d.screen.transition;
import shoe3d.core.game.GameObject;
import shoe3d.screen.GameScreen;
import js.three.Scene;

/**
 * ...
 * @author as
 */
class Transition
{

	public function new() 
	{
		
	}
	
	public function start( currentScreen:GameScreen, targetScreen:GameScreen, ?fn:Void->Void ) 
	{
		//_holder.remove( currentScreen.scene );
		//_holder.add( targetScreen.scene );
		
		if( currentScreen != null ) currentScreen.onHide();
		if ( fn != null ) fn();
		targetScreen.onShow();
		
		ScreenManager._currentScreen = targetScreen;
		
		end();
	}
	
	public function end() 
	{
		
	}
	
}