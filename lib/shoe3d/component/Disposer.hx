package shoe3d.component;
import shoe3d.core.game.Component;
import shoe3d.core.game.GameObject;
import shoe3d.util.Disposable;
import shoe3d.util.Log;

/**
 * ...
 * @author as
 */
class Disposer extends Component
{
    var a:Array<Disposable>;

    public function new()
    {
        super();
        a = [];
    }

    public function add( d:Disposable )
    {
        a.push(d);
        return this;
    }

    override public function dispose()
    {
        if ( a != null ) 
        {
            for ( d in a ) d.dispose();
            a  = null;
        }
        super.dispose();
    }

    public function remove( d:Disposable )
    {
        return a.remove(d);
    }

    override public function onRemoved()
    {
        dispose();
    }

    public static function getFrom( e:GameObject ):Disposer
    {
        var disp = e.get(Disposer);
        if ( disp == null )
        {
            disp = new Disposer();
            e.add( disp );
        }
        return disp;
    }
}