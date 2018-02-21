package shoe3d.component.script.action;
import shoe3d.util.Assert;
import shoe3d.util.Log;

/**
 * ...
 * @author as
 */
class Parallel implements Action
{

    public var actions:Array<Action>;

    var _doneness:Array<Bool>;

    public function new( acts:Array<Action> )
    {
        Assert.that( acts.length > 0 );
        actions = acts;
        _doneness = [for (i in 0...actions.length) false];
    }

    public function start():Void
    {
        for ( i in 0..._doneness.length) _doneness[i] = false;
        for ( i in actions ) i.start();
    }

    public function update( dt:Float ):Bool
    {
        var done = true;

        for ( i in 0...actions.length )
        {
            if ( ! _doneness[i] )
            {
                var action = actions[i];
                var actionComplete = action.update( dt );
                if ( actionComplete ) _doneness[i] = true;
                done = done && actionComplete;
            }

        }
        return done;
    }

}