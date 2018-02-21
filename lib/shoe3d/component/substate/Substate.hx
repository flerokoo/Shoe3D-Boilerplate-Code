package shoe3d.component.substate;
import shoe3d.core.game.Component;

/**
 * ...
 * @author as
 */
class Substate extends Component
{
    public var hidableByOtherSubstate:Bool = true;

    public function new( )
    {
        super();
    }

    override public function onAdded()
    {
        onCreate();
    }

    public function onCreate()
    {

    }

    public function onShow()
    {

    }

    /**
     * Callback should be called when hiding animations complete
     * @param	callback
     */
    public function onHide( callback:Void->Void )
    {
        callback();
    }

}