package shoe3d.component;
import shoe3d.core.game.GameObject;
import js.three.BoxGeometry;
import js.three.Mesh;
import js.three.MeshPhongMaterial;
import js.three.SphereGeometry;
import js.three.WireframeHelper;

/**
 * ...
 * @author as
 */
class EasyDebug
{

    public static var display(default, null) :GameObject = new GameObject('EasyDebug');

    public static function drawAABB( x:Float, y:Float, z:Float, w:Float = 1, h:Float = 1, d:Float = 1, color:Int = 0x72C527, wireframe:Bool = false)
    {
        var mesh = new Mesh( new BoxGeometry( w, h, d, 1, 1, 1 ), new MeshPhongMaterial( { transparent: true, color: color, wireframe: wireframe } ) );
        mesh.position.set( x, y, z );
        display.transform.add( mesh );
        return EasyDebug;
    }

    public static function drawSphere( x:Float, y:Float, z:Float, r:Float = 1, color:Int = 0x72C527, wireframe:Bool = false)
    {
        var mesh = new Mesh( new SphereGeometry( r ), new MeshPhongMaterial( { transparent: true, color: color, wireframe: wireframe } ) );
        mesh.position.set( x, y, z );
        display.transform.add( mesh );
        return EasyDebug;
    }

    static public function clear()
    {
        while ( display.transform.children.length > 0 )
            display.transform.remove( display.transform.children[ 0 ] );
        return EasyDebug;
    }

}