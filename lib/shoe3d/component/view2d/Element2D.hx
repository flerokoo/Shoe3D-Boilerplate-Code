package shoe3d.component.view2d;
import shoe3d.core.game.Component;
import shoe3d.core.game.GameObject;
import shoe3d.core.input.PointerEvent;
import shoe3d.util.math.Rectangle;
import shoe3d.util.Pointable;
import shoe3d.util.signal.Sentinel;
import shoe3d.util.signal.SingleSignal;
import shoe3d.util.Value;

/**
 * ...
 * @author as
 */
class Element2D extends Component implements Pointable
{
	@:allow(shoe3d) private static var lastLevel = 0;
	@:allow(shoe3d) private static var lastAlpha = 1.0;
	@:allow(shoe3d) private static var preframeConnection:Sentinel;
	
	public var alpha(default,null):Value<Float>;
	public var pointerUp(get, null):SingleSignal<PointerEvent>;
	public var pointerDown(get, null):SingleSignal<PointerEvent>;
	public var pointerMove(get, null):SingleSignal<PointerEvent>;
	public var pointerIn(get, null):SingleSignal<PointerEvent>;
	public var pointerOut(get, null):SingleSignal<PointerEvent>;
	public var anchorX(default, set):Float = 0;
	public var anchorY(default, set):Float = 0;
	
	
	public var _pointerUp:SingleSignal<PointerEvent>;
	public var _pointerDown:SingleSignal<PointerEvent>;
	public var _pointerMove:SingleSignal<PointerEvent>;
	public var _pointerIn:SingleSignal<PointerEvent>;
	public var _pointerOut:SingleSignal<PointerEvent>;	
	public var pointerEnabled:Bool = true;
	
	private var _globalAlpha:Float = 1;
	private var _hovering:Bool = false;
	private var _hoverConnection:Sentinel;
	
	public function new( ) 
	{		
		super();
		alpha = new Value(1.0);
		if( preframeConnection == null ) {
			preframeConnection = System._loop._preframe.connect(function(){
				lastLevel = 0;
			});
		}
	}
	
	public function getBounds():Rectangle
	{
		return new Rectangle();
	}
	
	public function contains( x:Float, y:Float ):Bool
	{
		return false;
	}
	
	public function setAnchor( x:Float = 0, y:Float = 0 )
	{
		anchorX = x;
		anchorY = y;
		//updateAnchor();
		return this;
	}
	
	public function setAnchorRelative(x:Float = 0, y:Float = 0)
	{
		throw 'Not working rn';
		var bounds = getBounds();		
		anchorX = x * bounds.width;
		anchorY = y * bounds.height;
		return this;
	}
	
	function set_anchorY(value:Float):Float 
	{
		anchorY = value;
		updateAnchor();
		return anchorY;
	}
	
	function set_anchorX(value:Float):Float 
	{
		anchorX = value;
		updateAnchor();
		return anchorX;
	}
	
	function updateAnchor()
	{
	}
	
	public function centerAnchor() 
	{
		return this;
	}
	
	public function setAlpha( a:Float ):Element2D
	{
		alpha._ = a;
		return this;
	}
	
	function setLevel( level:Float ):Element2D
	{
		return this;
	}
	
	function setPremultipliedAlpha( alpha:Float ):Element2D
	{
		
		return this;
	}
	
	override public function onUpdate()
	{
		setLevel( lastLevel++ );
		//lastAlpha *= alpha._;
		//setPremultipliedAlpha( lastAlpha );
		
		if ( alpha._ == 0 ) {
			_globalAlpha = 0;
			setPremultipliedAlpha(0);
		} else {
			var upper = getParentElement2D();
			if ( upper == null ) {
				_globalAlpha = alpha._;
				setPremultipliedAlpha( alpha._ );
			} else {
				_globalAlpha = upper._globalAlpha * alpha._;
				setPremultipliedAlpha( _globalAlpha );
			}
		}
	}
	
	public function getParentElement2D():Element2D
	{
		if ( owner == null ) return null;
		var e = owner.parent;
		while ( e != null )
		{
			var r = e.get( Element2D );
			if ( r != null ) return r;
			e = e.parent;
		}
		
		return null;
	}
	
	public static function hitTest(entity :GameObject, x :Float, y :Float)
	{
		var sprite = entity.get(Element2D);
        if (sprite != null ) {
            if (sprite.alpha._ <= 0 || ! sprite.pointerEnabled) {
                return null; // Prune invisible or non-interactive subtrees
            }
		}

        // Hit test all children, front to back
        var result = hitTestBackwards(entity.children[0], x, y);
        if (result != null) {
            return result;
        }

        // Finally, if we got this far, hit test the actual sprite
        return (sprite != null && sprite.contains(x, y)) ? sprite : null;
	}
	
	public static function hitTestBackwards(entity :GameObject, x :Float, y :Float)
	{
		if (entity != null) {
			 var result = hitTestBackwards(
				entity.parent != null 
				? entity.parent.children[ entity.parent.children.indexOf(entity) + 1 ] 
				: null, x, y);
            return (result != null) ? result : hitTest(entity, x, y);
        }
        return null;
	}
	
	@:allow(shoe3d) 
	private function onPointerDown(e:PointerEvent )
	{
		onHover(e);
		if ( pointerDown != null ) {
			pointerDown.emit( e );
		}
	}
	
	@:allow(shoe3d) 
	private function onHover( e:PointerEvent )
	{
		if ( _hovering ) return;
		_hovering = true;
		if ( _pointerIn != null || _pointerOut != null )
		{
			if ( _pointerIn != null )
				_pointerIn.emit( e );
			connectHover();
		}
	}
	
    private function connectHover ()
    {
        if (_hoverConnection != null) {
            return;
        }
        _hoverConnection = System.input.pointer.move.connect(function (event) {
			
            // Return early if this sprite was in the event chain
			
            var hit = event.hit;
            while (hit != null) {
                if (hit == this) {
                    return;
                }
                hit = hit.getParentElement2D();
            }
            // This sprite is not under the pointer
            if (_pointerOut != null && _hovering) {
                _pointerOut.emit(event);
            }
            _hovering = false;
            _hoverConnection.dispose();
            _hoverConnection = null;
        });
    }
	
	@:allow(shoe3d) 
	private function onPointerMove( e:PointerEvent )
	{
		onHover(e);
		if ( _pointerMove != null )
			_pointerMove.emit(e);
	}
	
	@:allow(shoe3d) 
	private function onPointerUp( event:PointerEvent )
	{
		switch(event.source)
		{
			case Touch(touchpoint):
				if ( _pointerOut != null && _hovering )
					_pointerOut.emit(event);
				_hovering = false;
				if ( _hoverConnection != null )
				{
					_hoverConnection.dispose();
					_hoverConnection = null;
				}
			default:
		}
		
		if ( _pointerUp != null )
			_pointerUp.emit(event);
	}	
	
	function get_pointerDown():SingleSignal<PointerEvent> 
	{
		if ( _pointerDown == null ) _pointerDown = new SingleSignal();
		return _pointerDown;
	}
	
	function get_pointerUp():SingleSignal<PointerEvent> 
	{
		if ( _pointerUp == null ) _pointerUp = new SingleSignal();
		return _pointerUp;
	}
	
	function get_pointerMove():SingleSignal<PointerEvent> 
	{
		if ( _pointerMove == null ) _pointerMove = new SingleSignal();
		return _pointerMove;
	}
	
	function get_pointerIn():SingleSignal<PointerEvent> 
	{
		if ( _pointerIn == null ) _pointerIn = new SingleSignal();
		return _pointerIn;
	}	
	
	function get_pointerOut():SingleSignal<PointerEvent> 
	{
		if ( _pointerOut == null ) _pointerOut = new SingleSignal();
		return _pointerOut;
	}
	
	override public function dispose() 
	{
		alpha = null;
				
		_pointerUp = null;
		_pointerDown = null;
		_pointerMove = null;
		_pointerIn = null;
		_pointerOut = null;	
		pointerEnabled = null;
		if ( _hoverConnection != null ) _hoverConnection.dispose();
		_hoverConnection = null;
		
		super.dispose();
	}
}