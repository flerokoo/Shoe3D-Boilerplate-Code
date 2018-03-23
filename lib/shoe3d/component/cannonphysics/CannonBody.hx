package shoe3d.component.cannonphysics;
import cannonjs.Body;
import cannonjs.Body.BodySettings;
import cannonjs.Quaternion;
import cannonjs.Shape;
import cannonjs.Vec3;
import cannonjs.World;
import shoe3d.core.game.Component;

/**
 * ...
 * @author asd
 */
class CannonBody extends Component
{

    public var body:Body;
    public var world:CannonWorld;
    
    public function new(settings:BodySettings, world:CannonWorld) 
    {
        super();
        body = new Body(settings);
        this.world = world;
    }
    
    override public function onAdded() 
    {
        world.addBody(body);
    }
    
    override public function onUpdate() 
    {
        owner.transform.position.set(
            body.position.x,
            body.position.y,
            body.position.z
        );
        
        owner.transform.quaternion.set(
            body.quaternion.x,
            body.quaternion.y,
            body.quaternion.z,
            body.quaternion.w            
        );
    }
    
    override public function onRemoved() 
    {
        world.removeBody(body);
    }
    
    override public function dispose() 
    {
        super.dispose();
        world.removeBody(body);
        world = null;
        body = null;
    }
    
    public function addShape(shape:Shape, ?offset:Vec3, quat:Quaternion)
    {
        body.addShape( shape, offset, quat );
        return this;
    }
    
    public function removeShape(shape:Shape, ?offset:Vec3, quat:Quaternion)
    {
        throw 'Implement now suka';
        //body.removeShape( shape, offset, quat );
        return this;
    }   
    
}