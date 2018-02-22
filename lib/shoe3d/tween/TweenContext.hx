package shoe3d.tween;
import motion.Actuate;
import shoe3d.util.Disposable;

/**
 * ...
 * @author asd
 */

@:access(shoe3d.tween.Tween)
class TweenContext
{

    var _first:Tween;
    var _last:Tween;
    
    public function new() 
    {
        
    }
    
    public function update( dt:Float )
    {          
        var cur = _first;
        var prev:Tween = null;
        while ( cur != null )
        {
            if ( cur.completed ) 
            {
                if ( prev != null ) 
                {
                    prev._next = cur._next;
                } else {
                    _first = cur._next;
                }
                
                cur = cur._next;                
                continue;
            }
            
            cur.update(dt);
            _last = cur; // update last reference
            prev = cur;
            cur = cur._next;
        }        
    }
    
    public function to( obj:Dynamic, duration:Float, props:Dynamic, autoStart:Bool = true )
    {
        var tween = new Tween( obj, duration, null, props );
        addTween(tween);
        
        if ( autoStart ) 
        {
            tween.start();
        }
        
        return tween;
    }
    
    public function from( obj:Dynamic, duration:Float, props:Dynamic, autoStart:Bool = true )
    {
        var tween = new Tween( obj, duration, props );
        addTween(tween);
        
        if ( autoStart ) 
        {
            tween.start();
        }
        
        return tween;
    }
    
    function addTween( tween:Tween )
    {
        if ( _first == null ) 
        {
            _first = _last = tween;
        } 
        else
        {
            _last._next = tween;
            _last = tween;
        }
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
    }
    
}