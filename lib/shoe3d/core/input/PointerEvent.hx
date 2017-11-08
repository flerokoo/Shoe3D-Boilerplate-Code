package shoe3d.core.input;
import shoe3d.component.view2d.Element2D;
import shoe3d.core.Layer2D;

/**
 * ...
 * @author as
 */
class PointerEvent
{
	public var viewX (default, null) :Float = 0;
    public var viewY (default, null) :Float = 0;
    public var hit (default, null) :Element2D = null;
    public var layer (default, null) :Layer2D= null;
    public var source (default, null) :EventSource = null;	
    public var id (default, null) :Int = 0;
	@:allow(shoe3d) var _stopped :Bool;
	@:allow(shoe3d) var _stoppedToStage :Bool;
	
    @:allow(shoe3d) function new ()
    {
    }
	
	@:allow(shoe3d) function set (id :Int, viewX :Float, viewY :Float, hit :Element2D, layer:Layer2D, source :EventSource)
    {
        this.id = id;
        this.viewX = viewX;
        this.viewY = viewY;
        this.hit = hit;
        this.source = source;
        this.layer = layer;
        _stopped = false;
        _stoppedToStage = false;
    }
	
	inline public function stopPropagation ()
    {
        _stopped = true;
    }
	
	inline public function preventGlobalEvent ()
    {
        _stoppedToStage = true;
    }	
	
}