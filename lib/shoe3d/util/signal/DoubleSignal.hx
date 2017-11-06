package shoe3d.util.signal;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class DoubleSignal<A,B> extends Signal
{

	public function new() 
	{
		super();
	}
	
	public function connect( callback:A->B->Void, highPriority:Bool = false )
	{
		return connectInner( callback, highPriority );
	}
	
	public function emit( arg1:A, arg2:B )
	{
		if ( isDispatching() )
			throw 'Can\'t emit when dispatching';
			
		var last = _head;
		while ( last != null )
		{
			last._fn( arg1, arg2 );
			if ( last.isOnce ) last.dispose();
			last = last._next;
		}
	}
}