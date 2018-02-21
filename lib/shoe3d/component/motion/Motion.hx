package shoe3d.component.motion;
import motion.Actuate;
import shoe3d.core.game.Component;
import js.three.Object3D;

/**
 * ...
 * @author as
 */
class Motion extends Component
{

    private var _startOnAdded:Bool = false;
    public var delay:Float = 0;

    public function new()
    {
        super();
    }

    public function startOnAdded( start:Bool = true )
    {
        _startOnAdded = start;
        return this;
    }

    public function setDelay(d:Float )
    {
        delay = d;
        return this;
    }

    public function reset()
    {

    }

    public function start( doReset:Bool = true )
    {
        if ( doReset ) reset();
        if ( delay <= 0 ) animate()
            else Actuate.timer( delay ).onComplete( animate );
    }

    function animate()
    {

    }

    override public function onAdded()
    {
        if ( _startOnAdded ) start();
    }

}