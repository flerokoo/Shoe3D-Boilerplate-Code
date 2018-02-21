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

    var _firstComponentIndex = 0;
    var _secondComponentIndex = 2;
    var _rotationComponentIndex = 1;

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

    public function setPosXY( x:Float, y:Float )
    {
        body.position.setxy( x, y );
        return this;
    }

    public function setVelocityXY( x:Float, y:Float )
    {
        body.velocity.setxy( x, y );
        return this;
    }

    public function setRotation( a:Float )
    {
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
        owner.transform.position.setComponent( _firstComponentIndex, body.position.x );
        owner.transform.position.setComponent( _secondComponentIndex, body.position.y );
        owner.transform.rotation.setComponent( _rotationComponentIndex, body.rotation );
    }

    override public function onRemoved()
    {
        space.space.bodies.remove( body );
    }

    public function setCoordinatesMapping( x:Int, y:Int )
    {
        _firstComponentIndex = x;
        _secondComponentIndex = y;
        return this;
    }

    public function setRotationMapping(i:Int)
    {
        _rotationComponentIndex = i;
        return this;
    }

    override public function dispose()
    {
        super.dispose();
        body = null;
        space = null;
    }
}