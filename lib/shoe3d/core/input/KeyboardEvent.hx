package shoe3d.core.input;

/**
 * ...
 * @author as
 */
class KeyboardEvent
{

    public var key(default, null):Key;

    public var id(default, null):Int = 0;

    @:allow(shoe3d) public function new()
    {

    }

    @:allow(shoe3d) function set( id:Int, key:Key ):KeyboardEvent
    {
        this.id = id;
        this.key = key;
        return this;
    }
}

