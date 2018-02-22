package shoe3d.tween;
import shoe3d.util.Assert;
import shoe3d.util.Disposable;

/**
 * ...
 * @author asd
 */
class Tween implements Disposable
{

    public var onCompleteCallback:Void->Void;
    public var onProgressCallback:Float->Void;
    public var easing:Float->Float = Easing.quadOut;
    
    
    var _next:Tween;
    
    var _obj:Dynamic;
    var _dur:Float;
    var _from:Dynamic;
    var _to:Dynamic;
    
    
    var _delay:Float = 0;
    var _time:Float = 0;
    var _started:Bool = false;    
    public var completed(default, null):Bool = false;
    
    public function new( obj:Dynamic, duration:Float, ?fromProps:Dynamic, ?toProps:Dynamic ) 
    {
        _dur = duration;
        _obj = obj;
        
        Assert.that( toProps != null || fromProps != null );
        
        _from = fromProps;
        _to = toProps;
        
        checkAll();
    }
    
    function checkAll()
    {
        if ( _from == null )
        {
            _from = {};
            for ( field in Reflect.fields(_to) )
            {
                Reflect.setField( _from, field, Reflect.getProperty(_obj, field) );
            }
        }
        
        
        
        if ( _to == null )
        {
            _to = {};
            for ( field in Reflect.fields(_from) )
            {
                Reflect.setField( _to, field, Reflect.getProperty(_obj, field) );
            }
        }
    }
    
    public function dispose()
    {
        easing = null;
        onCompleteCallback = null;
        onProgressCallback = null;
        _from = null;
        _to = null;
        _obj = null;
        _next = null;
    }
    
    public function update( dt:Float )
    {
        if ( !_started || completed ) return;
        
        if ( _delay > 0 ) {
            _delay -= dt;
            return;
        }
        
        _time += dt;
        
        var progress = Math.min( _time / _dur, 1 );
        
        if ( progress < 1 )
        {
            for ( field in Reflect.fields(_from) )
            {
                var fromVal = Reflect.field( _from, field );
                var toVal = Reflect.field( _to, field );
                var lerped = fromVal + (toVal - fromVal) * easing( progress );
                Reflect.setProperty( _obj, field, lerped );
            }
            
            if ( onProgressCallback != null ) onProgressCallback(progress);
            
        } 
        else 
        {
            for ( field in Reflect.fields(_from) )
            {
                var toVal = Reflect.field( _to, field );        
                Reflect.setProperty( _obj, field, toVal );
            } 
            
            if ( onProgressCallback != null ) onProgressCallback(progress);
            
            complete();
        }
        
        
    }
    
    function complete()
    {
        completed = true;
        if ( onCompleteCallback != null )
        {
            onCompleteCallback();
        }
    }
    
    public function start()
    {
        _started = true;
    }
    
    public function onComplete( fn:Void->Void )
    {
        onCompleteCallback = fn;
        return this;
    }
    
    public function onProgress( fn:Float->Void ) 
    {
        onProgressCallback = fn;
        return this;
    }
    
    public function ease( easing:Float->Float )
    {
        this.easing = easing;
        return this;
    }
    
    public function delay( d:Float )
    {
        _delay = d;
        return this;
    }
    
    public function reset()
    {
        _time = 0;
        _delay = 0;
        _started = false;
        completed = false;
    }
}