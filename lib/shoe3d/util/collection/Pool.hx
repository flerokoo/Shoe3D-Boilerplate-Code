package shoe3d.util.collection;

/**
 * ...
 * @author as
 */
class Pool<A>
{
    /**
     * @param allocator A function that creates a new object.
     */
    public function new (allocator :Void -> A, preallocate:Int = 0)
    {
        _allocator = allocator;
        _freeObjects = [];
		if ( preallocate > 0 )
			for ( i in 0...preallocate )
				put( _allocator() );
		
    }

    /**
     * Take an object from the pool. If the pool is empty, a new object will be allocated.
     *
     * You should later release the object back into the pool by calling `put()`.
     */
    public function take () :A
    {
        if (_freeObjects.length > 0) {
            return _freeObjects.pop();
        }
        var object = _allocator();
        Assert.that(object != null);
        return object;
    }

    /**
     * Put an object into the pool. This should be called to release objects previously claimed with
     * `take()`. Can also be called to pre-allocate the pool with new objects.
     */
    public function put (object :A)
    {
        Assert.that(object != null);
		#if debug
		Assert.that( _freeObjects.indexOf(object) < 0, "This object is already in the pool, you motherfucker!" );
		#end
        if (_freeObjects.length < _capacity) {
            _freeObjects.push(object);
        }
    }

    /**
     * Resizes the pool. If the given size is larger than the current number of pooled objects, new
     * objects are allocated to expand the pool. Otherwise, objects are trimmed out of the pool.
     *
     * @returns This instance, for chaining.
     */
    public function setSize (size :Int) :Pool<A>
    {
        if (_freeObjects.length > size) {
			//resizing on js and flash
			(untyped _freeObjects).length = size;
        } else {
            var needed = size - _freeObjects.length;
            for (ii in 0...needed) {
                var object = _allocator();
                Assert.that(object != null);
                _freeObjects.push(object);
            }
        }
        return this;
    }

    /**
     * Sets the maximum capacity of the pool. By default, the pool can grow to any size.
     *
     * @returns This instance, for chaining.
     */
    public function setCapacity (capacity :Int) :Pool<A>
    {
        if (_freeObjects.length > capacity) {
            //resizing on js and flash
			(untyped _freeObjects).length = capacity;
        }
        _capacity = capacity;
        return this;
    }
	
	

    private var _allocator :Void -> A;
    private var _freeObjects :Array<A>;
    private var _capacity:Int = SMath.INT_MAX;
}