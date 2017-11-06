package shoe3d.component;
import shoe3d.core.game.Component;
import shoe3d.core.Time;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class RandomRotator extends Component
{

	var t = 0;
	
	public function new() 
	{
		super();
	}
	
	override public function onUpdate() 
	{
		
		/*var h = owner.get(CameraHolder );		
		h.camera.position.set(  Math.cos(Time.timeSinceGameStart), Math.sin( Time.timeSinceGameStart ) , 0 ).multiplyScalar( 20 );		
		h.camera.lookAt( owner.transform.worldToLocal(new Vector3(0, 0, 0))  );*/
		
		
		owner.transform.position.set(  Math.cos(Time.timeSinceGameStart), Math.sin( Time.timeSinceGameStart ) , 0 ).multiplyScalar( 20 );		
		owner.transform.lookAt( owner.transform.worldToLocal(new Vector3(0, 0, 0))  );
		
	}
	
	
	
}