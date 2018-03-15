package shoe3d.tween;
import shoe3d.util.Assert;
import shoe3d.util.Disposable;

/**
 * ...
 * @author asd
 */
class Tween
{

    public var onCompleteCallback:Void->Void;
    public var onProgressCallback:Float->Float->Void;
    public var easing:Float->Float = Easing.quadOut;
    
    
    var _next:Tween;
    
    var _obj:Dynamic;
    var _dur:Float;
    var _from:Dynamic;
    var _to:Dynamic;
    
    
    var _delay:Float = 0;
    var _time:Float = 0;
    var _started:Bool = false;    
    var _propsFilled:Bool = false;
    
    var _context:TweenContext;
    var _chained:Tween = null;
    
    public var completed(default, null):Bool = false;
    
    public function new( obj:Dynamic, duration:Float ) 
    {
        _dur = duration;
        _obj = obj;        
    }
    
    function fillEmptyPropertyDicts()
    {
        Assert.that( _to != null || _from != null );
        
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
        
        _propsFilled = true;
    }
    
    public function to(props:Dynamic)
    {
        _to = props;
        return this;
    }
    
    public function from(props:Dynamic)
    {
        _from = props;
        return this;
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
        _chained = null;
        _context = null;
    }
    
    public function update( dt:Float )
    {
        if ( !_started || completed ) return;
        
        if ( ! _propsFilled ) fillEmptyPropertyDicts();
        
        if ( _delay > 0 ) {
            _delay -= dt;
            return;
        }
        
        _time += dt;
        
        var progress = Math.min( _time / _dur, 1 );
        var easedProgress = easing( progress );
        
        if ( progress < 1 )
        {
            for ( field in Reflect.fields(_from) )
            {
                var fromVal = Reflect.field( _from, field );
                var toVal = Reflect.field( _to, field );
                var lerped = fromVal + (toVal - fromVal) * easedProgress;
                Reflect.setProperty( _obj, field, lerped );
            }
            
            if ( onProgressCallback != null ) onProgressCallback(progress, easedProgress);
            
        } 
        else 
        {
            for ( field in Reflect.fields(_from) )
            {
                var toVal = Reflect.field( _to, field );        
                Reflect.setProperty( _obj, field, toVal );
            } 
            
            if ( onProgressCallback != null ) onProgressCallback(progress, easedProgress);
            
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
        
        if ( _chained != null )
        {
            _chained.start();
        }
    }
    
    public function chain( obj:Dynamic, duration:Float ):Tween
    {
        var tween = _context.get( obj, duration );        
        _chained = tween;
        return tween;
    }
    
    public function timer( duration:Float ):Tween
    {
        var tween = _context.timer( duration, false );        
        _chained = tween;
        return tween;
    }
    
    public function start()
    {
        _started = true;
        return this;
    }
    
    public function onComplete( fn:Void->Void )
    {
        onCompleteCallback = fn;
        return this;
    }
    
    public function onProgress( fn:Float->Float->Void ) 
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

    public function stop():Tween
    {
        completed = true;
        return this;
    }
}