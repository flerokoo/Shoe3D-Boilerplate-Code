package shoe3d.component.script;
import shoe3d.component.script.action.Action;
import shoe3d.core.game.Component;
import shoe3d.core.Time;
import shoe3d.util.signal.ZeroSignal;

/**
 * ...
 * @author as
 */
class Script extends Component
{
	public var onComplete(default,null):ZeroSignal;
	
	var _action:Action;
	var _running:Bool = false;
	
	public function new( action:Action, startOnAdded:Bool = false ) 
	{
		super();
		_action = action;
		_running = startOnAdded;
		onComplete = new ZeroSignal();
	}
	
	override public function onAdded() 
	{
		if ( _running ) run();
	}
	
	
	override public function onUpdate() 
	{
		if ( _running ) {
			var flag = _action.update( Time.dt );
			
			if ( flag ) {			
				_running = false;
				onComplete.emit();
			}
		}
	}
	
	public function run()
	{
		_action.start();
		_running = true;
		return this;
	}
}