package shoe3d.component.script.action;
import shoe3d.util.Assert;
import shoe3d.util.Log;

/**
 * ...
 * @author as
 */
class Sequence implements Action
{
	
	public var actions:Array<Action>;

	var _idx = 0;
	
	public function new( acts:Array<Action> ) 
	{
		Assert.that( acts.length > 0 );
		actions = acts;
	}
	
	public function start():Void
	{
		_idx = 0;
		actions[_idx].start();
	}

	
	public function update( dt:Float ):Bool
	{		
		if ( actions[_idx].update( dt ) ) {			
			_idx++;		
			if ( _idx >= actions.length ) {	
				return true;
			}
			actions[_idx].start();
		}
		return false;
	}
	
}