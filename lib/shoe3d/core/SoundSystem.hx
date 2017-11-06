package shoe3d.core;
import shoe3d.util.Value;
import soundjs.SoundManager;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class SoundSystem
{

	public static var muted(default, null):Value<Bool>;
	
	static function init() {
		muted = new Value(false);
		muted.change.connect( function(a, b) {
			SoundManager.muted = a;
		});
		return true;
	}
	/**
	 * 
	 * @param	id
	 * @param	volume 0-1
	 * @param	loop infinite: < 0; once: 0 (defualt)
	 */
	public static function play( id:String, volume:Float = 1, loop:Int = 0 ) {
		return SoundManager.play( id, { volume:volume, loop:loop } );		
	}
	
}