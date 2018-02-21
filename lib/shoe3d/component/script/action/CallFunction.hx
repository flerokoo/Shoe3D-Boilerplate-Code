package shoe3d.component.script.action;
import shoe3d.util.Assert;

/**
 * ...
 * @author as
 */
class CallFunction implements Action
{

    var _fn:Void->Void;

    public function new( fn:Void->Void )
    {
        Assert.that( fn != null );
        _fn = fn;
    }

    public function start()
    {

    }

    public function update( dt:Float ):Bool
    {
        _fn();
        return true;
    }

}