package shoe3d.component.script.action;

/**
 * ...
 * @author as
 */
interface Action
{

	public function start():Void;
	
	/**
	 * Return true if action comlete
	 * @return
	 */
	public function update( dt:Float ):Bool;
	
}