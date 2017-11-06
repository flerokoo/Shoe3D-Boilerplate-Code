package shoe3d.core.input;
import shoe3d.core.input.MouseEvent.MouseButton;
import shoe3d.util.signal.SingleSignal;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class MouseManager
{
	public var up(default, null):SingleSignal<MouseEvent>;
	public var down(default, null):SingleSignal<MouseEvent>;
	public var move(default, null):SingleSignal<MouseEvent>;
	public var scroll(default, null):SingleSignal<Float>;
	
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var cursor(get, set):MouseCursor;
	
	private var _cursor :MouseCursor = Default;
	private var _buttonStates :Map<Int,Bool>;
    private var _source :EventSource;
    private static var _sharedEvent = new MouseEvent();	
	
	public function new( ) 
	{
		_buttonStates = new Map();
		up = new SingleSignal();
		down = new SingleSignal();
		move = new SingleSignal();
		scroll = new SingleSignal();
		_source = Mouse(_sharedEvent);
	}
	
    public function set_cursor (cursor :MouseCursor) :MouseCursor
    {
        var name;
        switch (cursor) {
            case Default: name = ""; // inherit
            case Button: name = "pointer";
            case None: name = "none";
        }
        System.input._canvas.style.cursor = name;

        return _cursor = cursor;
    }
	
    public function get_cursor () :MouseCursor
    {
        return _cursor;
    }
	
    public function isDown (button :MouseButton) :Bool
    {
        return isCodeDown(toButtonCode(button));
    }

    inline private function isCodeDown (buttonCode :Int) :Bool
    {
        return _buttonStates.exists(buttonCode);
    }	
	
    public function submitDown (viewX :Float, viewY :Float, buttonCode :Int)
    {
        if (!isCodeDown(buttonCode)) {
            _buttonStates.set(buttonCode, true);

            prepare(viewX, viewY, toButton(buttonCode));
            System.input.pointer.submitDown(viewX, viewY, _source);
			// TODO: maybe add check if event is stopeed?
            down.emit(_sharedEvent);
        }
    }

    public function submitMove (viewX :Float, viewY :Float)
    {
        prepare(viewX, viewY, null);
        System.input.pointer.submitMove(viewX, viewY, _source);
        move.emit(_sharedEvent);
    }

    public function submitUp (viewX :Float, viewY :Float, buttonCode :Int)
    {
        if (isCodeDown(buttonCode)) {
            _buttonStates.remove(buttonCode);
            prepare(viewX, viewY, toButton(buttonCode));
            System.input.pointer.submitUp(viewX, viewY, _source);
            up.emit(_sharedEvent);
        }
    }

    public function submitScroll (viewX :Float, viewY :Float, velocity :Float) :Bool
    {
        x = viewX;
        y = viewY;
        if (!scroll.hasListeners()) {
            return false;			
        }
        scroll.emit(velocity);
        return true;
    }
	
	public function get_supported () :Bool
    {
        return true;
    }
		
    private function prepare (viewX :Float, viewY :Float, button :MouseButton)
    {
        x = viewX;
        y = viewY;
        _sharedEvent.set(_sharedEvent.id+1, viewX, viewY, button);
    }
	
	public static inline var LEFT = 0;
    public static inline var MIDDLE = 1;
    public static inline var RIGHT = 2;

    public static function toButton (buttonCode :Int) :MouseButton
    {
        switch (buttonCode) {
            case LEFT: return Left;
            case MIDDLE: return Middle;
            case RIGHT: return Right;
        }

        return Unknown(buttonCode);
    }

    public static function toButtonCode (button :MouseButton) :Int
    {
        switch (button) {
            case Left: return LEFT;
            case Middle: return MIDDLE;
            case Right: return RIGHT;

            case Unknown(buttonCode): return buttonCode;
        }
    }
}