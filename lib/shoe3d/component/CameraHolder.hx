package shoe3d.component;
import shoe3d.core.game.Component;
import shoe3d.core.Time;
import js.three.Camera;
import js.three.PerspectiveCamera;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class CameraHolder extends Component
{

    public var camera:PerspectiveCamera;

    public function new()
    {
        super();
    }

    override public function onAdded()
    {

    }

    override public function onUpdate()
    {
        if ( owner.layer != null && owner.layer.camera != null )
        {
            owner.layer.camera.position.set( Math.cos(Time.timeSinceGameStart * 0.2 ), Math.sin( Time.timeSinceGameStart * 0.2 ), 0 ).multiplyScalar( 40 );
            owner.layer.camera.lookAt( new Vector3( 0, 0, 0 ) );
        }
    }

}