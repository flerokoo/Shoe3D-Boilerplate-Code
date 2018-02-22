package shoe3d.tween;

/**
 * ...
 * @author asd
 */
class Tweener 
{

    public static var global(get, null):TweenContext;
    public static var local(get, null):TweenContext;
    
    static var _inited = false;
    
          
    public static function init() 
    {
        if ( _inited ) return;       
        _inited = true;
        global = new TweenContext();
        local = new TweenContext();
        System.screen.onScreenChange.connect( onContextChange );
        System._loop._frame.connect( update );
    }   
    
    static function onContextChange(name)
    {
        local.reset();
    }
    
    static function get_local():TweenContext 
    {
        if( !_inited ) init();
        return local;
    }
    
    static function get_global():TweenContext 
    {
        if( !_inited ) init();
        return global;
    }
    
    public static function update( dt:Float )
    {
        global.update(dt);
        local.update(dt);
    }
    
    
    
}