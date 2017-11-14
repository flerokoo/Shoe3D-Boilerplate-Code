package shoe3d.core;
import haxe.Timer;
import js.Browser;
//import js.html.RequestAnimationFrameCallback;
import shoe3d.component.view2d.Element2D;
import shoe3d.core.game.GameObject;
import shoe3d.screen.ScreenManager;
import shoe3d.util.signal.SingleSignal;
import shoe3d.util.signal.ZeroSignal;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class MainLoop
{
	/**
	 *  Called on frame enter 
	 */
	private var _preframe:ZeroSignal;
	/**
	 *  Called after frame is skipped
	 */
	private var _onFrameSkip:ZeroSignal;
	/**
	 * Called on frame exit (Everything is updated)
	 */
	private var _frame:SingleSignal<Float>;
	private var _frames:Int = 0;
	private var _paused:Bool = true;
	private var _skipFrame:Bool = false;
	private var _totalUpdateTime:Float = 0;
	
	public var frameTime(default, null):Float;
	public var updateTime(default, null):Float;
	public var renderTime(default, null):Float;
	public var fpsHistory:Array<Float> = [];
	public var FPS(default, null):Float;
	public var paused:Bool = false;
	
	
	
	
	public function new() 
	{
		_frame = new SingleSignal();
		_preframe = new ZeroSignal();
		_onFrameSkip = new ZeroSignal();		
	}
	
	public function start() 
	{
		if ( untyped __js__("!window.requestAnimationFrame") ) 
		{		
			// check if requestAnimationFrame exists. Replace it with vendor-prefixed function/fallback otherwise	
			untyped __js__("window.requestAnimationFrame = (function(){window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || oRequestAnimationFrame || msRequestAnimationFrame" +
			"function(callback, el){window.setTimeout(callback, 1000/60);}; })() " );
		} 

		System.window.hidden.change.connect( function(hidden, _) {
			// skip first frame after show up
			if ( ! hidden ) skipFrame();
		} );

		var updateFrame = null;
		updateFrame = function(t) {
			update();
			Browser.window.requestAnimationFrame( updateFrame );
			return true;
		};
		Browser.window.requestAnimationFrame( updateFrame );
	}
	
	public function update(  ) 
	{
		_preframe.emit();

		var startTime;
		var middleTime;
		if ( System.window.hidden._ || paused ) return;
		if ( _skipFrame ) {
			_skipFrame = false;		
			_onFrameSkip.emit();	
			return;
		}
		
		
		System.time.update();
		middleTime = startTime = Time.now();		
		_frames++;
		//Element2D.lastLevel = 0;
		if ( ScreenManager._currentScreen != null ) 
		{
			ScreenManager._currentScreen.onUpdate();
			if( ScreenManager._currentScreen.layers != null )
				for ( layer in ScreenManager._currentScreen.layers ) 
				{
					for ( i in layer.children )
					{
						Element2D.lastAlpha = 1;
						updateGameObject( i );
					}
				}
		
					
			middleTime = Time.now();
			updateTime = middleTime - startTime;	
		
			render();	
			
			#if shoe3d_enable_late_update
			for ( layer in ScreenManager._currentScreen.layers ) {
				for ( i in layer.gameObjects )
				{
					lateUpdateGameObject( i );
				}
			}

			_currenScreen.onLateUpdate();
			#end
			
		}

		#if (actuate && actuate_manual_update)
		motion.actuators.SimpleActuator.stage_onEnterFrame();
		#end

		renderTime = Time.now() - middleTime;
		frameTime = Time.now() - startTime;
		_totalUpdateTime += frameTime;		
		fpsHistory.push( 1 / frameTime );
		if ( fpsHistory.length > 20 ) fpsHistory.shift();
		if ( fpsHistory.length == 20 ) {	
			FPS = 0;
			for ( i in fpsHistory )
				FPS += i;
			FPS /= fpsHistory.length;
		}		
		
		System.input.keyboard.onFrameExit();
		_frame.emit( Time.dt );	
		
	}
	
	function skipFrame()
	{
		_skipFrame = true;
	}
	
	function getTimingString():String
	{
		return "U" + round(updateTime * 1000) + "&Tab;R" + round(renderTime * 1000) + " =&Tab;" + round(frameTime * 1000);
	}
	
	function getFPSString():String
	{
		return "FPS: " + round( FPS, 1 );
	}
	
	function round( f:Float, m:Int = 100, l:Int = 4 ) 
	{
		var ret = Math.round( f * m ) / m;
		var str = Std.string(ret);
		
				
		if ( str.indexOf('.') >= 0 )
			while ( str.length <  l )
				str += '0';
		else if( l > 0 )
		{
			str += '.';
			while (str.length <  l )
				str += '0';
		}
		
		return str;
	}
	
	function render() 
	{
		System.renderer.render();
	}
	
	/*function pause()
	{
		_paused = true;
	}*/
	
	public function lateUpdateGameObject( go:GameObject )
	{
		for ( i in go.components ) {
				
			i.onLateUpdate();
		}
			
		
		for ( child in go.children )		
			lateUpdateGameObject( child );
		
	}
	
	public function updateGameObject( go:GameObject ) 
	{	
		
		for ( i in go.components ) {
			
			if ( ! i._started ) {
				i.onStart();
				i._started = true;
				i.onAfterStart();
			}
				
			
			i.onUpdate();
		}			
		
		for ( child in go.children ) {	
		
			updateGameObject( child );
		}
		
	}
	

	
}