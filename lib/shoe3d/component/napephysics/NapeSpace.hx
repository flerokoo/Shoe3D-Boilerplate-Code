package shoe3d.component.napephysics;
import nape.geom.Vec2;
import nape.space.Broadphase;
import nape.space.Space;
import shoe3d.core.game.Component;

/**
 * ...
 * @author as
 */
class NapeSpace extends Component
{
	public var space(default, null):Space;
	
	public function new( grav:Vec2 = null, broadphase:Broadphase = null) 
	{
		super();
		space = new Space(grav, broadphase);
	}
	
	override public function onUpdate() 
	{
		super.onUpdate();
		space.step( 1 / 60 );		
	}
	
	override public function dispose() 
	{
		super.dispose();
		space =  null;
	}
	
}