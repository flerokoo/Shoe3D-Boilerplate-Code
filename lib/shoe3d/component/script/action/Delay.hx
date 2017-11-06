package shoe3d.component.script.action;
import shoe3d.core.Time;

/**
 * ...
 * @author as
 */
class Delay implements Action
{

	var _fn:Void->Float;
	var _delay:Float = 0.0;
	var _cur:Float = 0;
	
	public function new( delay:Dynamic ) 
	{
		if( Std.is(delay, Float) ) {
			_delay = delay;
		} else {
			_fn = delay;
		}
	}
	
	public function start()
	{
		_cur = _fn == null ? _delay : _fn();
	}
	
	public function update(dt:Float )
	{
		_cur -= dt;
		return _cur <= 0;		
	}
	
}