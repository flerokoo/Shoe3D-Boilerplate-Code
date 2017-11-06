package soundjs;

/**
 * ...
 * @author as
 */
@:native("createjs.AbstractSoundInstance")
extern class AbstractSoundInstance
{

	public function play( ?params:Dynamic ):AbstractSoundInstance;
	public function stop():AbstractSoundInstance;
	
	public var paused:Bool;
	public var volume:Float;
	

}