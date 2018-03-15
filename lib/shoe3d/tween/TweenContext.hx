package shoe3d.tween;
import haxe.ds.ObjectMap;
import js.three.ObjectType;
import motion.Actuate;
import shoe3d.util.Assert;
import shoe3d.util.Disposable;

/**
 * ...
 * @author asd
 */

@:access(shoe3d.tween.Tween)
@:access(shoe3d.tween.Tween)
class TweenContext
{

    var _first:Tween;
    var _last:Tween;
    var _map:ObjectMap<Dynamic, Array<Tween>>;
    var _dummy:Dynamic = { time: 0 };
    
    public function new() 
    {
        reset();
    }
    
    public function update( dt:Float )
    {          
       
        var cur = _first;
        var prev:Tween = null;
        while ( cur != null )
        {
            if ( cur.completed ) 
            {
                removeFromMap(cur);
                
                if ( prev != null ) 
                {
                    prev._next = cur._next;
                } else {
                    _first = cur._next;
                }
                
                var old = cur;                
                cur = cur._next;     
                old.dispose();
                
                continue;
            }
            cur.update(dt);
            
            _last = cur; // update last reference
            prev = cur;
            cur = cur._next;
        }        
    }
    
    
    public function start( obj:Dynamic, duration:Float, killOther:Bool = true ):Tween
    {
        return get(obj, duration, killOther).start();
    }
    
    public function get( obj:Dynamic, duration:Float, killOther:Bool = true ):Tween
    {
        if( killOther ) stopTweensOf( obj );
        
        var tween = new Tween( obj, duration );
        tween._context = this;
        
        addTween(tween);
        return tween;
    }
    
    public function timer(duration:Float, autoStart:Bool = true):Tween
    {
        var tween = get( _dummy, duration ).to( { time: duration } );
        if ( autoStart ) tween.start();
        return tween;
    }
    
    public function stopTweensOf( obj:Dynamic )
    {
        if ( _map.get(obj) != null )
        {
            for ( i in _map.get(obj) )
            {
                i.stop();    
            }
        }     
        
        return this;        
    }
    
    public function addTween( tween:Tween )
    {
        Assert.that(tween != null);
        
        tween._context = this;
        
        if ( _first == null ) 
        {
            _first = _last = tween;
        } 
        else
        {
            _last._next = tween;
            _last = tween;
        }
        
        addTweenToMap( tween );
    }
    
    public function reset()
    {
        var cur = _first;
        var prev:Tween = null;
        
        var n = 0;
        
        while (cur != null )
        {
            var next = cur._next;
            cur.dispose();
            cur = next;
        }        
        
        _first = _last = null;
        _map = new ObjectMap<Dynamic, Array<Tween>>();
    }
    
    function  addTweenToMap( tween:Tween )
    {
        Assert.that(tween != null);
        
        if ( _map.get(tween._obj) == null )
        {
            _map.set(tween._obj, [tween]);
        }
        else
        {
            _map.get(tween._obj).push( tween );
        }
    }
    
    function removeFromMap( tween:Tween )
    {
        Assert.that(tween != null);
        
        var lib = _map.get(tween._obj);
        if ( lib != null )
        {
            var i = lib.indexOf(tween);
            lib.splice(i, 1);
        }
    }
    
    
}

