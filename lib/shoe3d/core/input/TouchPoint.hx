package shoe3d.core.input;

/**
 * ...
 * @author as
 */
@:allow(shoe3d)
class TouchPoint
{

    public var viewX (default, null) :Float;
    public var viewY (default, null) :Float;
    public var id (default, null) :Int;

    function new (id :Int)
    {
        this.id = id;
        _source = Touch(this);
    }

    function set (viewX :Float, viewY :Float)
    {
        this.viewX = viewX;
        this.viewY = viewY;
    }

    var _source :EventSource;

}