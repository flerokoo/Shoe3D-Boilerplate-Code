package shoe3d.core.input;
import shoe3d.util.signal.SingleSignal;
import shoe3d.util.signal.ZeroSignal;

/**
 * ...
 * @author as
 */
using shoe3d.core.input.KeyCodes;

@:allow( shoe3d )
class KeyboardManager
{

	public var down(default, null):SingleSignal<KeyboardEvent>;
	public var up(default, null):SingleSignal<KeyboardEvent>;
	public var backButton (default, null) :ZeroSignal;
	
	public function new() 
	{
		down = new SingleSignal();
		up = new SingleSignal();
		backButton = new ZeroSignal();
		_keyStates = new Map();

	}
	
	public function onKey( key:Key, handler:KeyboardEvent->Void )
	{
		return up.connect( function(e:KeyboardEvent) if ( e.key == key ) handler(e) );
	}
	
    public function isDown (key :Key) :Bool
    {		
        return isCodeDown( key.toKeyCode() );
    }
	
	public function isJustPressed( key:Key ):Bool
	{
		return isCodeJustPressed( key.toKeyCode() );
	}
	
	public function isCodeDown( code:Int ):Bool
	{
		return _keyStates.exists( code ) &&  _keyStates.get(code) != Up ;
	}
	
	public function isCodeJustPressed( code:Int ):Bool
	{
		return _keyStates.exists( code ) && _keyStates.get(code) == JustPressed;
	}
	
    public function submitDown (keyCode :Int) :Bool
    {
        if (keyCode == KeyCodes.BACK) {
            if (backButton.hasListeners()) {
                backButton.emit();
                return true;
            }
            return false; // No preventDefault
        }
		
        if (! isCodeDown( keyCode ) ) {
            _keyStates.set(keyCode, JustPressed);
            _sharedEvent.set(_sharedEvent.id+1, keyCode.toKey());
            down.emit(_sharedEvent);
        }
		
        return true;
    }	
	
    public function submitUp (keyCode :Int)
    {
        if (isCodeDown(keyCode)) {
            _keyStates.remove(keyCode);
            _sharedEvent.set(_sharedEvent.id+1, keyCode.toKey());
            up.emit(_sharedEvent);
        }
    }	
	
	public function onFrameExit(  )
	{
		for ( i in _keyStates.keys() )
			if ( _keyStates.get(i) == JustPressed )
				_keyStates.set( i, Down );
	}
	
	
	private static var _sharedEvent = new KeyboardEvent();
    private var _keyStates :Map<Int,KeyState>;	
	
}

enum KeyState {
	Down;
	JustPressed;
	Up;
}