package shoe3d.core.input;
import shoe3d.util.Log;
import shoe3d.util.signal.SingleSignal;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class TouchManager
{
	public var up(default, null):SingleSignal<TouchPoint>;
	public var down(default, null):SingleSignal<TouchPoint>;
	public var move(default, null):SingleSignal<TouchPoint>;
	
	public var points(default, null):Array<TouchPoint>;
	public var maxPoints(default, null):Int;
	
    private var _pointerTouch :TouchPoint;
    private var _pointMap :Map<Int,TouchPoint>;
	private var _pointer:PointerManager;
	
	private var _disabled:Bool = false;
	
	public function get_supported () :Bool
    {
		// TODO add proper detection
        return ! _disabled;
    }
	
	public function new() 
	{
		_pointMap = new Map();
		
		up = new SingleSignal();
		move = new SingleSignal();
		down = new SingleSignal();
		points = [];
		_pointer = System.input.pointer;
	}
	
    public function submitDown (id :Int, viewX :Float, viewY :Float)
    {
        if (!_pointMap.exists(id)) {
            var point = new TouchPoint(id);
            point.set(viewX, viewY);
            _pointMap.set(id, point);
            points.push(point);

            if (_pointerTouch == null) {
                // Make this touch point the tracked pointer
                _pointerTouch = point;
                _pointer.submitDown(viewX, viewY, point._source);
            }
            down.emit(point);
        }
    }

    public function submitMove (id :Int, viewX :Float, viewY :Float)
    {
        var point = _pointMap.get(id);
        if (point != null) {
            point.set(viewX, viewY);

            if (_pointerTouch == point) {
                _pointer.submitMove(viewX, viewY, point._source);
            }
            move.emit(point);
        }
    }

    public function submitUp (id :Int, viewX :Float, viewY :Float)
    {
        var point = _pointMap.get(id);
        if (point != null) {
            point.set(viewX, viewY);
            _pointMap.remove(id);
            points.remove(point);

            if (_pointerTouch == point) {
                _pointerTouch = null;
                _pointer.submitUp(viewX, viewY, point._source);
            }
            up.emit(point);
        }
    }
	
}