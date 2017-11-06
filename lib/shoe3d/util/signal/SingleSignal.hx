package shoe3d.util.signal;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class SingleSignal<A> extends Signal
{

	public function new() 
	{
		super();
	}
	
	public function connect( callback:A->Void, highPriority:Bool = false )
	{
		return connectInner( callback, highPriority );
	}
	
	public function emit( arg:A )
	{
		if ( isDispatching() )
			throw 'Can\'t emit when dispatching';
			
		var last = _head;
		while ( last != null )
		{
			last._fn( arg );
			if ( last.isOnce ) last.dispose();
			last = last._next;
		}
	}
	
}