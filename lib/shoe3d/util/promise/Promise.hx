package shoe3d.util.promise;
import shoe3d.util.signal.SingleSignal;
import shoe3d.util.Value;

/**
 * ...
 * @author as
 */
class Promise<T>
{

    private var _result:T;
    public var result(get, set):T;
    public var ready(default, null):Bool;
    public var success(default, null):SingleSignal<T>;
    public var error(default, null):SingleSignal<String>;
    public var progress(default, null):Value<Float>;
    private var _progress:Float;

    function get_result():T
    {
        if ( ! ready ) throw "Promise is not ready";
        return _result;
    }

    function set_result(value:T):T
    {
        if ( ready ) throw "Promise is ready";
        _result = value;
        ready = true;
        success.emit( value );
        return _result;
    }

    public function new()
    {
        success = new SingleSignal<T>();
        error = new SingleSignal<String>();
        progress = new Value<Float>( 0 );
        _progress = 0;
    }

}