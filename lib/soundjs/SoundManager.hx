package soundjs;
import js.three.EventDispatcher;

/**
 * ...
 * @author as
 */
@:native("createjs.Sound")
extern class SoundManager 
{
	/*
	 * 
	 *  DO NOT USE THIS CLASS DIRECTLY
	 * 	Instead, use System.sound
	 * 
	 * 
	 */ 
	public static var muted:Bool;
	public static function registerSound( src:String, id:String):Dynamic;
	public static function removeSound( id:String ):Dynamic;
	public static function on( event:String, listener:Dynamic ):Dynamic;
	public static function off( event:String, listener:Dynamic ):Dynamic;
	public static function createInstance( id:String, ?startTime:Float, ?duration:Float ):AbstractSoundInstance;
	/**
	 * 
	 * @param	id
	 * @param	playProps { delay, offset, loop(-1 for infinite), volume, pan, startTime, duration }
	 * @return
	 */
	public static function play( id:String, ?playProps:Dynamic ):AbstractSoundInstance;
	
}