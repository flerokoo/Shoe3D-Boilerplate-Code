package shoe3d.component.napephysics;
import nape.geom.Vec2;
import nape.space.Broadphase;
import nape.space.Space;
import shoe3d.core.game.Component;
import shoe3d.core.Time;

/**
 * ...
 * @author as
 */
class NapeSpace extends Component
{
    public var timestep:Float = 1/30;
    public var space(default, null):Space;
    var _accumulatedTime = 0.0;

    public function new(grav:Vec2 = null, broadphase:Broadphase = null)
    {
        super();
        space = new Space(grav, broadphase);
    }

    override public function onUpdate()
    {
        super.onUpdate();

        _accumulatedTime += Time.dt;

        while (_accumulatedTime >= timestep)
        {
            space.step( timestep );
            _accumulatedTime -= timestep;
        }
    }

    override public function dispose()
    {
        super.dispose();
        space = null;
    }

}