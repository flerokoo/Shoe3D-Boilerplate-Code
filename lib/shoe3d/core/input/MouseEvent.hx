package shoe3d.core.input;

/**
 * ...
 * @author as
 */
class MouseEvent
{

    public var viewX(default, null):Float = 0;
    public var viewY(default, null):Float = 0;
    public var button(default, null):MouseButton = null;
    public var id(default, null):Int = 0;
    @:allow(shoe3d) public function new()
    {

    }

    @:allow(shoe3d) function set( id:Int, viewX:Float, viewY:Float, button:MouseButton ):MouseEvent
    {
        this.id = id;
        this.viewX = viewX;
        this.viewY = viewY;
        this.button = button;
        return this;
    }
}

enum MouseButton
{
    Left;
    Right;
    Middle;
    Unknown(code:Int);
}