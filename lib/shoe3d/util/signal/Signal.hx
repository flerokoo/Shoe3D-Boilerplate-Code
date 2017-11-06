package shoe3d.util.signal;
import shoe3d.util.Disposable;
import shoe3d.util.signal.Sentinel;

/**
 * ...
 * @author as
 */
class Signal
{
	private static var DUMMY:Sentinel = new Sentinel(null, null);
	private var _head:Sentinel;
	

	public function new() 
	{
		
	}
	
	public function hasListeners():Bool {
		return _head != null;
	}
	
	public function connectInner( callback:Dynamic, highPriority:Bool = false )
	{
		var sentinel = new Sentinel( this, callback );
		
		if ( isDispatching() )		
			throw 'Can\'t connect to signal when dispatching';
		
		if ( _head == null )
			_head = sentinel
		else if ( highPriority )
		{
			sentinel._next = _head;
			_head = sentinel;
		}
		else
		{
			var last = _head;
			while ( last._next != null )
				last = last._next;
			last._next = sentinel;
		}
		
		return sentinel;
	}
	
	@:allow(shoe3d)
	private function disconnectInner( sentinel:Sentinel )
	{
		if ( isDispatching() )		
			throw 'Can\'t connect to signal when dispatching';
			
			
		var last:Sentinel = _head;	
		var prev:Sentinel = null;
		while ( last != null )
		{
			if ( last == sentinel )		
			{
				if ( prev == null )
					_head = _head._next;					
				else
				{
					prev._next = last._next;
				}
				return;
			}
			
			prev = last;
			last = last._next;
		}
	}
	
	private inline function isDispatching()
	{
		return _head == DUMMY;
	}
	
	
	
}