package shoe3d.component.napephysics;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Shape;
import shoe3d.core.game.Component;

/**
 * ...
 * @author as
 */
class NapeBody extends Component
{
	public var space:NapeSpace;
	public var body:Body;
	
	public function new(space:NapeSpace, bodyType:BodyType = null ) 
	{
		super();
		this.space = space;
		body = new Body(bodyType);
	}
	
	public function addShape( shape:Shape ) 
	{
		body.shapes.add( shape );
		body.align();
		return this;
	}
	
	public function setPosXY( x:Float, y:Float ) {
		body.position.setxy( x, y );
		return this;
	}
	
	public function setVelocityXY( x:Float, y:Float ) {
		body.velocity.setxy( x , y );
		return this;
	}
	
	public function setRotation( a:Float ) {
		body.rotation = a;
		return this;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		space.space.bodies.add( body );
	}
	
	override public function onUpdate() 
	{
		super.onUpdate();
		owner.transform.position.set( body.position.x, 0, body.position.y );
		owner.transform.rotation.set( 0, -body.rotation, 0);
	}
	
	override public function onRemoved() 
	{
		space.space.bodies.remove( body );
	}
	
	override public function dispose() 
	{
		super.dispose();
		body = null;
		space = null;
	}
}