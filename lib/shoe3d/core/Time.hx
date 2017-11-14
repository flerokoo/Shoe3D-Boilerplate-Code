package shoe3d.core;
import haxe.Timer;
import js.Browser;
import shoe3d.util.HtmlUtils;
import shoe3d.util.Log;
import shoe3d.util.signal.SingleSignal;
import shoe3d.util.SMath;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class Time
{

	public static var dt(default, null):Float;
	public static var timeSinceGameStart(default, null):Float;
	/**
	 *  Counting paused time
	 */
	private static var _timeSinceGameStartDirty(default, null):Float;
	public static var timeSinceScreenShow(default, null):Float;
	private static var _timeSinceScreenShowDirty(default, null):Float;
	public static var now(default, null):Void->Float;	
	public static var tick:SingleSignal<Float>;
	
	private static var _gameStartTime:Float;
	private static var _lastUpdateTime:Float;
	private static var _screenShowTime:Float;
	private static var _pauseStartTime:Float = 0;
	private static var _totalPausedTime:Float = 0;
	private static var _totalPausedTimeOnCurrentScreen:Float = 0;
	
	public function new() {
		
			
	}
	
	private static function init() {
		var performance = Browser.window.performance;
		var hasPerformance = performance != null && HtmlUtils.polyfill( "now", performance );
		if ( hasPerformance ) {
			now = function() { return performance.now() / 1000; };
			Log.sys( "Using window.performance timer" );
		} else {
			now = _now;
			Log.sys( "No window.performance, using system date" );
		}			
		_lastUpdateTime = _gameStartTime = now();
		timeSinceGameStart = timeSinceScreenShow = 0;
		tick = new SingleSignal();
		System.screen.onScreenChange.connect(onScreenLoad);
		System._loop._onFrameSkip.connect(onSkipFrame);
		/*WindowManager.hidden.change.connect(function(hidden,_){
			if (hidden) {
				_pauseStartTime = now();
			} else {
				var delta = now() - _pauseStartTime;
				_totalPausedTime += delta;
				_totalPausedTimeOnCurrentScreen += delta;
			}
		});*/

		return true;
	}
	
	public static function update() {
		var cur = now();
		
		dt = SMath.clamp(cur - _lastUpdateTime, 0, 1);		
		
		// just accumulating time (+=dt) should be accurate enough
		// that's just a game, not a rocket 
		
		//_timeSinceGameStartDirty = cur - _gameStartTime;		
		//timeSinceGameStart = _timeSinceGameStartDirty - _totalPausedTime;		
		timeSinceGameStart += dt;

		//_timeSinceScreenShowDirty = cur - _screenShowTime;		
		//timeSinceScreenShow = _timeSinceScreenShowDirty - _totalPausedTimeOnCurrentScreen;
		timeSinceScreenShow += dt;				
		
		_lastUpdateTime = cur;
		tick.emit( dt );
		
	}

	private static function onSkipFrame() {
		_lastUpdateTime = now();
	}
	
	private static function onScreenLoad(?e) {
		//_totalPausedTimeOnCurrentScreen = 0;
		//_screenShowTime = now();
		timeSinceScreenShow = 0;
	}
	
	private static function _now():Float {
		return (untyped Date).now() / 1000;
	}
	
	/*static function set_timeScale(value:Float):Float 
	{
		return timeScale = SMath.clamp( value, 0, Math.POSITIVE_INFINITY );
	}*/
	
}