package shoe3d.component;
import shoe3d.core.game.Component;
import shoe3d.util.Assert;
import js.three.Geometry;
import js.three.Line;
import js.three.LineBasicMaterial;
import js.three.Mesh;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class GridDisplay extends Component
{

    var _size:Int;
    var _step:Int;

    public function new( size:Int = 10, step:Int = 1 )
    {
        super();
        _size =  size;
        _step = step;
        Assert.that( _size > _step, "Size must be more that step" );
    }

    override public function onAdded()
    {
        var geom = new Geometry();

        var t = 0;
        var flag = true;
        var i = 0;
        while (t < _size)
        {

            if ( flag )
            {
                geom.vertices[i] = new Vector3( _size / 2, 0, -_size / 2 + t );
                geom.vertices[i+1] = new Vector3( -_size / 2, 0,-_size / 2 + t );
            }
            else
            {
                geom.vertices[i] = new Vector3( -_size / 2, 0, -_size / 2 + t );
                geom.vertices[i+1] = new Vector3( _size / 2, 0, -_size / 2 + t );
            }
            i+=2;
            flag = !flag;
            t += _step;
        }

        t = 0;
        flag = true;
        while (t < _size)
        {

            if ( flag )
            {
                geom.vertices[i] = new Vector3( -_size / 2 + t, 0, _size / 2 );
                geom.vertices[i+1] = new Vector3( -_size / 2 + t, 0, -_size / 2 );
            }
            else
            {
                geom.vertices[i] = new Vector3( -_size / 2 + t, 0, -_size / 2 );
                geom.vertices[i+1] = new Vector3( -_size / 2 + t, 0, _size / 2 );
            }
            i+=2;
            flag = !flag;
            t += _step;
        }
        geom.verticesNeedUpdate = true;
        owner.transform.add( new Line( geom, new LineBasicMaterial( { color: 0x797979, transparent: true, opacity: 0.1 } ) ) );
    }

}