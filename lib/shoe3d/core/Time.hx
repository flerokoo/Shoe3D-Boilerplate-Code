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
	public static var timeSinceScreenShow(default, null):Float;
	public static var now(default, null):Void->Float;	
	public static var timeScale(default, set):Float = 1;
	public static var tick:SingleSignal<Float>;
	
	private static var _gameStartTime:Float;
	private static var _lastUpdateTime:Float;
	private static var _screenShowTime:Float;
	
	
	public function new() 
	{
		
			
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
		tick = new SingleSignal();
		System.screen.onScreenChange.connect(onScreenLoad);
		return true;
	}
	
	public static function update() {
		var cur = now();
		
		dt = cur - _lastUpdateTime;		
		dt *= timeScale;
		timeSinceGameStart = cur - _gameStartTime;		
		timeSinceScreenShow = cur - _screenShowTime;		
		if ( dt > 1 ) dt = 1;
		if ( dt < 0 ) dt = 0;
		
		
		_lastUpdateTime = cur;
		tick.emit( dt );
		
	}
	
	private static function onScreenLoad(?e) 
	{
		_screenShowTime = now();
	}
	
	private static function _now():Float
	{
		return (untyped Date).now() / 1000;
	}
	
	static function set_timeScale(value:Float):Float 
	{
		return timeScale = SMath.clamp( value, 0, Math.POSITIVE_INFINITY );
	}
	
}