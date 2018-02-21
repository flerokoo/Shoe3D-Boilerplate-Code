package shoe3d.util.math;
import js.three.Vector2;

/**
 * ...
 * @author as
 */
class Rectangle
{

    public var x:Float = 0;
    public var y:Float = 0;
    public var width:Float = 0;
    public var height:Float = 0;

    public function new( x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public function set( x:Float, y:Float, ?width:Float, ?height:Float)
    {
        if ( x != null ) this.x = x;
        if ( y != null ) this.y = y;
        if ( width != null ) this.width = width;
        if ( height != null ) this.height = height;
    }

    public function isXYInside( x:Float, y:Float )
    {
        var c = getCenter();
        return Math.abs( c.x - x ) <= width / 2 && Math.abs(c.y - y) <= height / 2;
    }

    public function isVector2Inside( v:Vector2 )
    {
        var c = getCenter();
        return Math.abs( c.x - v.x ) <= width / 2 && Math.abs(c.y - v.y) <= height / 2;
    }

    public function getCenter():Vector2
    {
        return new Vector2( x + width / 2, y + width / 2 );
    }

}