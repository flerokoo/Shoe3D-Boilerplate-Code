package shoe3d.component;
import shoe3d.core.game.Component;
import js.three.Geometry;
import js.three.Line;
import js.three.LineBasicMaterial;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class GizmoDisplay extends Component
{

	var _len:Float = 1.5;
	
	public function new( length:Float = 0.5 ) {
		super();
		_len = length;
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.transform.add( getLine( 0, 0, 0, _len, 0, 0, 0xFF0000 ) );
		owner.transform.add( getLine( 0, 0, 0, 0, _len, 0, 0x00FF00 ) );
		owner.transform.add( getLine( 0, 0, 0, 0, 0, _len, 0x0000FF ) );
	}
	
	function getLine( x0:Float, y0:Float, z0:Float, x1:Float, y1:Float, z1:Float, color:Int  ):Line {
		var geom = new Geometry();
		geom.vertices = [ new Vector3( x0, y0, z0 ), new Vector3( x1, y1, z1 ) ];
		var mat = new LineBasicMaterial( { color: color } );
		return new Line( geom, mat );
	}
	
}