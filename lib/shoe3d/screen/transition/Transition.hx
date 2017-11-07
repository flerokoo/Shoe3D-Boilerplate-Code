package shoe3d.screen.transition;
import shoe3d.core.game.GameObject;
import shoe3d.screen.GameScreen;
import shoe3d.util.signal.*;
import js.three.Scene;


class Transition
{

	public var onComplete:ZeroSignal;

	public function new() 
	{
		onComplete = new ZeroSignal();
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
		onComplete.emit();
	}
	
}