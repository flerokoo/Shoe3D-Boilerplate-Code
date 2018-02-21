package shoe3d.util.signal;

/**
 * ...
 * @author as
 */

class Sentinel implements Disposable
{

    public var isOnce(default, null):Bool = false;

    @:allow(shoe3d)
    private var _next:Sentinel;
    @:allow(shoe3d)
    private var _fn:Dynamic;
    private var _signal:Signal;

    public function new( signal:Signal, fn:Dynamic )
    {
        _signal = signal;
        _fn = fn;
        isOnce = false;
    }

    public function once():Sentinel
    {
        isOnce = true;
        return this;
    }

    public function dispose()
    {
        if ( _signal != null )
        {
            _signal.disconnectInner( this );
            _signal = null;
            _fn = null;
        }
    }

}