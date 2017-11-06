package shoe3d.core.input;
import shoe3d.component.Element2D;
import shoe3d.core.Layer2D;
import shoe3d.util.Log;
import shoe3d.util.Pointable;
import shoe3d.util.signal.SingleSignal;
import js.three.Vector2;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class PointerManager
{
	
	public var supported (get, null) :Bool;

    public var down (default, null) :SingleSignal<PointerEvent>;
    public var move (default, null) :SingleSignal<PointerEvent>;
    public var up (default, null) :SingleSignal<PointerEvent>;

    public var x (get, null) :Float;
    public var y (get, null) :Float;
	
	private static var _sharedEvent = new PointerEvent();
    private static var _scratchPoint = new Vector2();

    private var _x :Float;
    private var _y :Float;
    private var _isDown :Bool;
	
	public function new() 
	{
		down = new SingleSignal();
		move = new SingleSignal();
		up = new SingleSignal();
	}
	
	public function get_supported () :Bool
    {
        return true;
    }
	
	public function get_x () :Float
    {
        return _x;
    }

    public function get_y () :Float
    {
        return _y;
    }

    public function isDown () :Bool
    {
        return _isDown;
    }
	
	function submitDown(viewX :Float, viewY :Float, source :EventSource)
	{
		if ( _isDown ) return;
		
		submitMove( viewX, viewY, source );
		_isDown = true;
		
		
		//
		var result = getHitAndChain( viewX, viewY );
	
		
		prepare(viewX, viewY, result != null ? result.hit : null, result != null ? result.layer : null,  source);
		//for ( chain in chains )
		if( result != null )
			for ( e in result.chain ) 
			{
				e.onPointerDown( _sharedEvent );				
				if ( _sharedEvent._stopped ) return;
			}
		
		// layer is Layer2D, it's checked in gitHitAndChain, also result.chain.length is >0
		if ( result != null && ! _sharedEvent._stopped ) result.layer.onPointerDown( _sharedEvent );
			
		if( ! _sharedEvent._stoppedToStage ) down.emit( _sharedEvent );
	}
	
	function getHitAndChain( viewX:Float, viewY:Float ) : { hit:Element2D, chain:Array<Element2D>, layer:Layer2D }
	{
		//var lastHit:Element2D = null;
		//var chains:Array<Array<Element2D>> = [];
		if ( System.screen._currentScreen != null && System.screen._currentScreen.layers != null) { 
			var li = System.screen._currentScreen.layers.length - 1;
			while( li >= 0 )
			{
				var layer = System.screen._currentScreen.layers[li];
				if ( Std.is(layer, Layer2D) && cast( layer, Layer2D ).pointerEnabled && cast( layer, Layer2D ).visible ) {					
					var chain = [];
					var hit:Element2D = null;
					var n = layer.children.length - 1;
					while ( n >= 0 )
					{
						var hit = Element2D.hitTest( layer.children[n], viewX, viewY );
						if ( hit != null )
						{
							//lastHit = hit;
							var e = hit.owner;
							do {
								var spr = e.get( Element2D );
								if ( spr != null ) 
									chain.push( spr );
								e = e.parent;
							} while (e != null );
							//chains.push( chain );
							//break;
							return { hit: hit, chain: chain, layer: cast(layer,Layer2D) };
						}
						n--;
					}					
				}
				li--;
			}
		}
		
		return null;
	}
	
	function submitMove(viewX :Float, viewY :Float, source :EventSource)
	{
		if (viewX == _x && viewY == _y) return;
		
		var result = getHitAndChain( viewX, viewY );
	
		prepare(viewX, viewY, result != null ? result.hit : null, result != null ? result.layer : null,  source);
		
		if( result != null )
			for ( e in result.chain ) 
			{
				e.onPointerMove( _sharedEvent );
				if ( _sharedEvent._stopped ) return;
			}
		
		if ( result != null && ! _sharedEvent._stopped ) result.layer.onPointerMove( _sharedEvent );
		
		
		if( ! _sharedEvent._stoppedToStage ) move.emit( _sharedEvent );
	}
	
	function submitUp(viewX :Float, viewY :Float, source :EventSource)
	{
		if ( ! _isDown ) return;
		var hit:Element2D = null;
		
		submitMove( viewX, viewY, source );
		_isDown = false;
		
		
		var result = getHitAndChain( viewX, viewY );		
		
		prepare(viewX, viewY, result != null ? result.hit : null, result != null ? result.layer : null,  source);
		//for ( chain in chains )
		if( result != null )
			for ( e in result.chain ) 
			{
				e.onPointerUp( _sharedEvent );				
				if ( _sharedEvent._stopped ) return;
			}
			
		if ( result != null && ! _sharedEvent._stopped ) result.layer.onPointerUp( _sharedEvent );
			
			
		if( ! _sharedEvent._stoppedToStage ) up.emit(_sharedEvent);
	}
	
    private function prepare (viewX :Float, viewY :Float, hit :Element2D, layer:Layer2D, source :EventSource)
    {
        _x = viewX;
        _y = viewY;
        _sharedEvent.set(_sharedEvent.id+1, viewX, viewY, hit, layer, source);
    }
	

}