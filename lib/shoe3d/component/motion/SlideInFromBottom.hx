package shoe3d.component.motion;
import motion.Actuate;
import motion.easing.Quad;
import motion.easing.Quint;
import js.three.Object3D;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class SlideInFromBottom extends Motion
{
	public var startPos:Vector3;
	
	public function new(  ) {
		super();
	}
	
	override public function onAdded() {		
		startPos = cast new Vector3().copy( owner.transform.position );
		super.onAdded();
	}
	
	override public function reset() {
		owner.transform.position.copy( startPos );
		owner.transform.position.y += 100;
		owner.get(Element2D).setAlpha(0);
	}
	
	override function animate() {
		Actuate.tween( owner.transform.position, 0.3, { y: startPos.y } ).ease( Quint.easeOut );
		Actuate.tween( owner.get(Element2D).alpha, 0.3, { _: 1 } ).ease( Quint.easeOut );
	}
	
}