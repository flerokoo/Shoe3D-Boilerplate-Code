package shoe3d.component.cannonphysics;
import cannonjs.Body;
import cannonjs.Vec3;
import cannonjs.World;
import shoe3d.core.Time;
import shoe3d.core.game.Component;

/**
 * ...
 * @author asd
 */
class CannonWorld extends Component
{

    public var timestep = 1 / 60;
    public var world:World;
    
    
    public function new( ?gravity:Vec3 ) 
    {
        super();
        world = new World();
        if( gravity != null ) world.gravity.copy(gravity);
    }
    
    override public function onAdded() 
    {
        
    }
    
    override public function onUpdate() 
    {
        world.step(timestep, Time.dt);
    }
    
    override public function dispose() 
    {
        // maybe remove everything from world
    }
    
    public function addBody( body:Body )
    {
        world.addBody( body);
        return this;
    }
    
    public function removeBody( body:Body )
    {
        world.removeBody( body);
        return this;
    }
}