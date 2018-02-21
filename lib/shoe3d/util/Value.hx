package shoe3d.util;
import shoe3d.util.signal.DoubleSignal;

/**
 * ...
 * @author as
 */

#if js
    //@:generic
#end

class Value<T>
{

    private var __:T;
    public var _(get, set):T;
    public var change(default, null):DoubleSignal<T,T>;

    public function new( initial:T )
    {
        __ = initial;
        change = new DoubleSignal();
    }

    public function set( to:T, noUpdate:Bool = false ):Value<T>
    {
        if ( noUpdate )
            __ = to;
        else
            _ = to;
        return this;
    }

    function get__():T
    {
        return __;
    }

    function set__(value:T):T
    {
        var old = _;
        __ = value;
        change.emit( this.__, old );
        return _;
    }

}